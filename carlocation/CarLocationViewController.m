//
//  CarLocationViewController.m
//  G-Netlink-beta0.2
//
//  Created by jk on 10/30/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "CarLocationViewController.h"
#import "MainNavigationController.h"

#import <MAMapKit/MAMapKit.h>
#import "GetPostSessionData.h"

#import "public.h"
#import "GNLUserInfo.h"

#import "jkAlertController.h"
#import "SCGIFImageView.h"
#import "jkProcessView.h"

@interface CarLocationViewController () <MAMapViewDelegate, PostSessionDataDelegate, UIGestureRecognizerDelegate>{
    MAMapView * jkmapView;
    CLLocationCoordinate2D m_LocationPoint;  // 定位location
    CLLocationCoordinate2D m_vehiclePoint;  // vehicle location
    BOOL m_locationflag;
    GetPostSessionData * postSession;
    jkProcessView * m_processview;
    
    IBOutlet UIView * vi_alert;
    IBOutlet UILabel * la_alert;
    
    UIButton * bt_setMapCentor;
    NSInteger m_centor; // 0 = vehicle   1 = iphone
}

@end

@implementation CarLocationViewController {
    IBOutlet UIView * m_mapview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车辆位置";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_menuicon"] style: UIBarButtonItemStylePlain target:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 向右滑动显示菜单
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    recognizer.delegate = self;
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"location_trigger"] style:UIBarButtonItemStylePlain target:self action:@selector(sendPostSessionForLocation)];
    [rightItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    //
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"runline.gif" ofType:nil];
    SCGIFImageView * gifImageView = [[SCGIFImageView alloc] initWithGIFFile:filePath];
    gifImageView.frame = CGRectMake(90.0f, 250.0f, CGRectGetWidth([UIScreen mainScreen].bounds) - 180.0f, 30.0f);
    vi_alert.layer.cornerRadius = 5.0f;
    [vi_alert addSubview: gifImageView];
    [la_alert setText:@""];
    [la_alert setTextColor: [UIColor whiteColor]];
    [la_alert setFont: [UIFont fontWithName:FONT_MM size:18.0f]];
    
    [vi_alert setHidden: YES];

    //
    CGFloat extend = 0.0f;
    if ([GNLUserInfo isDemo]) {
        [self.view addSubview: [ServicesPro loadMarkDemoView]];
        extend = 30.0f;
    }
    
//    [MAMapServices sharedServices].apiKey = MAP_BUNDLEIDENTIFIER;
    jkmapView = [[MAMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64.0f - extend)];
    jkmapView.delegate = self;
    [jkmapView setRotateEnabled:NO];
    [jkmapView setRotateCameraEnabled:NO];
    [m_mapview addSubview: jkmapView];
    
    m_processview = [[jkProcessView alloc]initWithMessage:@""];
    [m_processview tohide];
    [self.view addSubview:m_processview];
    
    postSession = [[GetPostSessionData alloc] init];
    postSession.delegate = self;
   
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    m_centor = -1;
    [self sendPostSessionForLocation];
    
    jkmapView.showsCompass = NO;
    jkmapView.showsScale = NO;
    //    jkmapView.centerCoordinate = m_centerPoint; // map center
    jkmapView.userTrackingMode = MAUserTrackingModeNone;
    jkmapView.showsUserLocation = YES;
    [jkmapView setZoomLevel:16.1 animated:YES];
    [self initControls];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString * ttlatitude = [userDefault objectForKey:USERINFO_CAR_LATITUDE];
    NSString * ttlongitude = [userDefault objectForKey:USERINFO_CAR_LONGITUDE];
    
    [jkmapView setCenterCoordinate:CLLocationCoordinate2DMake([ttlatitude floatValue], [ttlongitude floatValue])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initControls
{
    //
    CGFloat extend = 0.0f;
    if ([GNLUserInfo isDemo]) extend = 30.0f;
    
    UIButton *warningButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    warningButton.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 100, CGRectGetHeight(m_mapview.bounds) - 100.0f - extend, 80.0f, 80.0f);
    warningButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [warningButton setBackgroundImage:[UIImage imageNamed:@"location_button"] forState:UIControlStateNormal];
    [warningButton addTarget:self action:@selector(doWarning) forControlEvents:UIControlEventTouchUpInside];
    
    [jkmapView addSubview:warningButton];
    
    bt_setMapCentor = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bt_setMapCentor.frame = CGRectMake(20.0f, CGRectGetHeight(m_mapview.bounds) - 100.0f - extend, 80.0f, 80.0f);
    bt_setMapCentor.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [bt_setMapCentor setBackgroundImage:[UIImage imageNamed:@"location_carbt"] forState:UIControlStateNormal];
    [bt_setMapCentor addTarget:self action:@selector(exchangeMapCentor) forControlEvents:UIControlEventTouchUpInside];
    
    [jkmapView addSubview:bt_setMapCentor];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString * pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView * annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.canShowCallout = YES;
        [annotationView setSelected:YES];
        annotationView.highlighted = YES;
        annotationView.image = [UIImage imageNamed:@"map_carpoint"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18.0f);
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
        annotationView.centerOffset = CGPointMake(0, -18.0f);
        return annotationView;
    }
    
    return nil;
}

- (void) setMapViewVehicleLocation {
    NSArray * annotations = [jkmapView annotations];
    [jkmapView removeAnnotations:annotations];
    
    MAPointAnnotation * pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(m_vehiclePoint.latitude, m_vehiclePoint.longitude);
    pointAnnotation.title = @"my car ..";
//    pointAnnotation.subtitle = @"mmmmm ..";

    [jkmapView addAnnotation:pointAnnotation];
    [jkmapView setZoomLevel:16.1 animated:YES];
    jkmapView.centerCoordinate = m_vehiclePoint;
    
    m_centor = 0;
    
    // 记录当前车辆位置，下次直接显示
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%lf", m_vehiclePoint.latitude] forKey:USERINFO_CAR_LATITUDE];
    [userDefaults setObject:[NSString stringWithFormat:@"%lf", m_vehiclePoint.longitude] forKey:USERINFO_CAR_LONGITUDE];
    [userDefaults synchronize];
}

- (void) mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if(updatingLocation && m_locationflag)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        m_LocationPoint.longitude = userLocation.coordinate.longitude;
        m_LocationPoint.latitude = userLocation.coordinate.latitude;
        m_locationflag = NO;
    }
}

- (void) sendPostSessionForLocation {
    [m_processview setTitile:@"正在连接服务器\n请稍后..."];
    [m_processview toshow];
    
    // 获取当前定位
    m_locationflag = YES;
    
    // 获取车辆定位
    NSString * url = [NSString stringWithFormat:@"%@/api/getVHLPosition", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&vin=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo defaultCarVin], [GNLUserInfo isDemo] ? @"true" : @"false"];
    
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) exchangeMapCentor {
    if ( m_centor == -1) {
        return;
    }
    else if (m_centor == 1) {
        if (m_vehiclePoint.latitude != 0.0f && m_vehiclePoint.longitude != 0.0f) {
            [jkmapView setZoomLevel:16.1 animated:YES];
            [jkmapView setCenterCoordinate: m_vehiclePoint];
            
            [bt_setMapCentor setBackgroundImage:[UIImage imageNamed:@"location_phonebt"] forState:UIControlStateNormal];
            m_centor = 0;
        }
        else return;
    }
    else if (m_centor == 0) {
        if (m_LocationPoint.latitude != 0.0f && m_LocationPoint.longitude != 0.0f) {
            [jkmapView setZoomLevel:16.1 animated:YES];
            [jkmapView setCenterCoordinate: m_LocationPoint];
            
            [bt_setMapCentor setBackgroundImage:[UIImage imageNamed:@"location_carbt"] forState:UIControlStateNormal];
            m_centor = 1;
        }
        else return;
    }
}

- (void) doWarning {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [vi_alert setHidden: NO];
            [la_alert setText: @"指令下发中 .."];
        });
        NSInteger result = [self sendPostSessionForWarning];
        if (result != 200) {
            [self doshowAlertView:result];
            [vi_alert setHidden: YES];
            return;
        }
        
        // ACK 请求
        dispatch_async(dispatch_get_main_queue(), ^{
            [la_alert setText: @"指令执行中 .."];
        });
        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow:120.0f];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
        NSDictionary * dicstatus;
        while (sp > 0.0f) {
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            // 暂停 2s
            [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
            
            dicstatus = [self sendPostSessionForAckInfo];
            NSString * res = [dicstatus objectForKey:@"ackInfoStatus"];
            NSLog(@"** get command ackinfo - %f %@", sp, res);
            if ([res isEqualToString:@"0"] && [[[dicstatus objectForKey:@"status"]objectForKey:@"code"]isEqualToString:@"200"]) break;
        }
        
        if (sp < 0.0f) {
            NSLog( @"time out ..");
            dispatch_async(dispatch_get_main_queue(), ^{
                jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:NETWORK_TIMEOUT];
                [alert show];
                [vi_alert setHidden: YES];
            });
            return;
        }
        
        // 发送命令执行结果查询
        sDate = [NSDate dateWithTimeIntervalSinceNow:60.0f];
        sp = [sDate timeIntervalSinceDate:[NSDate date]];

        while (sp > 0.0f) {
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            // 暂停 2s
            [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
            
            dicstatus = [self sendPostSessionForResult];
            NSString * res = [dicstatus objectForKey:@"whistleResult"];
            NSLog(@"** get command result - %f %@", sp, res);
            
            if ([res isEqualToString:@"0"] && [[[dicstatus objectForKey:@"status"]objectForKey:@"code"]isEqualToString:@"200"]) break;
            if ([res isEqualToString:@"1"] && [[[dicstatus objectForKey:@"status"]objectForKey:@"code"]isEqualToString:@"200"]) break;
            if ([res isEqualToString:@"2"] && [[[dicstatus objectForKey:@"status"]objectForKey:@"code"]isEqualToString:@"200"]) break;
        }
        
        if (sp < 0.0f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:NETWORK_TIMEOUT];
                [alert show];
                [vi_alert setHidden: YES];
            });
            return;
        }
        
        if ([[dicstatus objectForKey:@"whistleResult"]isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [vi_alert setHidden:YES];
                jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"指令发送失败"];
                [alert show];
            });
        }
        if ([[dicstatus objectForKey:@"whistleResult"]isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [vi_alert setHidden:YES];
                jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"指令发送成功"];
                [alert show];
            });
        }
        if ([[dicstatus objectForKey:@"whistleResult"]isEqualToString:@"2"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [vi_alert setHidden:YES];
                jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"控制失败,\n您的车辆不符合控制条件!"];
                [alert show];
            });
        }
    });
}

- (NSInteger) sendPostSessionForWarning {
    // 同步 POST 请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/sendWhistleCommand", HTTP_GET_POST_ADDRESS]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
    //设置请求方式为POST
    [request setHTTPMethod:@"POST"];
    // 设置参数
    NSString * body = [NSString stringWithFormat:@"vin=%@&username=%@&ControlWhistleCommand=%@&isdemo=%@", [GNLUserInfo defaultCarVin], [GNLUserInfo userID], @"1",[GNLUserInfo isDemo] ? @"true" : @"false"];
    NSLog(@"****** %@", body);
    NSData * data = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: nil];
    if (dic == nil) return 0;
    NSLog(@"Command Request: %@", dic);
    
    NSString * code = [[dic objectForKey:@"status"]objectForKey:@"code"];
    if ([code isEqualToString:@""] || code == nil) {
        return 0;
    }
    else {
        return [code integerValue];
    }
}

- (NSDictionary *) sendPostSessionForAckInfo {
    // 同步 POST 请求 username
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/getAckInfo", HTTP_GET_POST_ADDRESS]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
    //设置请求方式为POST
    [request setHTTPMethod:@"POST"];
    // 设置参数
    
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&username=%@&vin=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo userID], [GNLUserInfo defaultCarVin],  [GNLUserInfo isDemo] ? @"true" : @"false"];
    NSData * data = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: nil];
    
    NSLog(@"Command s Request: %@", dic);
    return dic;
}

- (void) doshowAlertView:(NSInteger)value {
    NSLog(@"alert value - %ld", value);
    NSString * str;
    if (value == 204) {
        str = NETWORK_ERROR;
    }
    else if (value == 402) {
        str = @"当前账户登录时效已过期,\n请重新登录";
    }
    else if (value == 500) {
        str = @"Pin 码验证错误,\n请重新输入";
    }
    
    jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:str];
    [alert show];
}

- (NSDictionary *) sendPostSessionForResult {
    // 同步 POST 请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/getWhistleResult", HTTP_GET_POST_ADDRESS]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
    //设置请求方式为POST
    [request setHTTPMethod:@"POST"];
    // 设置参数
    NSString * body = [NSString stringWithFormat:@"vin=%@&username=%@&isdemo=%@",  [GNLUserInfo defaultCarVin], [GNLUserInfo userID], [GNLUserInfo isDemo] ? @"true" : @"false"];
    NSData * data = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: nil];
    if (dic == nil) return nil;
    ///////////////////////
    NSLog(@"%@ Command Request: %@", body, dic);
    
    return dic;
}

- (void) didPostSessionRequest:(NSString *)request {
    NSLog(@"**** %@", request);
    
    if (request == nil) {
        [m_processview tohide];
        return;
    }
    if ([request isEqualToString:@"jk-error .."]) {
        jkAlertController * alerttopost = [[jkAlertController alloc] initWithOKButton:NETWORK_ERROR ];
        [alerttopost show];
        [m_processview tohide];
        return;
    }
    if ([request isEqualToString:@"jk-timeout .."]) {
        jkAlertController * alerttopost = [[jkAlertController alloc] initWithOKButton:NETWORK_TIMEOUT ];
        [alerttopost show];
        [m_processview tohide];
        return;
    }
    
    NSDictionary * dicdata = [postSession getDictionaryFromRequest];
//    NSString * tmplati = [dicdata objectForKey:@"vhlLatitude"];
//    NSString * tmplont = [dicdata objectForKey:@"vhlLontitude"];
    
    if ([[[dicdata objectForKey:@"status"] objectForKey:@"code"] isEqualToString: @"402"]) {
        MainNavigationController * ctl = (MainNavigationController *) self.navigationController;
        [ctl turntoLoginForOut];
        [m_processview tohide];
        return;
    }
    
    NSArray * keys = [dicdata allKeys];
    [m_processview tohide];
    
    if ( [keys containsObject:@"vhlLatitude"] && [keys containsObject:@"vhlLontitude"] ) {
        m_vehiclePoint.latitude = [[dicdata objectForKey:@"vhlLatitude"] doubleValue];
        m_vehiclePoint.longitude = [[dicdata objectForKey:@"vhlLontitude"] doubleValue];
//         北京市朝阳区望京首开大厦，对应的坐标为：116.48034,39.995946
//         39.118661, 117.19779 - Tianjin yingkoudao
//        m_vehiclePoint.latitude = [@"39.118661" doubleValue];
//        m_vehiclePoint.longitude = [@"117.19779" doubleValue];
        [self setMapViewVehicleLocation];
    }
    else if ( [keys containsObject:@"status"] && [keys count] == 1 ) {
//        NSDictionary * dic = [dicdata objectForKey:@"status"];
//        if ([[dic objectForKey:@"description"] isEqualToString: @"Success"]) {
//            [self sendPostSessionForResult];
//        }
    }
    else if ([keys containsObject:@"status"] && [keys containsObject:@"whistleResult"]) {
        [vi_alert setHidden: YES];
        if ([[dicdata objectForKey:@"whistleResult"] isEqualToString:@"0"]) {
            // 命令OK
            jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"闪灯鸣笛指令下发成功!"];
            [view show];
        }
        else {
            jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"闪灯鸣笛指令下发未成功!"];
            [view show];
        }
    }
}

@end
