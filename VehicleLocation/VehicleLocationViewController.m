//
//  VehicleLocationViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/25/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "VehicleLocationViewController.h"
#import "public.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface VehicleLocationViewController () <MAMapViewDelegate, PostSessionDataDelegate, AMapSearchDelegate>

@end

@implementation VehicleLocationViewController {
    IBOutlet UIButton * bt_warning;
    IBOutlet UIImageView * iv_icon;
    IBOutlet UILabel * la_addresstitle;
    IBOutlet UILabel * la_addressvalue;
    
    UILabel * la_subTime;

    CLLocationCoordinate2D m_locationPoint;  // 定位location
    CLLocationCoordinate2D m_vehiclePoint;  // vehicle location
    BOOL m_locationflag;
    GetPostSessionData * postSession;
    
    MAMapView * m_mapView;
    AMapSearchAPI * m_search;
    ProcessBoxCommandView * m_loadingview;
    
    
    NSMutableArray * m_annotations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"location_trigger"] style:UIBarButtonItemStylePlain target:self action:@selector(doFreshLocation)];
    [rightItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationItem setTitle:@"车辆位置"];
    

    if ([self.UserInfo isKCUser]) {
        UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 50.0f)];
        UILabel * la_title = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 35.0f)];
        [la_title setText:@"车辆位置"];
        [la_title setTextColor:[UIColor whiteColor]];
        [la_title setTextAlignment:NSTextAlignmentCenter];
        [titleView addSubview: la_title];
        la_subTime = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 32.0f, 200.0f, 15.0f)];
        [la_subTime setTextColor:[UIColor whiteColor]];
        [la_subTime setFont:[UIFont fontWithName:FONT_XI size:12.0f]];
        [la_subTime setTextAlignment:NSTextAlignmentCenter];
        [titleView addSubview: la_subTime];
        
        self.navigationItem.titleView = titleView;
    }

    CGFloat aw = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat ah = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    CGRect mapFrame = CGRectMake(0.0f, 64.0f, aw, (ah * 0.8f) - 64.0f);

    m_mapView = [[MAMapView alloc] init];
    [m_mapView setFrame: mapFrame];
//    m_mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(vi_map.bounds), CGRectGetHeight(vi_map.bounds))];
    m_mapView.delegate = self;
    [m_mapView setRotateEnabled:NO];
    [m_mapView setRotateCameraEnabled:NO];
    m_mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    [self.view insertSubview:m_mapView atIndex:0];
    m_locationflag = YES;
    m_annotations = [[NSMutableArray alloc]init];

    m_search = [[AMapSearchAPI alloc] init];
    m_search.delegate = self;
    
    m_loadingview = [[ProcessBoxCommandView alloc]initWithMessage:@""];
    [m_loadingview setFrame:CGRectMake(0.0f, (ah * 0.8f) - 65.0f, aw, 65.0f)];
    [self.view addSubview:m_loadingview];
    [m_loadingview hideView];
    
    UIButton * mapLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mapLocation.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 50.0f, CGRectGetHeight(m_mapView.bounds) - 50.0f - 75.0f, 40.0f, 40.0f);
    mapLocation.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [mapLocation setBackgroundImage:[UIImage imageNamed:@"location_button"] forState:UIControlStateNormal];
    [mapLocation addTarget:self action:@selector(mapViewReset:) forControlEvents:UIControlEventTouchUpInside];
    [m_mapView addSubview: mapLocation];
    
    //
    [iv_icon setImage:[UIImage imageNamed: @"map_carpoint"]];
    [la_addresstitle setTextColor:[UIColor whiteColor]];
    [la_addresstitle setText:@""];
    [la_addresstitle setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE2]];
    [la_addressvalue setTextColor:[UIColor whiteColor]];
    [la_addressvalue setText:@""];
    [la_addressvalue setLineBreakMode:NSLineBreakByCharWrapping];
    [la_addressvalue setNumberOfLines:2];
    [la_addressvalue setFont:[UIFont fontWithName:FONT_XI size:13.0f]];
    la_addressvalue.adjustsFontSizeToFitWidth = YES;
    
    // 模拟数据 FLAG
    if ([self.UserInfo isRunDemo]) {
        [self.view addSubview: [ExtendStaticView MarkDemoView]];
    }
    
//    m_loadingview = [[ProcessBoxView alloc]initWithMessage: @""];
//    [m_loadingview hideView];
//    [self.view addSubview:m_loadingview];
    
    postSession = [[GetPostSessionData alloc] init];
    postSession.delegate = self;

    if ([self.UserInfo isKCUser]) [self sendPostSessionForKCLocation];
    else [self sendPostSessionForLocation];
}

- (void) viewDidAppear:(BOOL)animated {
    m_mapView.showsCompass = NO;
    m_mapView.showsScale = NO;
    m_mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    // 显示定位信息 需要 info.plist NSLocationWhenInUseUsageDescription[String]
    m_mapView.showsUserLocation = YES;
    [m_mapView setZoomLevel:16.1 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) mapViewReset:(id)sender {
    m_mapView.showsUserLocation = YES;
    [m_mapView setZoomLevel:16.1 animated:YES];
    [m_mapView showAnnotations:m_mapView.annotations animated:YES];
}

- (void) doFreshLocation {
    if ([self.UserInfo isKCUser]) [self sendPostSessionForKCLocation];
    else [self sendPostSessionForLocation];
}

- (void) sendPostSessionForLocation {
//    [m_loadingview setTitile:@"正在连接服务器\n请稍后 .."];
//    [m_loadingview showView];
    
    // 获取车辆定位
    NSString * url = [NSString stringWithFormat:@"%@/api/getVHLPosition", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) sendPostSessionForKCLocation {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * url = [NSString stringWithFormat:@"%@/system/location/query", HTTP_GET_POST_ADDRESS_KC];
        
        // 15695863592 123456
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
        [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
        [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
        [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
      
        NSDictionary * mdic = [self fetchPostSessionForKC:url Body:[self fixDictionaryForKCSession:dict]];
/*
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
        [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
        [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
        [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
        [param setObject:dict forKey:@"ntspheader"];
        [param setObject:@"" forKey:@"content"];
        [param setObject:@"1" forKey:@"isInstant"];
        [param setObject:@"RP-VEH-CON" forKey:@"type"];     // 重新上报车况
        [param setObject: APP_VERSION_CODE forKey:@"version"];
        mdic = [self fetchPostSessionForKC:url Body:param];
        */
        NSDictionary * data = [mdic objectForKey:@"data"];
        NSString * code = [[mdic objectForKey:@"errcode"] stringValue];
        
        if (![code isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * str = [mdic objectForKey:@"errmsg"];
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:str];
                alertview.okBlock = ^(){
                };
                [alertview show];
            });
            return;
        }
        CGFloat latitude = [[data objectForKey:@"lat"] doubleValue];
        CGFloat longitude = [[data objectForKey:@"lng"] doubleValue];
        NSString * city = [[data objectForKey:@"geo_info"] objectForKey:@"city"];
        NSString * adrr = [[data objectForKey:@"geo_info"] objectForKey:@"post_address"];
        if (latitude > 0.0f && longitude > 0.0f
            && (latitude - 90.0f < 0.0f) && (longitude - 180.0f < 0.0f)) {
            // 清除位置点信息
            for (id<MAAnnotation> lp in m_mapView.annotations) {
                if ([lp coordinate].longitude != m_locationPoint.longitude
                    && [lp coordinate].latitude != m_locationPoint.latitude) {
                    [m_mapView removeAnnotation:lp];
                }
            }
            
            m_vehiclePoint.latitude = latitude;
            m_vehiclePoint.longitude = longitude;
            
            NSInteger interval = [[data objectForKey:@"record_timestamp"]integerValue];
            NSDate * date = [[NSDate alloc]initWithTimeIntervalSince1970:interval];
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            NSString * str = [formatter stringFromDate:date];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [la_subTime setText:str];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"车机位置点坐标有误,\n请重新获取。"];
                [alertview show];
            });
            return;
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            MAPointAnnotation * pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = m_vehiclePoint;
            [m_mapView addAnnotation:pointAnnotation];
            
            /* 如果只有一个结果，设置其为中心点. */
            /* 如果有多个结果, 设置地图使所有的annotation都可见. */
            [m_mapView showAnnotations: m_mapView.annotations animated:YES];
            
            [la_addresstitle setText:city];
            [la_addressvalue setText:adrr];
        });
        
    });
    
}

- (IBAction) sendPostSessionForWarning:(id)sender {
    [m_loadingview setTitile:@"指令下发中 .."];
    [m_loadingview showView];
    [bt_warning setEnabled:NO];
    
    if ([self.UserInfo isKCUser]) {
        [self sendPostSessionForWarningForKC];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 发送指令
        NSString * code = nil;
        NSString * result = nil;
        NSString * url = [NSString stringWithFormat:@"%@/api/sendWhistleCommand", HTTP_GET_POST_ADDRESS];
        NSString * body = [NSString stringWithFormat:@"%@&ControlWhistleCommand=1&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
        NSDictionary * mdic = [self fetchPostSession:url Body:body];
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        
        if (![code isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                [bt_warning setEnabled:YES];
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
                [alertview show];
            });
            return;
        }
        
        // 发送 ACK
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_loadingview setTitile: @"指令执行中 .."];
            [m_loadingview showView];
        });
        url = [NSString stringWithFormat:@"%@/api/getAckInfo", HTTP_GET_POST_ADDRESS];
        body = [NSString stringWithFormat: @"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_COMMANDSTATUS];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
        
        while (sp > 0.0f) {
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            mdic = [self fetchPostSession: url Body: body];
            code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
            result = [mdic objectForKey:@"ackInfoStatus"];
            NSLog(@"** get command ackinfo - %f %@", sp, code);
            if ([result isEqualToString:@"0"] && [code isEqualToString:@"200"]) break;
            
            // 程序暂停 2s
            [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
        }
        
        if (sp < 0.0f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Command Ackinfo Time Out ..");
                [m_loadingview hideView];
                [bt_warning setEnabled:YES];
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton: NETWORK_TIMEOUT];
                [alertview show];
            });
            return;
        }
        
        // 发送 执行结果查询
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        url = [NSString stringWithFormat:@"%@/api/getWhistleResult", HTTP_GET_POST_ADDRESS];
        body = [NSString stringWithFormat: @"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
        sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_COMMANDRESULT];
        sp = [sDate timeIntervalSinceDate:[NSDate date]];
        
        while (sp > 0.0f) {
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            mdic = [self fetchPostSession: url Body: body];
            code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
            result = [mdic objectForKey:@"whistleResult"];
            NSLog(@"** get command ackinfo - %f %@", sp, code);
            if ([code isEqualToString:@"200"]) break;
            
            // 程序暂停 2s
            [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
        }
        
        if (sp < 0.0f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Command Ackinfo Time Out ..");
                [m_loadingview hideView];
                [bt_warning setEnabled:YES];
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage: NETWORK_TIMEOUT]];
                [alertview show];
            });
            return;
        }
        
        if ([result isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"指令发送失败!"];
                [alert show];
            });
        }
        else if ([result isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"指令发送成功!"];
                [alert show];
            });
        }
        else if ([result isEqualToString:@"2"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"控制失败,\n您的车辆不符合控制条件!"];
                [alert show];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_loadingview hideView];
            [bt_warning setEnabled:YES];
        });
    });
}

- (void) sendPostSessionForWarningForKC {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * code = nil;
        NSString * result = nil;
        
        NSString * url = [NSString stringWithFormat:@"%@/system/command/send", HTTP_GET_POST_ADDRESS_KC];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
        [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
        [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
        [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
        NSMutableDictionary * body = [[NSMutableDictionary alloc]init];
        [body setObject: dict forKey: @"ntspheader"];
        [body setObject: @"1" forKey: @"isInstant"];
        [body setObject: @"SEEK-CAR" forKey: @"type"];
        [body setObject: APP_VERSION_CODE forKey: @"version"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_loadingview setTitile: @"指令执行中 .."];
            [m_loadingview showView];
        });
        
        NSDictionary * mdic = [self fetchPostSessionForKC:url Body:body];
        code = [[mdic objectForKey:@"errcode"] stringValue];
        if ([code isEqualToString:@"0"]) {
            result = [[mdic objectForKey: @"data"] objectForKey:@"msg_id"];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * str = [mdic objectForKey:@"errmsg"];
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:str];
                alertview.okBlock = ^(){
                    [m_loadingview hideView];
                    [bt_warning setEnabled:YES];
                };
                [alertview show];
            });
            return;
        }
//
        url = [NSString stringWithFormat: @"%@/system/command/QueryStatus", HTTP_GET_POST_ADDRESS_KC];
        [body removeAllObjects];
        [body setObject: dict forKey: @"ntspheader"];
        
        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_COMMANDSTATUS];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
        
        while (sp > 0.0f) {
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            mdic = [self fetchPostSessionForKC: url Body: body];
            code = [[mdic objectForKey:@"errcode"] stringValue];
            result = [[mdic objectForKey:@"data"]objectForKey:@"seek_car_status"];
            NSLog(@"** get command status for kc - %f %@", sp, code);
            if ([result isEqualToString:@"0"] || [result isEqualToString:@"1"] || [result isEqualToString:@"2"]) break;
            
            // 程序暂停 2s
            [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
        }
        
        if (![code isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * str = [mdic objectForKey:@"errmsg"];
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:str];
                alertview.okBlock = ^(){
                    [m_loadingview hideView];
                    [bt_warning setEnabled:YES];
                };
                [alertview show];
            });
            return;
        }
        
        if (sp < 0.0f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Command Ackinfo Time Out ..");
                [m_loadingview hideView];
                [bt_warning setEnabled:YES];
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton: NETWORK_TIMEOUT];
                [alertview show];
            });
            return;
        }
        
        if ([result isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"车辆操作状态未知！"];
                [alert show];
            });
        }
        else if ([result isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"指令发送成功!"];
                [alert show];
            });
        }
        else if ([result isEqualToString:@"2"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"车辆需要断电并落锁全部车门才能进行闪灯鸣笛操作,\n请您排查车况后重试!"];
                [alert show];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_loadingview hideView];
            [bt_warning setEnabled:YES];
        });
    });
        
}

- (void) didPostSessionRequest:(NSString *)request {
    if ([request isEqualToString:@"NSURLErrorNetworkConnectionLost"]) {
        return;
    }
    
    if ([request isEqualToString:@"jk-Error"]) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:NETWORK_ERROR];
        [alertview show];
        return;
    }
    
    [m_mapView setZoomLevel:16.1 animated:YES];
    
    NSString * code = nil;
    NSDictionary * mdic = [postSession getDictionaryFromRequest];
    if ([[mdic allKeys] containsObject:@"vhlLatitude"] && [[mdic allKeys] containsObject:@"vhlLontitude"]) {
        
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            CGFloat latitude = [[mdic objectForKey:@"vhlLatitude"] doubleValue];
            CGFloat longitude = [[mdic objectForKey:@"vhlLontitude"] doubleValue];
            if (latitude > 0.0f && longitude > 0.0f
                && (latitude - 90.0f < 0.0f)
                && (longitude - 180.0f < 0.0f)) {
                // 清除位置点信息
                
                if (m_locationPoint.longitude == 0.0f) {
                    [m_mapView removeAnnotations: m_mapView.annotations];
                }
                else {
                    for (id<MAAnnotation> lp in m_mapView.annotations) {
                        if ([lp coordinate].longitude != m_locationPoint.longitude
                            && [lp coordinate].latitude != m_locationPoint.latitude) {
                            [m_mapView removeAnnotation:lp];
                        }
                    }
                }
                
                m_vehiclePoint.latitude = [[mdic objectForKey:@"vhlLatitude"] doubleValue];
                m_vehiclePoint.longitude = [[mdic objectForKey:@"vhlLontitude"] doubleValue];
                
//                116.480983, 39.989628
//                m_vehiclePoint.latitude = 39.989628;
//                m_vehiclePoint.longitude = 116.480983;

                MAPointAnnotation * pointAnnotation = [[MAPointAnnotation alloc] init];
                pointAnnotation.coordinate = m_vehiclePoint;
                [m_mapView addAnnotation:pointAnnotation];

                /* 如果只有一个结果，设置其为中心点. */
                /* 如果有多个结果, 设置地图使所有的annotation都可见. */
                [m_mapView showAnnotations: m_mapView.annotations animated:YES];
                
                // 刷新当位置点
                m_locationflag = YES;

                //构造AMapReGeocodeSearchRequest对象
                AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
                regeo.location = [AMapGeoPoint locationWithLatitude:m_vehiclePoint.latitude longitude:m_vehiclePoint.longitude];
                regeo.radius = 10000;
                regeo.requireExtension = YES;

                //发起逆地理编码
                [m_search AMapReGoecodeSearch: regeo];
            }
            else {
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"车机位置点坐标有误,\n请重新获取。"];
                [alertview show];
            }
        }
    }
    
    if ([mdic count] == 3 && [[mdic allKeys] containsObject:@"data"]) {
        code = [[mdic objectForKey:@"errcode"] stringValue];
        NSDictionary * dict = [mdic objectForKey:@"data"];
        
        if ([code isEqualToString:@"0"] && [dict count] == 13) {
            CGFloat latitude = [[dict objectForKey:@"lat"] doubleValue];
            CGFloat longitude = [[dict objectForKey:@"lng"] doubleValue];
            if (latitude > 0.0f && longitude > 0.0f
                && (latitude - 90.0f < 0.0f)
                && (longitude - 180.0f < 0.0f)) {
                // 清除位置点信息
                for (id<MAAnnotation> lp in m_mapView.annotations) {
                    if ([lp coordinate].longitude != m_locationPoint.longitude
                        && [lp coordinate].latitude != m_locationPoint.latitude) {
                        [m_mapView removeAnnotation:lp];
                    }
                }
                
                m_vehiclePoint.latitude = latitude;
                m_vehiclePoint.longitude = longitude;
                
                MAPointAnnotation * pointAnnotation = [[MAPointAnnotation alloc] init];
                pointAnnotation.coordinate = m_vehiclePoint;
                [m_mapView addAnnotation:pointAnnotation];
                
                /* 如果只有一个结果，设置其为中心点. */
                /* 如果有多个结果, 设置地图使所有的annotation都可见. */
                [m_mapView showAnnotations: m_mapView.annotations animated:YES];
                
                [la_addresstitle setText:[[dict objectForKey:@"geo_info"] objectForKey:@"city"]];
                [la_addressvalue setText:[[dict objectForKey:@"geo_info"] objectForKey:@"post_address"]];
            }
        }
    }

    if ([code isEqualToString:@"402"]) {
        [(MainNavigationController *)self.navigationController doLogoff:self.userfixstr];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyRunStatus Value:@"OTHERLINE"];
    }

    if ([code isEqualToString:@"200"] || [code isEqualToString:@"0"]) return;
    else {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
        [alertview show];
    }
}

// Map Functions
- (void) mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if(updatingLocation) {
        //取出当前位置的坐标
//        NSLog(@"latitude: %f, longitude: %f",userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        
        m_locationPoint.longitude = userLocation.coordinate.longitude;
        m_locationPoint.latitude = userLocation.coordinate.latitude;

//        m_locationflag = NO;
    }
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    id<MAAnnotation> annotation = view.annotation;
    MAPointAnnotation * selectedAnnotation = (MAPointAnnotation *)annotation;
    NSLog(@"map selected annotation %f %f", selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude);
    
    [m_mapView setZoomLevel:16.1 animated:YES];
    m_mapView.centerCoordinate = selectedAnnotation.coordinate;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString * pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView * annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.canShowCallout = NO;
        [annotationView setSelected:NO];
        annotationView.highlighted = YES;
        annotationView.image = [UIImage imageNamed:@"map_carpoint"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0.0f, -18.0f);
        return annotationView;
    }
    
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"map_location"];
        annotationView.centerOffset = CGPointMake(0.0f, 0.0f);
        return annotationView;
    }
    
    return nil;
}

// /* 自定义定位精度对应的MACircleView. */
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    
//    if (overlay == mapView.userLocationAccuracyCircle) {
//    MACircleRenderer *accuracyCircleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
//    accuracyCircleRenderer.lineWidth = 2.f;
//        accuracyCircleRenderer.strokeColor = [UIColor lightGrayColor];
//        accuracyCircleRenderer.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
//        return accuracyCircleRenderer;
//    }
    return nil;
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSLog(@"ReGeo: %@", response.regeocode.formattedAddress);
        NSString * result = nil;
        if (![response.regeocode.addressComponent.township isEqualToString:@""]) {
            result = response.regeocode.addressComponent.township;
        }
        
        if (![response.regeocode.addressComponent.building isEqualToString:@""]) {
            result = response.regeocode.addressComponent.building;
        }
        
        if (result == nil) {
            if ([response.regeocode.aois count] > 0) {
                AMapAOI * aoi = [response.regeocode.aois objectAtIndex:0];
                result = aoi.name;
            }

            if ([response.regeocode.roadinters count] > 0) {
                AMapRoadInter * roadinter = [response.regeocode.roadinters objectAtIndex:0];
                result = roadinter.firstName;
            }
            
            if ([response.regeocode.roads count] > 0) {
                AMapRoad * road = [response.regeocode.roads objectAtIndex:0];
                result = road.name;
            }
        }
        
        if (result == nil) result = response.regeocode.formattedAddress;

        [la_addresstitle setText:result];
        [la_addressvalue setText:response.regeocode.formattedAddress];
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
