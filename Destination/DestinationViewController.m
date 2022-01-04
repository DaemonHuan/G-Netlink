//
//  DestinationViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/31/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "DestinationViewController.h"
#import "public.h"
#import "DestinationSearchViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#define LONGPRESS_POINT_NAME @"自选点"

@interface DestinationViewController () <MAMapViewDelegate, PostSessionDataDelegate, AMapSearchDelegate>

@end

@implementation DestinationViewController {
    IBOutlet UIButton * bt_send;
    IBOutlet UIImageView * iv_icon;
    IBOutlet UILabel * la_addresstitle;
    IBOutlet UILabel * la_addressvalue;
    IBOutlet UIView * vi_detail;
    IBOutlet UIView * vi_search;
    IBOutlet UILabel * la_destination;
    
    CLLocationCoordinate2D m_locationPoint;  // 定位location
//    CLLocationCoordinate2D m_vehiclePoint;   // vehicle location
    CLLocationCoordinate2D m_selectedPoint;     // 选中点
    CLLocationCoordinate2D m_longpressedPoint;  // 长按选点

    BOOL m_locationflag;
    BOOL m_longpressedFlag;
    NSString * m_selectedPointName;
    GetPostSessionData * postSession;
    NSMutableArray * m_arrmapPois;
    
    MAMapView * m_mapView;
    AMapSearchAPI * m_search;
    ProcessBoxCommandView * m_loadingview;
    NSString * m_cityForLocation;
    NSString * m_cityForSuggestion;
    NSMutableArray * m_arrAnnotations;
    DestinationSearchViewController * m_inputSearchView;
    BOOL m_searchFlag;
    
    UIButton * bt_mapfocus;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"发送目的地"];

    //
    [iv_icon setImage:[UIImage imageNamed: @"map_normalpoint"]];
    [la_addresstitle setTextColor:[UIColor whiteColor]];
    [la_addresstitle setText:@""];
    [la_addresstitle setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE2]];
    [la_addressvalue setTextColor:[UIColor whiteColor]];
    [la_addressvalue setText:@""];
    [la_addressvalue setFont:[UIFont fontWithName:FONT_XI size:FONT_S_WORD]];
    
    //
    [vi_detail setHidden:YES];
    m_arrmapPois = [[NSMutableArray alloc]init];
    m_arrAnnotations = [[NSMutableArray alloc]init];
    
    // 模拟数据 FLAG
    CGFloat height = 0.0f;
    if ([self.UserInfo isRunDemo]) {
        [self.view addSubview: [ExtendStaticView MarkDemoView]];
        height = 30.0f;
    }
    
    CGFloat aw = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat ah = CGRectGetHeight([UIScreen mainScreen].bounds);

    CGRect mapFrame = CGRectMake(0.0f, 64.0f, aw, ah - 64.0f - height);
    m_mapView = [[MAMapView alloc] init];
    m_mapView.delegate = self;
    m_mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    [m_mapView setFrame: mapFrame];
    [m_mapView setRotateEnabled:NO];
    [m_mapView setRotateCameraEnabled:NO];
    
    // 显示定位信息 需要 info.plist NSLocationWhenInUseUsageDescription[String]
    m_mapView.userTrackingMode = MAUserTrackingModeFollow;
    m_mapView.showsUserLocation = YES;
    m_mapView.showsCompass = NO;
    m_mapView.showsScale = NO;
    [m_mapView setZoomLevel:16.1 animated:YES];
    [self.view insertSubview:m_mapView atIndex:0];
    
    bt_mapfocus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bt_mapfocus.frame = CGRectMake(aw - 50.0f, ah * 0.8f - 64.0f - 75.0f - 50.0f, 40.0f, 40.0f);
    bt_mapfocus.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [bt_mapfocus setBackgroundImage:[UIImage imageNamed:@"location_button"] forState:UIControlStateNormal];
    [bt_mapfocus addTarget:self action:@selector(mapViewReset:) forControlEvents:UIControlEventTouchUpInside];
    [m_mapView addSubview: bt_mapfocus];

    m_search = [[AMapSearchAPI alloc] init];
    m_search.delegate = self;
    m_searchFlag = NO;
    m_longpressedFlag = NO;

    vi_search.layer.cornerRadius = 5.0f;
    UITapGestureRecognizer * singleTouchUp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSearchView)];
    [vi_search addGestureRecognizer:singleTouchUp];
    m_locationflag = YES;
    
    m_loadingview = [[ProcessBoxCommandView alloc]initWithMessage:@""];
    [m_loadingview setFrame:CGRectMake(0.0f, (ah * 0.8f) - 65.0f, aw, 65.0f)];
    [self.view addSubview:m_loadingview];
    [m_loadingview hideView];
    
    //
//    m_loadingview = [[ProcessBoxView alloc]initWithMessage: @""];
//    [m_loadingview hideView];
//    [self.view addSubview:m_loadingview];
    postSession = [[GetPostSessionData alloc] init];
    postSession.delegate = self;
    
    m_inputSearchView = [[DestinationSearchViewController alloc]init];
//    [self sendPostSessionForLocation];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.view setHidden:NO];
    
    if (m_inputSearchView.result != nil && ![m_inputSearchView.result isEqualToString:@""]) {
        m_mapView.showsUserLocation = NO;
        [m_mapView removeAnnotations: m_arrAnnotations];
        [m_arrAnnotations removeAllObjects];
        [self doMaPoiSearch: m_inputSearchView.result City:m_cityForLocation];
        
        // 显示搜索结果后隐藏 定位坐标和聚焦按钮
        m_mapView.showsUserLocation = NO;
        [bt_mapfocus setHidden:YES];
    }
}

- (IBAction) mapViewReset:(id)sender  {
    [m_mapView setZoomLevel:16.1 animated:YES];
    [m_mapView showAnnotations:m_mapView.annotations animated:YES];
}

- (void) showSearchView {
    [self.view setHidden:YES];
    m_inputSearchView.m_cityForLocation = m_cityForLocation;
    [self.navigationController pushViewController:m_inputSearchView animated:YES];
}

- (IBAction)sendPostSessionForDestination: (id)sender {
    [m_loadingview setTitile:@"指令下发中 .."];
    [m_loadingview showView];
    [bt_send setEnabled:NO];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/sendPOIToCar", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"%@&poiName=%@&poiLontitude=%f&poiLatitude=%f&vin=%@", self.userfixstr, m_selectedPointName, m_selectedPoint.longitude, m_selectedPoint.latitude, [self.UserInfo gDefaultVehicleVin]];
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    if ([request isEqualToString:@"NSURLErrorNetworkConnectionLost"]) {
        [m_loadingview hideView];
        [bt_send setEnabled:YES];
        return;
    }
    
    if ([request isEqualToString:@"jk-Error"]) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:NETWORK_ERROR];
        [alertview show];
        [m_loadingview hideView];
        [bt_send setEnabled:YES];
        return;
    }
    
    NSString * code = nil;
    NSDictionary * mdic = [postSession getDictionaryFromRequest];
    if ([[mdic allKeys] containsObject:@"status"]) {
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"指令执行成功!"];
            [alertview show];
        }
        else if ([code isEqualToString:@"402"]) {
            [(MainNavigationController *)self.navigationController doLogoff:self.userfixstr];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyRunStatus Value:@"OTHERLINE"];
        }
        else {
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"指令执行失败。"];
            [alertview show];
        }
    }
    
    [m_loadingview hideView];
    [bt_send setEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// do map poi search
- (void) doMaPoiSearch: (NSString *)keywords City:(NSString *)city {
    [m_loadingview setTitile:@"目的地搜索中\n请稍后..."];
    [m_loadingview showView];
    
    //初始化检索对象
    AMapPOIKeywordsSearchRequest * request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.city = city;
    request.keywords = keywords;
    request.requireExtension = YES;
    
    [m_search AMapPOIKeywordsSearch: request];
    [m_arrmapPois removeAllObjects];
    NSLog(@"POI Search in keywords: %@", request);
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count > 0)
    {
        for (AMapPOI * p in response.pois) {
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
            pointAnnotation.title = p.name;
            
            /* 将结果以annotation的形式加载到地图上. */
            [m_arrAnnotations addObject:pointAnnotation];
            [m_arrmapPois addObject:p];
            [m_mapView addAnnotation:pointAnnotation];
        }
        [m_loadingview hideView];
    }
    else {
        if (!m_searchFlag) {
            m_searchFlag = YES;
            AMapPOIKeywordsSearchRequest * nextRequest = (AMapPOIKeywordsSearchRequest *)request;
            
            if ([response.suggestion.cities count] > 0) {
                AMapCity * scity = [response.suggestion.cities objectAtIndex:0];
                [self doMaPoiSearch:nextRequest.keywords City:scity.city];
            }
            else {
                m_searchFlag = NO;
                [m_loadingview hideView];
                
                AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton: @"未搜索到目的地，换一换关键字试试"];
                [alert show];
                return;
            }

        }
        else {
            m_searchFlag = NO;
            [m_loadingview hideView];

            AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton: @"未搜索到目的地，换一换关键字试试"];
            [alert show];
            return;
        }
        
    }
    
//    [m_mapView setZoomLevel:16.1 animated:YES];
    [m_mapView showAnnotations:m_mapView.annotations animated:YES];
    if (response.pois.count > 0) {
        AMapPOI * p = response.pois[0];
        for (id<MAAnnotation> lp in m_mapView.annotations) {
            if ([lp coordinate].longitude == p.location.longitude &&
                [lp coordinate].latitude == p.location.latitude) {
                [m_mapView selectAnnotation:lp animated:YES];
                break;
            }
        }
        m_mapView.centerCoordinate = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
    }
}

// Map Functions
- (void) mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if(updatingLocation && m_locationflag)
    {
        //取出当前位置的坐标
        NSLog(@"latitude: %f, longitude: %f",userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        m_locationPoint.longitude = userLocation.coordinate.longitude;
        m_locationPoint.latitude = userLocation.coordinate.latitude;
//        m_locationflag = NO;
        
        // 获取当前城市 提供关键字搜索
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        regeo.radius = 10000;
        regeo.requireExtension = YES;
        
        //发起逆地理编码
        [m_search AMapReGoecodeSearch: regeo];
    }
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (!m_longpressedFlag) {
        NSLog(@"%@", response.regeocode.addressComponent.province);
        m_cityForLocation = response.regeocode.addressComponent.province;
    }
    else {
        [la_addresstitle setText: LONGPRESS_POINT_NAME];
        [la_destination setText: LONGPRESS_POINT_NAME];
        [la_addressvalue setText:response.regeocode.formattedAddress];
        m_longpressedFlag = NO;
    }
}

// 地图长按选点
- (void) mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"longPressed - %f %f", coordinate.latitude, coordinate.longitude);
    
    [vi_detail setHidden:YES];
    m_longpressedFlag = YES;
    
    // 清除上一个自选点
    for (id<MAAnnotation> lp in m_mapView.annotations) {
        if ([lp coordinate].longitude == m_longpressedPoint.longitude && [lp coordinate].latitude == m_longpressedPoint.latitude) {
            [m_mapView removeAnnotation:lp];
            break;
        }
    }

    /* 将结果以annotation的形式加载到地图上. */
    MAPointAnnotation *newpointAnnotation = [[MAPointAnnotation alloc] init];
    newpointAnnotation.coordinate = coordinate;
    newpointAnnotation.title = LONGPRESS_POINT_NAME;
    m_longpressedPoint = coordinate;
    [m_mapView addAnnotation:newpointAnnotation];
    [m_mapView selectAnnotation:newpointAnnotation animated:YES];

    // 得到地理搜索结果后 显示详细页
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:m_longpressedPoint.latitude longitude:m_longpressedPoint.longitude];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [m_search AMapReGoecodeSearch: regeo];

    [la_addresstitle setText:@"加载中 .."];
    [la_addressvalue setText:@"加载中 .."];
    [vi_detail setHidden:NO];
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    id<MAAnnotation> annotation = view.annotation;
    MAPointAnnotation * selectedAnnotation = (MAPointAnnotation *)annotation;
    NSLog(@"map selected annotation %f %f", selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude);
    
    // 判断选中标记点是否是 搜索的兴趣点和自选点
    BOOL showFlag = NO;
    for (AMapPOI * p in m_arrmapPois) {
        if (p.location.latitude == selectedAnnotation.coordinate.latitude &&
            p.location.longitude == selectedAnnotation.coordinate.longitude) {
            
            view.image = [UIImage imageNamed:@"map_selectpoint"];

            showFlag = YES;
            [la_addresstitle setText:p.name];
            [la_destination setText: p.name];
            m_selectedPointName = [NSString stringWithString:p.name];
            [la_addressvalue setText: p.address];
            break;
        }
    }
    
    if (selectedAnnotation.coordinate.latitude == m_longpressedPoint.latitude && selectedAnnotation.coordinate.longitude == m_longpressedPoint.longitude) {
        view.image = [UIImage imageNamed:@"map_selectpoint"];
        m_selectedPointName = LONGPRESS_POINT_NAME;
        showFlag = YES;
    }
    [vi_detail setHidden: !showFlag];
    
    // 恢复前一个选中的标记点的view
    if (selectedAnnotation.coordinate.latitude != m_selectedPoint.latitude && selectedAnnotation.coordinate.longitude != m_selectedPoint.longitude) {
        for (MAPointAnnotation * notation in [m_mapView annotations]) {
            if (m_selectedPoint.latitude == notation.coordinate.latitude && m_selectedPoint.longitude == notation.coordinate.longitude) {
                [m_mapView removeAnnotation:notation];
                [m_mapView addAnnotation:notation];
                break;
            }
        }
        
        if (m_selectedPoint.latitude == m_longpressedPoint.latitude && m_selectedPoint.longitude == m_longpressedPoint.longitude) {
            for (id<MAAnnotation> lp in m_mapView.annotations) {
                if ([lp coordinate].longitude == m_longpressedPoint.longitude && [lp coordinate].latitude == m_longpressedPoint.latitude) {
                    [m_mapView removeAnnotation:lp];
                    m_longpressedPoint.latitude = 0;
                    m_longpressedPoint.longitude = 0;
                    break;
                }
            }
        }
    }
//    [m_mapView showAnnotations:m_mapView.annotations animated:YES];
    m_selectedPoint = selectedAnnotation.coordinate;
}

- (void) mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    [vi_detail setHidden:YES];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString * pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView * annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.canShowCallout = YES;
        [annotationView setSelected:NO];
        annotationView.highlighted = YES;
        annotationView.image = [UIImage imageNamed:@"map_normalpoint"];

        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0.0f, -18.0f);
        return annotationView;
    }
    
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"map_location"];
        annotationView.centerOffset = CGPointMake(0.0f, -18.0f);
        return annotationView;
    }
    
    return nil;
}

// /* 自定义定位精度对应的MACircleView. */
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    return nil;     // 去掉点的精度圈
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
