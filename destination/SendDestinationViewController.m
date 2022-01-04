//
//  SendDestinationViewController.m
//  G-Netlink-beta0.2
//
//  Created by jk on 11/4/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "SendDestinationViewController.h"
#import "DestinationDetailView.h"
#import "MainNavigationController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#import "GetPostSessionData.h"
#import "jkAlertController.h"
#import "jkProcessView.h"
#import "public.h"
#import "GNLUserInfo.h"
#import "UIColor+Hex.h"

#define LONGPRESS_POINT_NAME @"自选点"

@interface SendDestinationViewController () <MAMapViewDelegate, AMapSearchDelegate, PostSessionDataDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    MAMapView * m_mapView;
    AMapSearchAPI * m_search;
    NSString * bundleIdentifier;
    jkProcessView * m_processview;
    
    CLLocationCoordinate2D m_userPoint;         // 用户当前位置
    CLLocationCoordinate2D m_vehiclePoint;      // 车机位置
    CLLocationCoordinate2D m_selectedPoint;     // 选中点
    CLLocationCoordinate2D m_longpressedPoint;  // 长按选点
    
//    AMapPOI * m_SelectedPoint;
    NSMutableArray * m_annotations;
    NSMutableArray * m_mapPOI;
    NSString * m_longpressedAddress;
    
    //
    UITextField * tf_searchKeywords;
    DestinationDetailView * destinationView;
    
    GetPostSessionData * postSession;
    IBOutlet UITableView * m_tableview;
    NSMutableArray * m_searchTips;
    NSString * m_city;
    NSString * m_secondcity;
    NSInteger m_secondsearch;
}

@end

@implementation SendDestinationViewController {
    IBOutlet UIView * m_mapview;
}
//@synthesize request;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_menuicon"] style:UIBarButtonItemStylePlain target:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 向右滑动显示菜单
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    recognizer.delegate = self;
    [[self view] addGestureRecognizer:recognizer];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"destination_search"] style:UIBarButtonItemStylePlain target:self action:@selector(doSearch)];
    [rightItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    m_searchTips = [[NSMutableArray alloc]init];
    [m_tableview setHidden: YES];
    m_city = @"";
    m_secondcity = @"";
    m_secondsearch = 0;
    
// navigation bar fix textfied
    CGFloat ax = [UIScreen mainScreen].bounds.size.width;
    UIView * barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.7*ax, 30.0f)];
    
    tf_searchKeywords = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0.7*ax, 30.0f)];
    [tf_searchKeywords setTextColor: [UIColor whiteColor]];
    [tf_searchKeywords setFont: [UIFont fontWithName: FONT_MM size: 17.0]];
    [tf_searchKeywords addTarget:self action:@selector(textfield_didEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [tf_searchKeywords addTarget:self action:@selector(doInputTipsSearch) forControlEvents:UIControlEventEditingChanged];
    [tf_searchKeywords setPlaceholder:@"请输入目的地"];
    tf_searchKeywords.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入目的地" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString: @"FFFFFF" alpha: 0.5f]}];
    tf_searchKeywords.returnKeyType = UIReturnKeyDone;
    [barView addSubview:tf_searchKeywords];
    
    UIImageView * line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 28.0f, 0.7*ax, 1.0f)];
    [line setImage: [UIImage imageNamed:@"public_seperateline02"]];
    [barView addSubview:line];
    self.navigationItem.titleView = barView;

    destinationView = [[DestinationDetailView alloc]init];
    [destinationView loadView];
    [self.view addSubview:destinationView];
   // init array
    m_annotations = [NSMutableArray array];
    m_mapPOI = [NSMutableArray array];
    
    CGFloat extend = 0.0f;
    if ([GNLUserInfo isDemo]) {
        [self.view addSubview: [ServicesPro loadMarkDemoView]];
        extend = 30.0f;
    }
    
    [MAMapServices sharedServices].apiKey = MAP_BUNDLEIDENTIFIER;
    m_search = [[AMapSearchAPI alloc]initWithSearchKey:MAP_BUNDLEIDENTIFIER Delegate:self];
    
    m_mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64.0f - extend)];
    [m_mapview addSubview: m_mapView];
    
    m_mapView.delegate = self;

    // post session
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
    
    m_processview = [[jkProcessView alloc]initWithMessage:@""];
    [m_processview tohide];
    [self.view addSubview:m_processview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self sendPostSessionForLocation];
    
    

    m_mapView.showsCompass = NO;
    m_mapView.showsScale = NO;
    m_mapView.showsUserLocation = YES;
    [m_mapView setRotateEnabled:NO];
    [m_mapView setRotateCameraEnabled:NO];

    [m_mapView setZoomEnabled:YES];
    [m_mapView setZoomLevel:16.1 animated:YES];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString * ttlatitude = [userDefault objectForKey:USERINFO_CAR_LATITUDE];
    NSString * ttlongitude = [userDefault objectForKey:USERINFO_CAR_LONGITUDE];
    
    [m_mapView setCenterCoordinate:CLLocationCoordinate2DMake([ttlatitude floatValue], [ttlongitude floatValue])];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

// lineedit search

- (void) doInputTipsSearch  {
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = tf_searchKeywords.text;
    tipsRequest.city = @[m_city,@""];
    
    //发起输入提示搜索
    [m_search AMapInputTipsSearch: tipsRequest];
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        return;
    }

    [m_searchTips removeAllObjects];
    [m_tableview setHidden: NO];
    
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    for (AMapTip *p in response.tips) {
        [m_searchTips addObject:p.name];
    }
    [m_tableview reloadData];
}

- (void) doMapSearch: (NSString *) keywords {
    [m_tableview setHidden: YES];
    m_secondsearch += 1;
    
    NSArray * cities;
    if (m_secondsearch == 1) {
        cities = [[NSArray alloc]initWithObjects:m_city, nil];
    }
    else if (m_secondsearch == 2) {
        cities = [[NSArray alloc]initWithObjects:m_secondcity, nil];
    }
    
    //初始化检索对象
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType = AMapSearchType_PlaceKeyword;
    request.city = cities;
    request.keywords = keywords;
    request.requireExtension = YES;
    
    [m_search AMapPlaceSearch: request];
    cities = nil;
    NSLog(@"POI Search in keywords: %@", request);
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    NSLog(@"Request: %@", request);
    //    NSLog(@"response: %@", response);
    
    if (response.pois.count > 0)
    {
        for (AMapPOI *p in response.pois) {
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
            pointAnnotation.title = p.name;
            
            /* 将结果以annotation的形式加载到地图上. */
            [m_mapView addAnnotation:pointAnnotation];
            [m_annotations addObject:pointAnnotation];
            [m_mapPOI addObject:p];
        }
    }
    else {
        if (m_secondsearch == 1 && [response.suggestion.cities count] > 0) {
            AMapCity * scity = [response.suggestion.cities objectAtIndex:0];
            m_secondcity = scity.citycode ;
            [self doMapSearch:tf_searchKeywords.text];
        }
        else if (m_secondsearch == 2) {
            jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"未搜索到目的地，换一换关键字试试"];
            [alert show];
            return;
        }
        else {
            jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"未搜索到目的地，换一换关键字试试"];
            [alert show];
            return;
        }
    }
    
    /* 如果只有一个结果，设置其为中心点. */
    if (response.pois.count == 1) {
        [m_mapView setCenterCoordinate:[m_annotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else {
        [m_mapView showAnnotations:m_annotations animated:NO];
    }
}

// post Session
- (void) sendPostSessionForLocation {
    [m_processview setTitile:@"正在连接服务器\n请稍后..."];
    [m_processview toshow];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/getVHLPosition", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&vin=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo defaultCarVin], [GNLUserInfo isDemo] ? @"true" : @"false"];
    
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    NSLog(@"destination **** %@", request);
    if ([request isEqualToString:@"jk-error .."]) {
        jkAlertController * alerttopost = [[jkAlertController alloc] initWithOKButton:NETWORK_ERROR ];
        [alerttopost show];
        [m_processview tohide];
        return;
    }
    if ([request isEqualToString:@"jk-timeout .."]) {
        jkAlertController * alerttopost = [[jkAlertController alloc] initWithOKButton:NETWORK_TIMEOUT ];
        [alerttopost show];
//        [m_tableview reloadData];
        [m_processview tohide];
        return;
    }
    
    NSDictionary * dicdata = [postSession getDictionaryFromRequest];
    NSString * tmplati = [dicdata objectForKey:@"vhlLatitude"];
    NSString * tmplont = [dicdata objectForKey:@"vhlLontitude"];
    
    if ([[[dicdata objectForKey:@"status"] objectForKey:@"code"] isEqualToString: @"402"]) {
        MainNavigationController * ctl = (MainNavigationController *) self.navigationController;
        [ctl turntoLoginForOut];
        [m_processview tohide];
        return;
    }
    
    if (![[[dicdata objectForKey:@"status"] objectForKey:@"code"] isEqualToString: @"200"]) {
        jkAlertController * view = [[jkAlertController alloc]initWithOKButton:DATA_ERROR];
        [view show];
        [m_processview tohide];
        return;
    }

    if (tmplati != nil && tmplont != nil
        && ![tmplati isEqualToString:@""]
        && ![tmplont isEqualToString:@""]) {
        [m_processview tohide];
        
        // 北京市朝阳区望京首开大厦，对应的坐标为：116.48034,39.995946
        // 39.118661, 117.19779 - Tianjin yingkoudao
        m_vehiclePoint.latitude = [tmplati doubleValue];
        m_vehiclePoint.longitude = [tmplont doubleValue];
        
        MAPointAnnotation * pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = m_vehiclePoint;
        pointAnnotation.title = @"爱车位置";
        [m_mapView addAnnotation:pointAnnotation];
        
        // 设置地图中心
        m_mapView.centerCoordinate = m_vehiclePoint;
        
        // 记录当前车辆位置，下次直接显示
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSString stringWithFormat:@"%lf", m_vehiclePoint.latitude] forKey:USERINFO_CAR_LATITUDE];
        [userDefaults setObject:[NSString stringWithFormat:@"%lf", m_vehiclePoint.longitude] forKey:USERINFO_CAR_LONGITUDE];
        [userDefaults synchronize];
    }
}

// Search config

- (void) clearSearchRequest {
    [m_mapView removeAnnotations:m_annotations];

    [m_annotations removeAllObjects];
    [m_mapPOI removeAllObjects];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        MAPointAnnotation * point = (MAPointAnnotation *)annotation;
        if (m_vehiclePoint.latitude == point.coordinate.latitude &&
            m_vehiclePoint.longitude == point.coordinate.longitude) {
            annotationView.image = [UIImage imageNamed:@"map_carpoint"];
        }
        else {
            annotationView.canShowCallout = YES;
            annotationView.highlighted = YES;
            annotationView.image = [UIImage imageNamed:@"map_normalpoint"];
        }
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0.f, -18.f);
        return annotationView;
    }
    
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"map_location"];
        annotationView.centerOffset = CGPointMake(0.f, -18.0f);
        return annotationView;
    }
    
    return nil;
}

// 地图长按选点
- (void) mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"longPressed - %f %f", coordinate.latitude, coordinate.longitude);
    
    [destinationView setHidden:YES];
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
    
    [destinationView setHidden:NO];
    [destinationView setTitle:@"自选点" title2:@"加载中 .."];
    [destinationView setGeoPoint:[NSString stringWithFormat:@"%f", m_longpressedPoint.latitude] Longitude:[NSString stringWithFormat:@"%f", m_longpressedPoint.longitude]];

}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    id<MAAnnotation> annotation = view.annotation;
    MAPointAnnotation * selectedAnnotation = (MAPointAnnotation *)annotation;
    NSLog(@"map selected annotation %f %f", selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude);
    [destinationView setHidden:YES];
    
    if (selectedAnnotation.coordinate.latitude == m_userPoint.latitude && selectedAnnotation.coordinate.longitude == m_userPoint.longitude) {
        m_selectedPoint.latitude = 0;
        m_selectedPoint.longitude = 0;
        return;
    }
    else if (selectedAnnotation.coordinate.latitude == m_vehiclePoint.latitude && selectedAnnotation.coordinate.longitude == m_vehiclePoint.longitude) {
        m_selectedPoint.latitude = 0;
        m_selectedPoint.longitude = 0;
        return;
    }

    // 判断选中标记点是否是 搜索的兴趣点和自选点
    if ([m_annotations containsObject:selectedAnnotation]) {
        view.image = [UIImage imageNamed:@"map_selectpoint"];
        
        AMapPOI * selecetedPOI = nil;
        for (AMapPOI * p in m_mapPOI) {
            if (p.location.latitude == selectedAnnotation.coordinate.latitude && p.location.longitude == selectedAnnotation.coordinate.longitude) {
                selecetedPOI = p;
                break;
            }
        }
        
        [destinationView setHidden:NO];
        [destinationView setTitle:selecetedPOI.name title2:selecetedPOI.address];
        [destinationView setGeoPoint:[NSString stringWithFormat:@"%f", selecetedPOI.location.latitude] Longitude:[NSString stringWithFormat:@"%f", selecetedPOI.location.longitude]];
    }
    else if (selectedAnnotation.coordinate.latitude == m_longpressedPoint.latitude && selectedAnnotation.coordinate.longitude == m_longpressedPoint.longitude) {
        view.image = [UIImage imageNamed:@"map_selectpoint"];

        [destinationView setHidden:NO];
        [destinationView setTitle:@"自选点" title2:m_longpressedAddress];
        [destinationView setGeoPoint:[NSString stringWithFormat:@"%f", m_longpressedPoint.latitude] Longitude:[NSString stringWithFormat:@"%f", m_longpressedPoint.longitude]];
    }
    
    // 恢复前一个选中的标记点
    [m_mapView annotations];
    if (selectedAnnotation.coordinate.latitude != m_selectedPoint.latitude && selectedAnnotation.coordinate.longitude != m_selectedPoint.longitude) {
        for (MAPointAnnotation * notation in m_annotations) {
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
    m_selectedPoint = selectedAnnotation.coordinate;
}

- (void) mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    [destinationView setHidden:YES];
}

- (void) mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"current location - %f %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        m_userPoint = userLocation.coordinate;
        
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
    NSLog(@"%@", response.regeocode.addressComponent.city);
    if (response.regeocode.addressComponent.city != nil) {
        m_city = response.regeocode.addressComponent.citycode;
    }
    
    if (request.location.latitude == m_longpressedPoint.latitude && request.location.longitude == m_longpressedPoint.longitude) {
        m_longpressedAddress = [response regeocode].formattedAddress;
        
        [destinationView setHidden:NO];
        [destinationView setTitle:@"自选点" title2:m_longpressedAddress];
        [destinationView setGeoPoint:[NSString stringWithFormat:@"%f", m_longpressedPoint.latitude] Longitude:[NSString stringWithFormat:@"%f", m_longpressedPoint.longitude]];
    }
}

- (void) addAnnotationForMapView:(float)latitude Longitude:(float)longtitude Title:(NSString *)title {
}


// Actions
- (void) doSearch {
    // hide keyboard
    [self textfield_TouchDown:nil];
    
    NSString * str = tf_searchKeywords.text;
    if (str == nil || [str isEqualToString:@""]) return;
    NSLog(@"do search .. %@",str);
    
    // 过滤特殊字符
    NSString * key = tf_searchKeywords.text;
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"@[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+?/$!.<>《》，。,;:'\"“”‘’：；？＊％～"];
    // ~`!@#$%^&*()-_+=\|[]{};:'"<>,./?
    key = [[key componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    if ([key isEqualToString:@""] ) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"未搜索到目的地，换一换关键字试试"];
        [alert show];
        [tf_searchKeywords setText:@""];
        return;
    }
    else {
        key = tf_searchKeywords.text;
    }
    
    [self clearSearchRequest];
    m_secondsearch = 0;
    m_secondcity = nil;
    [self doMapSearch:key];
}

- (IBAction) textfield_didEdit:(id)sender {
    // 隐藏键盘.
    [sender resignFirstResponder];
    [m_tableview setHidden: YES];
}

- (IBAction) textfield_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [m_tableview setHidden: YES];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_searchTips count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text = [m_searchTips objectAtIndex: indexPath.row];
    [cell.textLabel setTextColor:[UIColor darkTextColor]];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    tf_searchKeywords.text = [m_searchTips objectAtIndex:indexPath.row];
    [self doSearch];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
#pragma mark - Navigation
 /*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
