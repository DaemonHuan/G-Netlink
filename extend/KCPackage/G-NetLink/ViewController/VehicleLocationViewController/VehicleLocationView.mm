//
//  VehicleLocationView.m
//  G-NetLink
//
//  Created by a95190 on 14-10-11.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleLocationView.h"
#import "CustomAnnotationView.h"



@implementation VehicleLocationView {
    MAMapView * m_mapview;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"VehicleLocationTitle", Res_String, @"");
        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"btn_refresh",Res_Image,@"")];
        
        _customTitleBar.backgroundImage = nil;
        _lbl_recordTime = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_customTitleBar.frame) - 5, self.frame.size.width, 20)];
        _lbl_recordTime.textAlignment = NSTextAlignmentCenter;
        _lbl_recordTime.font = [UIFont systemFontOfSize:12];
        _lbl_recordTime.textColor = [UIColor whiteColor];
        _lbl_recordTime.backgroundColor = [UIColor clearColor];
        [self addSubview:_lbl_recordTime];
        
        UIImageView *lineView0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_middle_line",Res_Image,@"")]];
        lineView0.frame = CGRectMake(0, _customTitleBar.frame.size.height + 20, self.bounds.size.width, 1);
        [self addSubview:lineView0];
        
        UIImage *g_NetLinkImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
        UIImageView *bottomitemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - g_NetLinkImage.size.height, self.bounds.size.width, g_NetLinkImage.size.height)];
        bottomitemImageView.image = g_NetLinkImage;
        bottomitemImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomitemImageView];
        
    /*
        _mapView = [[MBMapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView0.frame), self.bounds.size.width, self.bounds.size.height-CGRectGetMaxY(lineView0.frame) - g_NetLinkImage.size.height)];
        _mapView.clipsToBounds = YES;
        _mapView.delegate = self;
        if(_mapView.authErrorType == MBSdkAuthError_none){
            [self addSubview:_mapView];
        }  */
        
        [MAMapServices sharedServices].apiKey = MAP_BUNDLEIDENTIFIER;
        m_mapview = [[MAMapView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView0.frame), self.bounds.size.width, self.bounds.size.height-CGRectGetMaxY(lineView0.frame) - g_NetLinkImage.size.height)];
        m_mapview.delegate = self;
        [self addSubview: m_mapview];
        
        m_mapview.showsCompass = NO;
        m_mapview.showsScale = NO;
        m_mapview.userTrackingMode = MAUserTrackingModeNone;
        m_mapview.showsUserLocation = YES;
        [m_mapview setRotateEnabled:NO];
        [m_mapview setRotateCameraEnabled:NO];
        [m_mapview setZoomLevel:16.1 animated:YES];
        
        _currentMapPoiView = [[CustomMapCalloutView alloc] initWithBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"navigation_map_callout",Res_Image,@"")]];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString * ttlatitude = [userDefault objectForKey:USERINFO_CAR_LATITUDE];
        NSString * ttlongitude = [userDefault objectForKey:USERINFO_CAR_LONGITUDE];
        
        if (ttlatitude != nil && ttlongitude != nil) {
            [m_mapview setCenterCoordinate:CLLocationCoordinate2DMake([ttlatitude floatValue], [ttlongitude floatValue])];
        }
    }
    return self;
}

- (void) insertPointForMap:(CGFloat)lat Long:(CGFloat)lon Msg:(NSString *)msg {
    NSArray * annotations = [m_mapview annotations];
    [m_mapview removeAnnotations:annotations];
    
    MAPointAnnotation * pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
    
//    if ([msg length] > 10) {
//        NSString * str = [NSString stringWithFormat:@"%@\n%@", [msg substringWithRange:NSMakeRange(0, 10)], [msg substringWithRange:NSMakeRange(10, [msg length] - 10)]];
//        NSLog(@"==== %@", str);
//        [pointAnnotation setTitle: str];
//    }
//    else {
//        [pointAnnotation setTitle:msg];
//    }
    
    [pointAnnotation setTitle:msg];
//    [pointAnnotation setSubtitle: msg];

    CLLocationCoordinate2D point = CLLocationCoordinate2DMake(lat, lon);
    
    [m_mapview addAnnotation:pointAnnotation];
    [m_mapview setZoomLevel: 12.1 animated:YES];
    m_mapview.centerCoordinate = point;
    [m_mapview setSelectedAnnotations:@[pointAnnotation]];
    
    // 记录当前车辆位置，下次直接显示
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%lf", point.latitude] forKey:USERINFO_CAR_LATITUDE];
    [userDefaults setObject:[NSString stringWithFormat:@"%lf", point.longitude] forKey:USERINFO_CAR_LONGITUDE];
    [userDefaults synchronize];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//        }
//        
////        annotationView.bounds.size = CGSizeMake(200.0f, 200.0f);
//        
//        annotationView.calloutOffset = CGPointMake(0, -8);
//
//        annotationView.canShowCallout = YES;
//        annotationView.highlighted = YES;
//        annotationView.image = [UIImage imageNamed:@"map_normalpoint"];
//        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
//        annotationView.centerOffset = CGPointMake(0, -18);
//        return annotationView;
        
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"map_carpoint"];
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
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

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    id<MAAnnotation> annotation = view.annotation;
    MAPointAnnotation * point = (MAPointAnnotation *)annotation;
    NSLog(@"%f %f", point.coordinate.latitude, point.coordinate.longitude);

}

/*
-(void)setMapViewShowType:(MapViewShowType)mapViewShowType
{
    _mapViewShowType = mapViewShowType;
    if(mapViewShowType == MapViewShowType_2D)
    {
        [_mapView setHeading:0];
        [_mapView setElevation:90];
        _mapView.enableBuilding = FALSE;
    }
    else if(mapViewShowType == MapViewShowType_3D)
    {
        [_mapView setHeading:0];
        [_mapView setElevation:30];
        _mapView.enableBuilding = YES;
    }
} */

@end
