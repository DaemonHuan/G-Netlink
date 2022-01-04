//
//  VehicleConditionOfBatteryViewController.m
//  G-NetLink
//
//  Created by jayden on 14-5-6.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleConditionOfBatteryViewController.h"
#import "BaseCustomMessageBox.h"
#import "Vehicle.h"

@interface VehicleConditionOfBatteryViewController ()
{
    Vehicle *vehicle;
    NSTimer *requestTimer;
    NSString *tempRecordTimestamp;
    NSInteger requestIndex;
    BOOL isGetTimeStemp;
}
@end

@implementation VehicleConditionOfBatteryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    VehicleConditionOfBatteryView *view=[[VehicleConditionOfBatteryView alloc] initWithFrame:[self createViewFrame]];
    view.customTitleBar.buttonEventObserver=self;
    self.view=view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    VehicleConditionOfBatteryView *view = (VehicleConditionOfBatteryView *)self.view;
    UIImage *bottomImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
    customActivityIndicatorView.frame = CGRectMake(0, view.customTitleBar.frame.size.height + 20, self.view.bounds.size.width, self.view.bounds.size.height - (view.customTitleBar.frame.size.height + 20 + bottomImage.size.height));
    customActivityIndicatorView.alpha = 0.9;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)settingViewControllerId
{
    _viewControllerId=VIEWCONTROLLER_VEHICLECONDITIONOFBATTERY;
}

-(void)receiveMessage:(Message *)message
{
    [super receiveMessage:message];
    VehicleConditionOfBatteryView *view=(VehicleConditionOfBatteryView *)self.view;
    vehicle = message.externData;
    view.lbl_recordTime.text = [vehicle.record_timestamp substringToIndex:vehicle.record_timestamp.length - 4];
    VehicleBattery *battery=[(Vehicle *)message.externData batterys];
    if (battery) {
        if (!battery.batteryVoltageStatus) {
            view.batteryStatus=StatusNormal;
        }else{
            view.batteryStatus=StatusLower;
        }
        view.batteryValue=battery.batteryVoltageStatus;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - CustomTitleBar_ButtonDelegate
-(IBAction)leftButton_onClick:(id)sender
{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_RETURN;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    msg.sendObjectID = _viewControllerId;
    msg.externData = vehicle;
    [self sendMessage:msg];
}

-(IBAction)rightButton_onClick:(id)sender
{
    VehicleConditionOfBatteryView *view=(VehicleConditionOfBatteryView *)self.view;
    requestIndex = 0;
    view.customTitleBar.rightButton.userInteractionEnabled = NO;
    customActivityIndicatorView.showText = @"最新车况信息获取中";
    [self lockView];
    isGetTimeStemp = YES;
    if (!vehicle) {
        vehicle=[[Vehicle alloc] init];
    }
    vehicle.observer=self;
    [vehicle getCondition];
}

- (void)getLastConditionReport
{
    if (!vehicle) {
        vehicle=[[Vehicle alloc] init];
    }
    requestIndex = 1;
    vehicle.observer=self;
    [vehicle getCondition];
    
    if (!requestTimer) {
        __block VehicleConditionOfBatteryViewController *blockSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            blockSelf->requestTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:blockSelf selector:@selector(getLastConditionReportOfTimer) userInfo:nil repeats:YES] ;
            [[NSRunLoop currentRunLoop] addTimer:blockSelf->requestTimer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
    }
}

- (void)getLastConditionReportOfTimer
{
    requestIndex++;
    if (!vehicle) {
        vehicle=[[Vehicle alloc] init];
    }
    vehicle.observer=self;
    [vehicle getCondition];
}

#pragma mark - DataModuleDelegate
-(void)didDataModuleNoticeSucess:(BaseDataModule*)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    VehicleConditionOfBatteryView *view=(VehicleConditionOfBatteryView *)self.view;
    if (businessID == BUSINESS_VEHICLE_REPORT_CONDITION) {
        [self getLastConditionReport];
    } else if(businessID == BUSINESS_VEHICLE_GETCONDITION) {
        if (isGetTimeStemp) {
            isGetTimeStemp = NO;
            tempRecordTimestamp = vehicle.record_timestamp;
            if (!vehicle) {
                vehicle=[[Vehicle alloc] init];
            }
            vehicle.observer=self;
            [vehicle reReportCondition];
        } else {
            if (requestIndex >= 15 && [tempRecordTimestamp isEqualToString:vehicle.record_timestamp]) {
                //如果是第6次查询请求并且时间戳较第一次请求的时间戳相同，那么将弹窗提示查询超时警告
                BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:@"查询超时" forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
                baseCustomMessageBox.animation = YES;
                baseCustomMessageBox.autoCloseTimer = 1;
                [self.view addSubview:baseCustomMessageBox];
            }
            
            if((tempRecordTimestamp != nil || ![tempRecordTimestamp isEqualToString:@""]) && ![tempRecordTimestamp isEqualToString:vehicle.record_timestamp]){
                //两次不相同
                //记录这次的
                tempRecordTimestamp = vehicle.record_timestamp;
                
                //停止锁屏
                [self unlockViewSubtractCount];
                view.customTitleBar.rightButton.userInteractionEnabled = YES;
                
                //停止定时任务
                if (requestTimer != nil) {
                    [requestTimer invalidate];
                    requestTimer = nil;
                }
            }
        }
        
        //设置数据
        view.lbl_recordTime.text = [vehicle.record_timestamp substringToIndex:vehicle.record_timestamp.length - 4];
        VehicleBattery *battery=vehicle.batterys;
        if (battery) {
            if (!battery.batteryVoltageStatus) {
                view.batteryStatus=StatusNormal;
            }else{
                view.batteryStatus=StatusLower;
            }
            view.batteryValue=battery.batteryVoltageStatus;
        }
        
        NSLog(@"-----------%d",requestIndex);
        if (requestIndex >= 15) {
            //停止锁屏
            [self unlockViewSubtractCount];
            view.customTitleBar.rightButton.userInteractionEnabled = YES;
            
            //停止定时任务
            if (requestTimer != nil) {
                [requestTimer invalidate];
                requestTimer = nil;
            }
        }
    }
}

- (void)didDataModuleNoticeFail:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID forErrorCode:(int)errorCode forErrorMsg:(NSString *)errorMsg
{
    [super didDataModuleNoticeFail:baseDataModule forBusinessType:businessID forErrorCode:errorCode forErrorMsg:errorMsg];
    VehicleConditionOfBatteryView *view=(VehicleConditionOfBatteryView *)self.view;
    view.customTitleBar.rightButton.userInteractionEnabled = YES;
    
    //停止定时任务
    if (requestTimer != nil) {
        [requestTimer invalidate];
        requestTimer = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (requestTimer != nil) {
        [requestTimer invalidate];
        requestTimer = nil;
    }
    requestIndex = 0;
}

-(void)dealloc
{
    vehicle.observer = nil;
}
@end
