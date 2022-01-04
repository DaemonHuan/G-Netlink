//
//  TravelLogDetailViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "TravelLogDetailViewController.h"
#import "public.h"
#import "TransitPointsObject.h"
#import "TransitPointAnnotationView.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#define COLOR_TITLE_AWAY @"F39920"
#define COLOR_TITLE_TIME @"36CCDA"
#define COLOR_TITLE_OIL @"F2666D"

#define minfloat 0.000000000000001

@interface TravelLogDetailViewController () <MAMapViewDelegate, AMapSearchDelegate, PostSessionDataDelegate>

@end

@implementation TravelLogDetailViewController {
    CLLocationCoordinate2D m_endPoint;     // 终点
    CLLocationCoordinate2D m_startPoint;   // 起点
    CLLocationCoordinate2D m_selectTransitPoint; //
    BOOL m_locationflag;
    
    
    MAMapView * m_mapView;
    AMapSearchAPI * m_search;
    NSMutableArray * m_transitPointArray;
    
    IBOutlet UILabel * la_startTime;
    IBOutlet UILabel * la_endTime;
    IBOutlet UILabel * la_destination;
    IBOutlet UILabel * la_startPoint;
    IBOutlet UILabel * la_away;
    IBOutlet UILabel * la_time;
    IBOutlet UILabel * la_oil;
    IBOutlet UILabel * la_awayTitle;
    IBOutlet UILabel * la_timeTitle;
    IBOutlet UILabel * la_oilTitle;
    UILabel * la_transitError;
    
    NSInteger m_coutForSearch;
    
    GetPostSessionData * postSession;
}

- (id) init {
    if (self = [super init]) {
        self.arrayForAllDrivingLog = [[NSMutableArray alloc]init];
        self.oneDetailData = [[DataForDrivingLog alloc]init];

        m_search = [[AMapSearchAPI alloc] init];
        m_search.delegate = self;
        
        
        postSession = [[GetPostSessionData alloc]init];
        postSession.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"本次详情"];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 模拟数据 FLAG
    CGFloat height = 0.0f;
    if ([self.UserInfo isRunDemo]) {
        [self.view addSubview: [ExtendStaticView MarkDemoView]];
        height = 30.0f;
    }
    
    CGFloat aw = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat ah = CGRectGetHeight([UIScreen mainScreen].bounds);
    m_mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0.0f, 168.0f, aw, ah - 168.0f - 180.0f + 2.0f)];
    m_mapView.delegate = self;
    [m_mapView setRotateEnabled:NO];
    [m_mapView setRotateCameraEnabled:NO];
    [self.view insertSubview:m_mapView atIndex:0];
    
    la_transitError = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, ah - 210.0f, aw, 30.f)];
    [la_transitError setFont:[UIFont fontWithName:FONT_XI size:12.0f]];
    [la_transitError setText:@" 提示:由于本次行车路段网络条件较差，无法显示轨迹信息。"];
    [la_transitError setBackgroundColor:[UIColor colorWithHexString:@"FFEDF1"]];
    [la_transitError setAdjustsFontSizeToFitWidth:YES];
    [self.view addSubview: la_transitError];
    la_transitError.hidden = YES;
    
    //
    m_transitPointArray = [[NSMutableArray alloc]init];
    
    NSMutableAttributedString * asaway = [[NSMutableAttributedString alloc]initWithString:@"距离(公里)"];
    [asaway addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_MM size:20.0f] range:NSMakeRange(0, 2)];
    [asaway addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_MM size:12.0f] range:NSMakeRange(2, asaway.length - 2)];
    [la_awayTitle setAttributedText:asaway];
    
    NSMutableAttributedString * astime = [[NSMutableAttributedString alloc]initWithString:@"耗时(分钟)"];
    [astime addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_MM size:20.0f] range:NSMakeRange(0, 2)];
    [astime addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_MM size:12.0f] range:NSMakeRange(2, astime.length - 2)];
    [la_timeTitle setAttributedText:astime];
    
    NSMutableAttributedString * asoil = [[NSMutableAttributedString alloc]initWithString:@"油耗(升/百公里)"];
    [asoil addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_MM size:20.0f] range:NSMakeRange(0, 2)];
    [asoil addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_MM size:12.0f] range:NSMakeRange(2, asoil.length - 2)];
    [la_oilTitle setAttributedText:asoil];
    
    [la_startTime setFont:[UIFont fontWithName:FONT_MM size: FONT_S_TITLE2]];
    [la_startTime setTextAlignment: NSTextAlignmentRight];
    [la_startPoint setFont:[UIFont fontWithName:FONT_MM size: FONT_S_TITLE2]];
    [la_endTime setFont:[UIFont fontWithName:FONT_MM size: FONT_S_TITLE2]];
    [la_endTime setTextAlignment: NSTextAlignmentRight];
    [la_destination setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE2]];
    
    [la_away setTextColor:[UIColor colorWithHexString: COLOR_TITLE_AWAY]];
    [la_time setTextColor: [UIColor colorWithHexString: COLOR_TITLE_TIME]];
    [la_oil setTextColor:[UIColor colorWithHexString:COLOR_TITLE_OIL]];
}

- (void) viewDidAppear:(BOOL)animated {
    m_mapView.showsCompass = NO;
    m_mapView.showsScale = NO;
    m_mapView.userTrackingMode = MAUserTrackingModeFollow;
    // 显示定位信息 需要 info.plist NSLocationWhenInUseUsageDescription[String]
    m_mapView.showsUserLocation = NO;
//    [m_mapView setZoomLevel:16.1 animated:YES];
}

- (void) setValueForDetail:(DataForDrivingLog *) data {
    if (data.startTime != nil && ![data.startTime isEqualToString:@""]) {
        [la_startTime setText:[data.startTime substringWithRange:NSMakeRange(11, 5)]];
    }
    else {
        [la_startTime setText:@"00:00"];
    }
    if (data.endTime != nil && ![data.endTime isEqualToString:@""]) {
        [la_endTime setText:[data.endTime substringWithRange:NSMakeRange(11, 5)]];
    }
    else {
        [la_endTime setText:@"00:00"];
    }

    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * start = [formatter dateFromString:data.startTime];
    NSDate * end = [formatter dateFromString:data.endTime];
    NSInteger time = [end timeIntervalSinceDate:start];
    if (start == nil || end == nil) time = 0;
    NSLog(@"\n -- ** --\n start:%@ \n end  :%@ ## %zd", data.startTime, data.endTime, time);
    
    if (data.detailAway == nil) [la_away setText:@"0"];
    else [la_away setText:data.detailAway];
    if (data.detailOil == nil) [la_oil setText:@"0"];
    else [la_oil setText:data.detailOil];
    if (data.detailTime == nil) [la_time setText:@"0"];
    else [la_time setText:[NSString stringWithFormat:@"%zd", time / 60]];
    
    [la_startPoint setText:@""];
    [la_destination setText:@""];
    
    if ([self.UserInfo isMapFlag]) {
        [m_transitPointArray removeAllObjects];
        [self sendPostSessionForDetail:data.startTime endDate:data.endTime];
    }
}

- (void) setValueForPoint:(DataForDrivingLog *)data {
    //
    [m_mapView removeAnnotations:m_mapView.annotations];
    [m_mapView setZoomLevel:16.1 animated:YES];
    m_startPoint = CLLocationCoordinate2DMake(0.0f, 0.0f);
    m_endPoint = CLLocationCoordinate2DMake(0.0f, 0.0f);
    m_selectTransitPoint = CLLocationCoordinate2DMake(0.f, 0.f);
    
    
    CGFloat latitude = [data.startPointLatitude floatValue];
    CGFloat longitude = [data.startPointLongitude floatValue];
    
    if (latitude > 0.0f && longitude > 0.0f &&(latitude - 90.0f < 0.0f) && (longitude - 180.0f < 0.0f)) {
        m_startPoint = CLLocationCoordinate2DMake([data.startPointLatitude floatValue], [data.startPointLongitude floatValue]);
        MAPointAnnotation * startpointAnnotation = [[MAPointAnnotation alloc] init];
        startpointAnnotation.coordinate = m_startPoint;
        startpointAnnotation.title = data.startPointName;
        [m_mapView addAnnotation:startpointAnnotation];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"位置点坐标有误。"];
            [alertview show];
            alertview.okBlock = ^(){
                [la_startPoint setText:@"获取数值非法"];
            };
        });
    }

    latitude = [data.endPointLatitude floatValue];
    longitude = [data.endPointLongitude floatValue];
    
    if (latitude > 0.0f && longitude > 0.0f &&(latitude - 90.0f < 0.0f) && (longitude - 180.0f < 0.0f)) {
        m_endPoint = CLLocationCoordinate2DMake([data.endPointLatitude floatValue], [data.endPointLongitude floatValue]);
        MAPointAnnotation * endpointAnnotation = [[MAPointAnnotation alloc] init];
        endpointAnnotation.coordinate = m_endPoint;
        endpointAnnotation.title = data.endPointName;
        [m_mapView addAnnotation:endpointAnnotation];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"位置点坐标有误。"];
            alertview.okBlock = ^(){
                [la_destination setText:@"获取数值非法"];
            };
            [alertview show];
        });
    }

    // 聚焦起始点
    [m_mapView showAnnotations:m_mapView.annotations animated:YES];
    
    if (data.startPointName == nil || data.endPointName == nil) {
        [self fixOneDrivingLogForPointName:data];
    }
    else {
        [la_startPoint setText:data.startPointName];
        [la_destination setText:data.endPointName];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *) convertStringWithLatitude:(CGFloat)lat Longitude:(CGFloat)lon {
    NSString * res = nil;
    // °′″
    // WE longitude
    NSString * str = nil;
    NSInteger dd = floor(lat);        // 度
    CGFloat num = lat - dd * 1.0f;
    NSInteger mm = floor(num * 60.0f);        // 分
    num = num * 60.0f - mm * 1.0f;
    CGFloat ss = num * 60.0f;           // 秒
    
    str = [NSString stringWithFormat:@"东经E%ld°%ld′%0.2f″",dd, mm, ss];
    res = str;
    
    // NS latitude
    dd = floor(lon);        // 度
    num = lon - dd * 1.0f;
    mm = floor(num * 60.0f);        // 分
    num = num * 60.0f - mm * 1.0f;
    ss = num * 60.0f;           // 秒
    
    str = [NSString stringWithFormat:@"北纬N%ld°%ld′%0.2f″",dd, mm, ss];
    res = [NSString stringWithFormat:@"%@\n%@",res, str];
    
    return res;
}

- (void) sendPostSessionForDetail:(NSString *)fromDate endDate:(NSString *)endDate {
    NSString * url = [NSString stringWithFormat:@"%@/api/getDetailByVin", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"%@&vin=%@&beginTime=%@&endTime=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin], fromDate, endDate];
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    if ([request isEqualToString:@"NSURLErrorNetworkConnectionLost"]) {
        return;
    }
    
    if ([request isEqualToString:@"jk-Error"]) {
        return;
    }

    NSDictionary * mdic = [postSession getDictionaryFromRequest];
    NSString * code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
    NSArray * datalist = [mdic objectForKey:@"vhlDataList"];
    
    // 构造地图折线对象
    unsigned long count = [datalist count];
    CLLocationCoordinate2D coordinates[count];
    [m_transitPointArray removeAllObjects];
    
    int i = 0;
    for (NSDictionary * one in datalist) {
        coordinates[i] = CLLocationCoordinate2DMake([[one objectForKey:@"lat"] floatValue], [[one objectForKey:@"lon"] floatValue]);
        i ++;
        
        TransitPointsObject * transitP = [[TransitPointsObject alloc]init];
//        transitP.subtitle = ;
//        transitP.selected = NO;
        transitP.latitude = [[one objectForKey:@"lat"] floatValue];
        transitP.longitude = [[one objectForKey:@"lon"] floatValue];
        [m_transitPointArray addObject: transitP];
        
        NSString * str = [self convertStringWithLatitude:transitP.latitude Longitude:transitP.longitude];
        
        MAPointAnnotation * Annotation = [[MAPointAnnotation alloc] init];
        Annotation.coordinate = CLLocationCoordinate2DMake(transitP.latitude, transitP.longitude);
        Annotation.title = @"途径点";
        Annotation.subtitle = str;
        [m_mapView addAnnotation:Annotation];
    }
    
    MAPolyline * commonPolyline = [MAMultiPolyline polylineWithCoordinates:coordinates count:[datalist count] drawStyleIndexes:nil];
    [m_mapView addOverlay:commonPolyline];
}
// 绘制地图途径线
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer * polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = [UIColor blueColor];
        polylineRenderer.lineJoinType = kMALineCapRound;

        return polylineRenderer;
    }
    return nil;
}

// 绘制地图点，起始点
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        MAPointAnnotation * point = (MAPointAnnotation *)annotation;
        
        MAAnnotationView * annotationView = nil;

        if ((m_endPoint.latitude - point.coordinate.latitude < minfloat)
            && (m_endPoint.latitude - point.coordinate.latitude > minfloat * -1)
            && (m_endPoint.longitude - point.coordinate.longitude < minfloat)
            && (m_endPoint.longitude - point.coordinate.longitude > minfloat * -1)) {
            NSLog(@"** End Point ..");
            
            static NSString * pointReuseIndentifier = @"pointReuseIndentifier";
            annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
            if (annotationView == nil) {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            }
            annotationView.image = [UIImage imageNamed:@"travellog_endp"];
            annotationView.centerOffset = CGPointMake(0.0f, -18.0f);
            annotationView.canShowCallout = NO;

        }
        else if ((m_startPoint.latitude - point.coordinate.latitude < minfloat)
                 && (m_startPoint.latitude - point.coordinate.latitude > minfloat * -1)
                 && (m_startPoint.longitude - point.coordinate.longitude < minfloat)
                 && (m_startPoint.longitude - point.coordinate.longitude > minfloat * -1)) {
            NSLog(@"** Start Point ..");
            
            static NSString * pointReuseIndentifier = @"pointReuseIndentifier";
            annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
            if (annotationView == nil) {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            }
            annotationView.image = [UIImage imageNamed:@"travellog_startp"];
            annotationView.centerOffset = CGPointMake(0.0f, -18.0f);
            annotationView.canShowCallout = NO;

        }
        else {  // 途径点
            static NSString * pointReuseIndentifier = @"TransitPointAnnotationIndetifier";
            annotationView = (TransitPointAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
            if (annotationView == nil) {
                annotationView = [[TransitPointAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            }
            
            annotationView.image = [UIImage imageNamed:@"travellog_point"];
            // 设置为NO，用以调用自定义的calloutView
            annotationView.canShowCallout = NO;
            
//            if (point.coordinate.latitude == m_selectTransitPoint.latitude
//                && point.coordinate.longitude == m_selectTransitPoint.longitude) {
////                annotationView.selected = YES;
//                NSLog(@"** selected .. %f %f",point.coordinate.latitude, point.coordinate.longitude);
//            }
//            else annotationView.selected = NO;

        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    id<MAAnnotation> annotation = view.annotation;
    MAPointAnnotation * selectedAnnotation = (MAPointAnnotation *)annotation;
    NSLog(@"map selected annotation %f %f", selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude);
    
    // 选中途径点
    m_selectTransitPoint = CLLocationCoordinate2DMake(selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude);
    
//    BOOL showFlag = NO;
    for (TransitPointsObject * p in m_transitPointArray) {
        if (p.latitude == m_selectTransitPoint.latitude
            && p.longitude == m_selectTransitPoint.longitude) {
            
            if (p.subtitle == nil) {
                // 搜索选中点
                AMapReGeocodeSearchRequest * selected = [[AMapReGeocodeSearchRequest alloc] init];
                selected.location = [AMapGeoPoint locationWithLatitude: p.latitude longitude: p.longitude];
                selected.requireExtension = YES;
                [m_search AMapReGoecodeSearch: selected];
            }
            else {
                [m_mapView updateConstraints];
                break;
            }
        }
    }
}

/*
- (void) fixAllDrivingLogForPointName {
    m_coutForSearch = [self.arrayForAllDrivingLog count] * 2;
    if (m_coutForSearch == 0) {
//        [self.delegate fixPointNameForArrayInDetail];
    }
    
    for (DataForDrivingLog * one in self.arrayForAllDrivingLog) {
        // 起点
        AMapReGeocodeSearchRequest * start = [[AMapReGeocodeSearchRequest alloc] init];
        start.location = [AMapGeoPoint locationWithLatitude:[one.startPointLatitude floatValue] longitude: [one.startPointLongitude floatValue]];
        start.radius = 10000;
        start.requireExtension = YES;
        [m_search AMapReGoecodeSearch: start];
        
        // 终点
        AMapReGeocodeSearchRequest * end = [[AMapReGeocodeSearchRequest alloc] init];
        end.location = [AMapGeoPoint locationWithLatitude:[one.endPointLatitude floatValue] longitude: [one.endPointLongitude floatValue]];
        end.radius = 10000;
        end.requireExtension = YES;
        [m_search AMapReGoecodeSearch: end];
    }
}       */

- (void) fixOneDrivingLogForPointName: (DataForDrivingLog *)data {
    // 起点
    AMapReGeocodeSearchRequest * start = [[AMapReGeocodeSearchRequest alloc] init];
    start.location = [AMapGeoPoint locationWithLatitude:[data.startPointLatitude floatValue] longitude: [data.startPointLongitude floatValue]];
    start.radius = 10000;
    start.requireExtension = YES;
    [m_search AMapReGoecodeSearch: start];
    
    // 终点
    AMapReGeocodeSearchRequest * end = [[AMapReGeocodeSearchRequest alloc] init];
    end.location = [AMapGeoPoint locationWithLatitude:[data.endPointLatitude floatValue] longitude: [data.endPointLongitude floatValue]];
    end.radius = 10000;
    end.requireExtension = YES;
    [m_search AMapReGoecodeSearch: end];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    NSString * result = nil;
    if(response.regeocode != nil) {
//        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        if (![response.regeocode.formattedAddress isEqualToString:@""]) {
            result = response.regeocode.formattedAddress;
        }

        if ([response.regeocode.pois count] > 0) {
            AMapPOI * poi = [response.regeocode.pois objectAtIndex:0];
            result = poi.name;
        }
        
        if (![response.regeocode.addressComponent.building isEqualToString:@""]) {
            result = response.regeocode.addressComponent.building;
        }
    }
    
    if (result == nil) return;
    
    // 根据坐标点信息 匹配对应的位置点名称 可以为多个重复点坐标赋值
    NSLog(@"** %f %f %@", request.location.latitude, request.location.longitude, result);
    for (DataForDrivingLog * one in self.arrayForAllDrivingLog) {
        if ([one.startPointLatitude floatValue] == request.location.latitude &&
            [one.startPointLongitude floatValue] == request.location.longitude) {
            one.startPointName = [NSString stringWithString:result];
            [la_startPoint setText: [NSString stringWithString:result]];
            return;
        }
        
        if ([one.endPointLatitude floatValue] == request.location.latitude &&
            [one.endPointLongitude floatValue] == request.location.longitude) {
            one.endPointName = [NSString stringWithString:result];
            [la_destination setText: [NSString stringWithString:result]];
            return;
        }
    }
    
//    for (AMapPOI * p in m_transitPointArray) {
//        if (p.location.latitude == request.location.latitude &&
//            p.location.longitude == request.location.longitude) {
//            
////            MAPointAnnotation * Annotation = [[MAPointAnnotation alloc] init];
////            Annotation.coordinate = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
////            Annotation.title = result;
////            [m_mapView addAnnotation:Annotation];
////            [m_transitPointArray addObject:Annotation];     // Transit Points in Map
//        }
//    }
    //
    
    if (request.location.latitude == m_selectTransitPoint.latitude
        && request.location.longitude == m_selectTransitPoint.longitude) {
        for (TransitPointsObject * p in m_transitPointArray) {
            if (p.latitude == m_selectTransitPoint.latitude
                && p.longitude == m_selectTransitPoint.longitude) {
                
                TransitPointsObject * one = [[TransitPointsObject alloc]init];
                one.subtitle = result;
                one.latitude = p.latitude;
                one.longitude = p.longitude;
                [m_transitPointArray addObject:one];
                [m_transitPointArray removeObject:p];
                
                [self refreseMapAnnotations];
                break;
            }
        }
    }
}

- (void) refreseMapAnnotations {
    NSLog(@"* -- *\n* -- *\n* -- *\n* -- *\n* -- *\n* -- *\n* -- *\n* -- *");

    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    
//    [m_mapView removeAnnotations:m_mapView.annotations];
    [m_mapView updateConstraints];
    
    MAPointAnnotation * startpointAnnotation = [[MAPointAnnotation alloc] init];
    startpointAnnotation.coordinate = m_startPoint;
    [m_mapView addAnnotation:startpointAnnotation];
    
    MAPointAnnotation * endpointAnnotation = [[MAPointAnnotation alloc] init];
    endpointAnnotation.coordinate = m_endPoint;
    [m_mapView addAnnotation:endpointAnnotation];
    
    for (TransitPointsObject * p in m_transitPointArray) {
        MAPointAnnotation * notation = [[MAPointAnnotation alloc] init];
        notation.coordinate = CLLocationCoordinate2DMake(p.latitude, p.longitude);
        
        if (p.subtitle == nil) notation.title = @"途径点";
        else notation.title = p.subtitle;
        notation.subtitle = [self convertStringWithLatitude:p.latitude Longitude:p.longitude];
        [m_mapView addAnnotation: notation];
    }
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
