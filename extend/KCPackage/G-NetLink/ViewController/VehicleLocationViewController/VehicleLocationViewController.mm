//
//  VehicleLocationViewController.m
//  G-NetLink
//
//  Created by a95190 on 14-10-11.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleLocationViewController.h"
#define MapZoomLevel 7

@interface VehicleLocationViewController ()
{
    NSTimer *requestTimer;
    NSString *tempRecordTimestamp;
    NSInteger requestIndex;
    BOOL isGetTimeStemp;
    
    VehicleLocationView * vehicleLocationView;
}

@end

@implementation VehicleLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     
    }
    return self;
}

- (void)loadView
{
    vehicleLocationView = [[VehicleLocationView alloc] initWithFrame:[self createViewFrame]];
    vehicleLocationView.customTitleBar.buttonEventObserver = self;
//    vehicleLocationView.m_mapview.delegate = self;
    
    self.view = vehicleLocationView;
}


-(IBAction)leftButton_onClick:(id)sender
{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_RETURN;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}

-(IBAction)rightButton_onClick:(id)sender
{
    
    VehicleLocationView *view = (VehicleLocationView *)self.view;
    view.customTitleBar.rightButton.userInteractionEnabled = NO;
    customActivityIndicatorView.showText = @"最新位置信息获取中";
    [self lockView];
    requestIndex = 0;
    isGetTimeStemp = YES;
    if (!vehicleLocation) {
        vehicleLocation = [[VehicleLocation alloc] init];
    }
    vehicleLocation.observer = self;
    [vehicleLocation getLocation];
     
}

-(void)didGetCurrentGpsInfo:(LocationInfomation*)locationInfo
{
    nowLocationInfo = locationInfo;
    MBPoint point;
    point.x = [locationInfo.longitude doubleValue];
    point.y = [locationInfo.latitude doubleValue];
    
    if(point.x == 0 || point.y == 0)
        return;
    
    if (locationAnnotation == nil) {
        CGPoint pivotPoint = {0.5, 1};
        locationAnnotation = [[MBAnnotation alloc] initWithZLevel:2 pos:point iconId:1500 pivot: pivotPoint];
        locationAnnotation.clickable = NO;
//        [((VehicleLocationView *)self.view).mapView addAnnotation:locationAnnotation];
    }
    locationAnnotation.position = point;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    VehicleLocationView *view = (VehicleLocationView *)self.view;
    UIImage *bottomImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
    customActivityIndicatorView.frame = CGRectMake(0, view.customTitleBar.frame.size.height + 20, self.view.bounds.size.width, self.view.bounds.size.height - (view.customTitleBar.frame.size.height + 20 + bottomImage.size.height));
    customActivityIndicatorView.alpha = 0.9;
//    view.customTitleBar.rightButton.userInteractionEnabled = NO;
    
    customActivityIndicatorView.showText = @"最新位置信息获取中";
    [self lockView];
    isGetTimeStemp = YES;
    if (!vehicleLocation) {
        vehicleLocation = [[VehicleLocation alloc] init];
    }
    
    vehicleLocation.observer = self;
    [vehicleLocation getLocation];
}

- (void) viewDidAppear:(BOOL)animated {
}

- (void)getLastLocationReport
{
    requestIndex = 1;
//    if (!vehicleLocation) {
//        vehicleLocation = [[VehicleLocation alloc] init];
//    }
//    vehicleLocation.observer = self;
//    [vehicleLocation getLocation];
    
    if (!requestTimer) {
        __block VehicleLocationViewController *blockSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            blockSelf->requestTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:blockSelf selector:@selector(getLastLocationReportOfTimer) userInfo:nil repeats:YES] ;
            [[NSRunLoop currentRunLoop] addTimer:blockSelf->requestTimer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
    }
}

- (void)getLastLocationReportOfTimer
{
    requestIndex++;
//    if (!vehicleLocation) {
//        vehicleLocation = [[VehicleLocation alloc] init];
//    }
//    vehicleLocation.observer = self;
//    [vehicleLocation getLocation];
}

- (void)didDataModuleNoticeFail:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID forErrorCode:(int)errorCode forErrorMsg:(NSString *)errorMsg
{
    [super didDataModuleNoticeFail:baseDataModule forBusinessType:businessID forErrorCode:errorCode forErrorMsg:errorMsg];
    
    VehicleLocationView *view = (VehicleLocationView *)self.view;
    view.customTitleBar.rightButton.userInteractionEnabled = YES;
    
    //停止定时任务
    if (requestTimer != nil) {
        [requestTimer invalidate];
        requestTimer = nil;
    }
}

- (void)didDataModuleNoticeSucess:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID
{
//    vehicleLocationView = (VehicleLocationView *)self.view;
    if (businessID == BUSINESS_VEHICLE_REPORT_CONDITION) {
        [self getLastLocationReport];
    } else if (businessID == BUSINESS_VEHICLE_GETLOCATION) {
        //停止锁屏
        [self unlockViewSubtractCount];
        //开启刷新按钮交互
        vehicleLocationView.customTitleBar.rightButton.userInteractionEnabled = YES;
        
        if (isGetTimeStemp) {
            isGetTimeStemp = NO;
            tempRecordTimestamp = vehicleLocation.locaInfo.recordTimestamp;
            if (!vehicleLocation) {
                vehicleLocation = [[VehicleLocation alloc] init];
            }
            vehicleLocation.observer = self;
            [vehicleLocation reReportLocation];
            
        } else {
            if (requestIndex >= 15 && [tempRecordTimestamp isEqualToString:vehicleLocation.locaInfo.recordTimestamp]) {
                //如果是第6次查询请求并且时间戳较第一次请求的时间戳相同，那么将弹窗提示查询超时警告
//                BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:@"查询超时" forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
//                baseCustomMessageBox.animation = YES;
//                baseCustomMessageBox.autoCloseTimer = 1;
//                [self.view addSubview:baseCustomMessageBox];
                tempRecordTimestamp = nil;
            }
            
            if((tempRecordTimestamp != nil || ![tempRecordTimestamp isEqualToString:@""]) && ![tempRecordTimestamp isEqualToString:vehicleLocation.locaInfo.recordTimestamp]){
                //两次不相同
                //停止锁屏
                [self unlockViewSubtractCount];
                //开启刷新按钮交互
                vehicleLocationView.customTitleBar.rightButton.userInteractionEnabled = YES;
                
                //停止定时任务
                if (requestTimer != nil) {
                    [requestTimer invalidate];
                    requestTimer = nil;
                }
            }
            
        }
        
        if (!location) {
            location = [[Location alloc] init];
        }
//        location.observer = self;
//        [location requestLocation];
        
        /*
        if (!vehicleAnnotation) {
            [vehicleLocationView.mapView removeAnnotation:vehicleAnnotation];
            vehicleAnnotation = nil;
        }

        MBPoint vehiclePoint;
        vehiclePoint.x = [vehicleLocation.locaInfo.lng doubleValue] * 100000;
        vehiclePoint.y = [vehicleLocation.locaInfo.lat doubleValue] * 100000;
        
        [vehicleLocationView.mapView setWorldCenter:vehiclePoint];
        [vehicleLocationView.mapView setZoomLevel:MapZoomLevel];
        
        
        currentVehiclePoint = vehiclePoint;
         //设置车辆位置标注
         
         */
        vehicleLocationView.lbl_recordTime.text = vehicleLocation.locaInfo.recordTimestamp;
        

        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@" +++++ %@ %@ %@", vehicleLocation.locaInfo.lat, vehicleLocation.locaInfo.lng, vehicleLocation.locaInfo.postAddress);
            // inser point ..
            [vehicleLocationView insertPointForMap:[vehicleLocation.locaInfo.lat floatValue] Long:[vehicleLocation.locaInfo.lng floatValue] Msg:vehicleLocation.locaInfo.postAddress];
            

        });
        
        //设置地址弹出框
        [self setupCalloutView];
        
        if (requestIndex >= 15) {
            //停止锁屏
            [self unlockViewSubtractCount];
            //开启刷新按钮交互
            vehicleLocationView.customTitleBar.rightButton.userInteractionEnabled = YES;
            
            //停止定时任务
            if (requestTimer != nil) {
                [requestTimer invalidate];
                requestTimer = nil;
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (requestTimer != nil) {
        [requestTimer invalidate];
        requestTimer = nil;
    }
}

- (void)setupCalloutView
{
    VehicleLocationView *vehicleLocationView = (VehicleLocationView *)self.view;
//    MBPoint point = [vehicleLocationView.mapView world2Screen:currentVehiclePoint];
    
    vehicleLocationView.currentMapPoiView.address = vehicleLocation.locaInfo.postAddress;
    
    vehicleLocationView.currentMapPoiView.point = currentVehiclePoint;
//    CGPoint screenPoint = CGPointMake(point.x, point.y-vehicleLocationView.currentMapPoiView.calloutHeight);
//    [vehicleLocationView.currentMapPoiView setCenter:screenPoint];
//    [vehicleLocationView.mapView addSubview:vehicleLocationView.currentMapPoiView];
}

/*
-(void)mbMapView:(MBMapView *)mapView onAnnotationClicked:(MBAnnotation *)annot area:(MBAnnotationArea)area
{
    [self setupCalloutView];
}

- (void)mbMapView:(MBMapView *)mapView didChanged:(MBCameraSetting)cameraSetting
{
    VehicleLocationView *vehicleLocationView = (VehicleLocationView *)self.view;
    
    if(vehicleLocationView.currentMapPoiView!=nil)
    {
        MBPoint nowPoint;
        nowPoint = vehicleLocationView.currentMapPoiView.point;
        MBPoint point = [mapView world2Screen:nowPoint];
        CGPoint p = CGPointMake(point.x, point.y-vehicleLocationView.currentMapPoiView.calloutHeight);
        vehicleLocationView.currentMapPoiView.center = p;
    }
}  */
 

- (void)mbMapViewOnDrawing:(MBMapView *)mapView
{

}

- (void)settingViewControllerId
{
    _viewControllerId=VIEWCONTROLLER_VEHICLELOCATION;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)dealloc
{
//    VehicleLocationView *vehicleLocationView = (VehicleLocationView *)self.view;
//    vehicleLocationView.mapView.delegate = nil;
//    vehicleLocationView.mapView = nil;
}


@end
