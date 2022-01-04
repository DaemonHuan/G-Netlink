//
//  VehicleConditionViewController.m
//  G-NetLink
//
//  Created by jayden on 14-5-4.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleConditionViewController.h"

@interface VehicleConditionViewController ()
{
    BOOL isACC_On;
    BOOL isReceiveMessage;
    BOOL isGetTimeStemp;
    NSTimer *requestTimer;
    NSString *tempRecordTimestamp;
    NSInteger requestIndex;
}
@end

@implementation VehicleConditionViewController

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
    VehicleConditionView *view=[[VehicleConditionView alloc] initWithFrame:[self createViewFrame]];
    view.customTitleBar.buttonEventObserver=self;
    view.eventObserver=self;
    self.view=view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    VehicleConditionView *view = (VehicleConditionView *)self.view;
    UIImage *bottomImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
    customActivityIndicatorView.frame = CGRectMake(0, view.customTitleBar.frame.size.height + 20, self.view.bounds.size.width, self.view.bounds.size.height - (view.customTitleBar.frame.size.height + 20 + bottomImage.size.height));
    customActivityIndicatorView.alpha = 0.9;
    customActivityIndicatorView.backgroundColor = [UIColor clearColor];
    
    //如果不是接收的数据跳转
    if (!isReceiveMessage) {
        customActivityIndicatorView.showText = @"最新车况信息获取中";
        [self lockView];
        //此次为获取时间戳的请求操作
        isGetTimeStemp = YES;
        //发送获取车况的查询
        if (!_vehicle) {
            _vehicle=[[Vehicle alloc] init];
        }
        _vehicle.observer=self;
        [_vehicle getCondition];
    }
}

- (void)getLastConditionReport
{
    if (!_vehicle) {
        _vehicle=[[Vehicle alloc] init];
    }
    requestIndex = 1;
    _vehicle.observer=self;
    [_vehicle getCondition];
    
    if (!requestTimer) {
        __block VehicleConditionViewController *blockSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            blockSelf->requestTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:blockSelf selector:@selector(getLastConditionReportOfTimer) userInfo:nil repeats:YES] ;
            [[NSRunLoop currentRunLoop] addTimer:blockSelf->requestTimer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
    }
}

- (void)receiveMessage:(Message *)message
{
    if (message.sendObjectID == VIEWCONTROLLER_VEHICLECONDITIONOFDOORORWINDOW || message.sendObjectID == VIEWCONTROLLER_VEHICLECONDITIONOFBATTERY) {
        isReceiveMessage = YES;
        VehicleConditionView *view=(VehicleConditionView*)self.view;
        _vehicle = (Vehicle *)message.externData;
        //设置数据
        isACC_On = NO;
        if (_vehicle.windows.driverWindowStatus|_vehicle.windows.copilotWindowStatus|_vehicle.windows.rearLeftWindowStatus|_vehicle.windows.rearRightWindowStatus|_vehicle.windows.sunroofStatus!=0) {
            view.windowsStatus=StatusNotOK;
        }else{
            view.windowsStatus=StatusOK;
        }
        
        if (_vehicle.doors.driverDoorStatus|_vehicle.doors.copilotDoorStatus|_vehicle.doors.realLeftDoorStatus|_vehicle.doors.realRightDoorStatus|_vehicle.doors.trunkStatus!=0) {
            view.doorsStatus=StatusNotOK;
        }else{
            view.doorsStatus=StatusOK;
        }
        
        if (_vehicle.batterys.batteryVoltageStatus) {
            view.powerStatus=StatusNotOK;
        }else{
            view.powerStatus=StatusOK;
        }
        
        view.lbl_recordTime.text = [_vehicle.record_timestamp substringToIndex:_vehicle.record_timestamp.length - 4];
        tempRecordTimestamp = _vehicle.record_timestamp;
    }
}

- (void)getLastConditionReportOfTimer
{
    requestIndex++;
    if (!_vehicle) {
        _vehicle=[[Vehicle alloc] init];
    }
    _vehicle.observer=self;
    [_vehicle getCondition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)settingViewControllerId
{
    _viewControllerId=VIEWCONTROLLER_VEHICLECONDITION;
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
    [self sendMessage:msg];
}

-(IBAction)rightButton_onClick:(id)sender
{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_HALL;
    msg.commandID=MC_CREATE_GRADUALLYINTO_VIEWCONTROLLER;
    [self sendMessage:msg];
}

#pragma mark - VehicleConditionViewDelegate
-(IBAction)itemButton_onClick:(id)sender
{
    if (isACC_On)
    {
        [self lockView];
        [_vehicle getCondition];
        return;
    }
    UIButton *btn=(UIButton *)sender;
    if (btn) {
        Message *msg=[[Message alloc] init];
        msg.commandID=MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
        
        switch (btn.tag) {
            case 1:
                {
                    msg.receiveObjectID=VIEWCONTROLLER_VEHICLECONDITIONOFDOORORWINDOW;
                    NSDictionary *externData = @{@"type":@(CurrentType_Windows),@"data":_vehicle};
                    msg.externData=externData;
                }
                break;
            case 2:
                {
                    msg.receiveObjectID=VIEWCONTROLLER_VEHICLECONDITIONOFDOORORWINDOW;
                    NSDictionary *externData = @{@"type":@(CurrentType_Doors),@"data":_vehicle};
                    msg.externData=externData;
                }
                break;
            case 3:
                msg.receiveObjectID=VIEWCONTROLLER_VEHICLECONDITIONOFBATTERY;
                msg.externData=_vehicle;
                break;
                
            default:
                break;
        }
        
         [self sendMessage:msg];
    }
}

-(IBAction)refreshButton_onClick:(id)sender
{
    customActivityIndicatorView.showText = @"最新车况信息获取中";
    [self lockView];
    requestIndex = 0;
    isGetTimeStemp = YES;
    if (!_vehicle) {
        _vehicle=[[Vehicle alloc] init];
    }
    _vehicle.observer=self;
    [_vehicle getCondition];
}

#pragma mark - DataModuleDelegate
-(void)didDataModuleNoticeSucess:(BaseDataModule*)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    if (businessID == BUSINESS_VEHICLE_REPORT_CONDITION) {
        [self getLastConditionReport];
    } else if(businessID == BUSINESS_VEHICLE_GETCONDITION) {
        
        //如果是时间戳的查询操作
        VehicleConditionView *view=(VehicleConditionView*)self.view;
        if (isGetTimeStemp) {
            //赋值时间戳
            tempRecordTimestamp = _vehicle.record_timestamp;
            //还原状态值
            isGetTimeStemp = NO;
            //重新上报
            if (!_vehicle) {
                _vehicle=[[Vehicle alloc] init];
            }
            _vehicle.observer=self;
            [_vehicle reReportCondition];
        } else {
            if (requestIndex >= 15 && [tempRecordTimestamp isEqualToString:_vehicle.record_timestamp]) {
                //如果是第15次查询请求并且时间戳较第一次请求的时间戳相同，那么将弹窗提示查询超时警告
                BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:@"查询超时" forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
                baseCustomMessageBox.animation = YES;
                baseCustomMessageBox.autoCloseTimer = 2;
                [self.view addSubview:baseCustomMessageBox];
            }
            
            if((tempRecordTimestamp != nil || ![tempRecordTimestamp isEqualToString:@""]) && ![tempRecordTimestamp isEqualToString:_vehicle.record_timestamp]){
                
                //停止锁屏
                [self unlockViewSubtractCount];
                
                //停止定时任务
                if (requestTimer != nil) {
                    [requestTimer invalidate];
                    requestTimer = nil;
                }
            }
        }
        
        //设置数据
        isACC_On = NO;
        if (_vehicle.windows.driverWindowStatus|_vehicle.windows.copilotWindowStatus|_vehicle.windows.rearLeftWindowStatus|_vehicle.windows.rearRightWindowStatus|_vehicle.windows.sunroofStatus!=0) {
            view.windowsStatus=StatusNotOK;
        }else{
            view.windowsStatus=StatusOK;
        }
        
        if (_vehicle.doors.driverDoorStatus|_vehicle.doors.copilotDoorStatus|_vehicle.doors.realLeftDoorStatus|_vehicle.doors.realRightDoorStatus|_vehicle.doors.trunkStatus!=0) {
            view.doorsStatus=StatusNotOK;
        }else{
            view.doorsStatus=StatusOK;
        }
        
        if (_vehicle.batterys.batteryVoltageStatus) {
            view.powerStatus=StatusNotOK;
        }else{
            view.powerStatus=StatusOK;
        }
 
        view.lbl_recordTime.text = [_vehicle.record_timestamp substringToIndex:_vehicle.record_timestamp.length - 4];
        
        NSLog(@"----------------%d",requestIndex);
        if (requestIndex >= 15) {
            //停止锁屏
            [self unlockViewSubtractCount];
            
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
    
    //停止定时任务
    if (requestTimer != nil) {
        [requestTimer invalidate];
        requestTimer = nil;
    }
//    VehicleConditionView *view=(VehicleConditionView*)self.view;
//    [view shutDownBtnUserInterface];
    isACC_On = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    isReceiveMessage = NO;
    
    if (requestTimer != nil) {
        [requestTimer invalidate];
        requestTimer = nil;
    }
}

-(void)dealloc
{
    _vehicle.observer = nil;
}
@end
