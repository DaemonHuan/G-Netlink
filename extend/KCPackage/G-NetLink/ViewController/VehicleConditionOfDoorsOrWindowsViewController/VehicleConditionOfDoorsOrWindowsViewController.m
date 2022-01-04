//
//  VehicleConditionOfDoorsOrWindowsViewController.m
//  G-NetLink
//
//  Created by jayden on 14-5-5.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleConditionOfDoorsOrWindowsViewController.h"
#import "Vehicle.h"

@interface VehicleConditionOfDoorsOrWindowsViewController ()
{
    StripCustomMessageBox *stripCustomMessageBox;
    Vehicle *vehicle;
    NSTimer *requestTimer;
    NSTimer *commandRequestTimer;
    NSString *tempRecordTimestamp;
    NSInteger requestIndex;
    BOOL isSendCommand;
    BOOL isGetTimeStemp;
}
@end

@implementation VehicleConditionOfDoorsOrWindowsViewController

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
    VehicleConditionOfDoorsOrWindowsView *view=[[VehicleConditionOfDoorsOrWindowsView alloc] initWithFrame:[self createViewFrame]];
    view.customTitleBar.buttonEventObserver=self;
    view.eventObserver=self;
    self.view=view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    VehicleConditionOfDoorsOrWindowsView *view = (VehicleConditionOfDoorsOrWindowsView *)self.view;
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
    _viewControllerId=VIEWCONTROLLER_VEHICLECONDITIONOFDOORORWINDOW;
}

-(void)receiveMessage:(Message *)message
{
    [super receiveMessage:message];
    VehicleConditionOfDoorsOrWindowsView *view=(VehicleConditionOfDoorsOrWindowsView *)self.view;
    NSString *carImageName=@"car_normal";
    NSString *lightImageName=@"car";
    view.currentType = [[message.externData objectForKey:@"type"] integerValue];
    vehicle = [message.externData objectForKey:@"data"];
    view.lbl_recordTime.text = [vehicle.record_timestamp substringToIndex:vehicle.record_timestamp.length - 4];
    if (view.currentType == CurrentType_Windows) {
        _windows=[(Vehicle*)[message.externData objectForKey:@"data"] windows];
        _windows.observer=self;
        lightImageName=[lightImageName stringByAppendingString:@"_windows"];
        if (_windows.driverWindowStatus!=0) {
             lightImageName=[lightImageName stringByAppendingString:@"_fontleft"];
        }
        if (_windows.copilotWindowStatus!=0) {
            lightImageName=[lightImageName stringByAppendingString:@"_fontright"];
        }
        if (_windows.rearLeftWindowStatus!=0) {
            lightImageName=[lightImageName stringByAppendingString:@"_backleft"];
        }
        if (_windows.rearRightWindowStatus!=0) {
            lightImageName=[lightImageName stringByAppendingString:@"_backright"];
        }
        if (_windows.sunroofStatus!=0) {
            lightImageName=[lightImageName stringByAppendingString:@"_top"];
        }
        
        if ([lightImageName isEqualToString:@"car_windows"]) {
            view.commandButtonImageName=@"btn_command_normal";
        } else {
            view.commandButtonImageName=@"btn_command_unlocked";
        }
        
    }else if (view.currentType == CurrentType_Doors){
        view.currentType=CurrentType_Doors;
        _doors=[(Vehicle*)[message.externData objectForKey:@"data"] doors];;
        _doors.observer=self;
         lightImageName=[lightImageName stringByAppendingString:@"_door"];
        if (_doors.driverDoorStatus!=0) {
            carImageName=[carImageName stringByAppendingString:@"_fontleft"];
            lightImageName=[lightImageName stringByAppendingString:@"_fontleft"];
        }
        if (_doors.copilotDoorStatus!=0) {
             carImageName=[carImageName stringByAppendingString:@"_fontright"];
            lightImageName=[lightImageName stringByAppendingString:@"_fontright"];
        }
        if (_doors.realLeftDoorStatus!=0) {
             carImageName=[carImageName stringByAppendingString:@"_backleft"];
            lightImageName=[lightImageName stringByAppendingString:@"_backleft"];
        }
        if (_doors.realRightDoorStatus!=0) {
            carImageName=[carImageName stringByAppendingString:@"_backright"];
            lightImageName=[lightImageName stringByAppendingString:@"_backright"];
        }
        view.carImageName=carImageName;
        if ([carImageName isEqualToString:@"car_normal"] ) {
            view.commandButtonImageName=@"btn_command_normal";
        } else {
            view.commandButtonImageName=@"btn_command_unlocked";
        }
        if (_doors.trunkStatus!=0) {
            lightImageName=[lightImageName stringByAppendingString:@"_back"];
            view.commandButtonImageName=@"btn_command_unlocked";
        }
    }
    
    if (![lightImageName isEqualToString:@"car"]) {
        view.lightImageName=lightImageName;
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
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (requestTimer != nil) {
        [requestTimer invalidate];
        requestTimer = nil;
    }
}


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
    VehicleConditionOfDoorsOrWindowsView *doorsOrWindowsView =  (VehicleConditionOfDoorsOrWindowsView*)self.view;
    
    doorsOrWindowsView.customTitleBar.rightButton.userInteractionEnabled = NO;
    customActivityIndicatorView.showText = @"最新车况信息获取中";
    [self lockView];
    requestIndex = 0;
    isSendCommand = NO;
    isGetTimeStemp =YES;

    if (!vehicle) {
        vehicle=[[Vehicle alloc] init];
    }
    vehicle.observer=self;
    [vehicle getCondition];
}

#pragma mark - VehicleConditionOfDoorsOrWindowsDelegate
-(IBAction)commandButton_onClick:(id)sender
{
    if (_doors.driverDoorStatus==0 && _doors.copilotDoorStatus==0 && _doors.realLeftDoorStatus==0 && _doors.realRightDoorStatus==0 && _doors.trunkStatus!=0) {
    
        BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:@"请您手动关闭后备箱" forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
        baseCustomMessageBox.animation = YES;
        baseCustomMessageBox.autoCloseTimer = 5;
        [self.view addSubview:baseCustomMessageBox];
        return;
    }
    
    VehicleConditionOfDoorsOrWindowsView *view=(VehicleConditionOfDoorsOrWindowsView *)self.view;
    NSString *sendingText;
    if ([view.commandButtonImageName isEqualToString:@"btn_command_normal"]) {
        if (view.currentType) { //windows
            sendingText = NSLocalizedStringFromTable(@"DoorsAllClosed_txt",Res_String,@"");
        } else {        //doors
            sendingText =NSLocalizedStringFromTable(@"WindowsAllClosed_txt",Res_String,@"");
        }
        UIImage *image=[UIImage imageNamed:NSLocalizedStringFromTable(@"noticebar_back",Res_Image,@"")];
        stripCustomMessageBox=[[StripCustomMessageBox alloc]initWithOriginY:45 forText:sendingText forBackgroundImage:image];
        stripCustomMessageBox.animation=YES;
        [view addSubview:stripCustomMessageBox];
        return;
    }
    
    if (view.currentType) {
        sendingText=NSLocalizedStringFromTable(@"SendingLockDoors_Condition",Res_String,@"");
    }else{
        sendingText=NSLocalizedStringFromTable(@"SendingCloseWindow_Condition",Res_String,@"");
    }
    sendingText =NSLocalizedStringFromTable(@"DirectivesIssued",Res_String,@"");
    UIImage *image=[UIImage imageNamed:NSLocalizedStringFromTable(@"noticebar_back",Res_Image,@"")];
    stripCustomMessageBox=[[StripCustomMessageBox alloc]initWithOriginY:60 forText:sendingText forBackgroundImage:image];
    stripCustomMessageBox.autoCloseTimer = 8.0;
    stripCustomMessageBox.animation=YES;
    [view addSubview:stripCustomMessageBox];
    
    isSendCommand = YES;
    
    if (view.currentType) {
        [_doors lock:nil withPin:nil];//BUSINESS_VEHICLE_SENDCOMMAND
    }else{
        [_windows close:nil withPin:nil];//BUSINESS_VEHICLE_SENDCOMMAND
    }
}

- (void)getCommandStateWithMsgId:(NSString *)MsgId
{
    VehicleConditionOfDoorsOrWindowsView *view=(VehicleConditionOfDoorsOrWindowsView *)self.view;
    view.customTitleBar.rightButton.userInteractionEnabled = NO;
    
    customActivityIndicatorView.showText = @"指令执行状态获取中";
    [self lockView];
    
    if (!vehicle) {
        vehicle=[[Vehicle alloc] init];
    }
    requestIndex = 1;
    vehicle.observer=self;
    [vehicle getCommandConditionWithMsgId:MsgId];
    
    if (!commandRequestTimer) {
        commandRequestTimer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(getCommandStateOfTimerWithMsgId:) userInfo:MsgId repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:commandRequestTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)getLastConditionData
{
    VehicleConditionOfDoorsOrWindowsView *view=(VehicleConditionOfDoorsOrWindowsView *)self.view;
    view.customTitleBar.rightButton.userInteractionEnabled = NO;
    if (!vehicle) {
        vehicle=[[Vehicle alloc] init];
    }
    requestIndex = 1;
    vehicle.observer=self;
    [vehicle getCondition];
    
    if (!requestTimer) {
        __block VehicleConditionOfDoorsOrWindowsViewController *blockSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            blockSelf->requestTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:blockSelf selector:@selector(getLastConditionOfTimer) userInfo:nil repeats:YES] ;
            [[NSRunLoop currentRunLoop] addTimer:blockSelf->requestTimer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
    }
}

- (void)getLastConditionOfTimer
{
    requestIndex++;
    if (!vehicle) {
        vehicle=[[Vehicle alloc] init];
    }
    vehicle.observer=self;
    [vehicle getCondition];
}

- (void)getCommandStateOfTimerWithMsgId:(NSTimer *)timer
{
    requestIndex++;
    if (!vehicle) {
        vehicle=[[Vehicle alloc] init];
    }
    vehicle.observer=self;
    [vehicle getCommandConditionWithMsgId:[timer userInfo]];
}

- (BOOL)didReceivePushNotification:(NSDictionary *)userInfo
{
    return YES;
}

- (BOOL)didReceiveForegroundPushNotification:(NSDictionary *)userInfo
{
    return YES;
}

#pragma mark - DataModuleDelegate
-(void)didDataModuleNoticeSucess:(BaseDataModule*)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    VehicleConditionOfDoorsOrWindowsView *view=(VehicleConditionOfDoorsOrWindowsView *)self.view;
    if (businessID == BUSINESS_VEHICLE_SENDCOMMAND) {
        if (isSendCommand) {
            NSString * sendingText;
            sendingText = NSLocalizedStringFromTable(@"DirectivesIssuedSuccess",Res_String,@"");
            UIImage *image=[UIImage imageNamed:NSLocalizedStringFromTable(@"noticebar_back",Res_Image,@"")];
            stripCustomMessageBox=[[StripCustomMessageBox alloc]initWithOriginY:60 forText:sendingText forBackgroundImage:image];
            stripCustomMessageBox.autoCloseTimer = 8.0;
            stripCustomMessageBox.animation=YES;
            [view addSubview:stripCustomMessageBox];
        }
        if (view.currentType) {
            [self getCommandStateWithMsgId:_doors.msgId];
        }else{
            [self getCommandStateWithMsgId:_windows.msgId];
        }
        
    }else if(businessID == BUSINESS_VEHICLE_GETCOMMAND_CONDITION) {
        if (vehicle.executeState != ExecuteState_Wait_Handle) {
            //停止轮询
            [self unlockViewSubtractCount];
            VehicleConditionOfDoorsOrWindowsView *doorsOrWindowsView =  (VehicleConditionOfDoorsOrWindowsView*)self.view;
            doorsOrWindowsView.customTitleBar.rightButton.userInteractionEnabled = YES;
            
            //停止定时任务
            if (commandRequestTimer != nil) {
                [commandRequestTimer invalidate];
                commandRequestTimer = nil;
            }
            
            NSString *errorText = @"";
            switch (vehicle.executeState) {
                case ExecuteState_Execute_Success:
                    //执行成功
                    {
                        VehicleConditionOfDoorsOrWindowsView *doorsOrWindowsView =  (VehicleConditionOfDoorsOrWindowsView*)self.view;
                        doorsOrWindowsView.customTitleBar.rightButton.userInteractionEnabled = NO;
                        customActivityIndicatorView.showText = @"最新车况信息获取中";
                        [self lockView];
                        errorText = vehicle.commandMsg.executeDesc;
                        CGFloat duration = 0.0f;
                        if (view.currentType) {
                            duration = 2.0f;
                        }else{
                            duration = 7.0f;
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            isGetTimeStemp = YES;
                            //发送查询
                            if (!vehicle) {
                                vehicle=[[Vehicle alloc] init];
                            }
                            vehicle.observer=self;
                            [vehicle getCondition];
                        });
                    }
                    break;
                case ExecuteState_Execute_Fail:
                    //执行失败
                    errorText = vehicle.commandMsg.executeDesc;
                    break;
                default:
                    break;
            }
            
            if (errorText.length > 0) {
                BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:errorText forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
                baseCustomMessageBox.animation = YES;
                baseCustomMessageBox.autoCloseTimer = 5;
                [self.view addSubview:baseCustomMessageBox];
            }
            
            return;
        }
        
//        NSLog(@"------------%d",requestIndex);
        if (requestIndex >= 15) {
            //停止锁屏
            [self unlockViewSubtractCount];
            view.customTitleBar.rightButton.userInteractionEnabled = YES;
            
            //弹窗超时
            BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:@"查询执行指令超时" forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
            baseCustomMessageBox.animation = YES;
            baseCustomMessageBox.autoCloseTimer = 1;
            [self.view addSubview:baseCustomMessageBox];
            
            //停止定时任务
            if (commandRequestTimer != nil) {
                [commandRequestTimer invalidate];
                commandRequestTimer = nil;
            }
        }
        
    } else if(businessID == BUSINESS_OTHER_SENDVERIFYCODE) {
        
        
    } else if (businessID == BUSINESS_VEHICLE_REPORT_CONDITION) {
        [self getLastConditionData];
    } else if (businessID == BUSINESS_VEHICLE_GETCONDITION) {
        
        if (isGetTimeStemp) {
            if (!vehicle) {
                vehicle=[[Vehicle alloc] init];
            }
            vehicle.observer=self;
            [vehicle reReportCondition];
            tempRecordTimestamp = vehicle.record_timestamp;
            isGetTimeStemp = NO;
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
        
        //车窗车门
        VehicleConditionOfDoorsOrWindowsView *view=(VehicleConditionOfDoorsOrWindowsView *)self.view;
        view.lbl_recordTime.text = [vehicle.record_timestamp substringToIndex:vehicle.record_timestamp.length - 4];
        
        NSString *carImageName=@"car_normal";
        NSString *lightImageName=@"car";
        if (view.currentType == CurrentType_Windows)
        {
            _windows =  vehicle.windows;
            _windows.observer=self;
            lightImageName=[lightImageName stringByAppendingString:@"_windows"];
            if (_windows.driverWindowStatus!=0) {
                lightImageName=[lightImageName stringByAppendingString:@"_fontleft"];
            }
            if (_windows.copilotWindowStatus!=0) {
                lightImageName=[lightImageName stringByAppendingString:@"_fontright"];
            }
            if (_windows.rearLeftWindowStatus!=0) {
                lightImageName=[lightImageName stringByAppendingString:@"_backleft"];
            }
            if (_windows.rearRightWindowStatus!=0) {
                lightImageName=[lightImageName stringByAppendingString:@"_backright"];
            }
            if (_windows.sunroofStatus!=0) {
                lightImageName=[lightImageName stringByAppendingString:@"_top"];
            }
            
            if ([lightImageName isEqualToString:@"car_windows"]) {
                view.commandButtonImageName=@"btn_command_normal";
            } else {
                view.commandButtonImageName=@"btn_command_unlocked";
            }
        }
        else if (view.currentType== CurrentType_Doors)
        {
            _doors = vehicle.doors;
            _doors.observer=self;
            lightImageName=[lightImageName stringByAppendingString:@"_door"];
            if (_doors.driverDoorStatus!=0) {
                carImageName=[carImageName stringByAppendingString:@"_fontleft"];
                lightImageName=[lightImageName stringByAppendingString:@"_fontleft"];
            }
            if (_doors.copilotDoorStatus!=0) {
                carImageName=[carImageName stringByAppendingString:@"_fontright"];
                lightImageName=[lightImageName stringByAppendingString:@"_fontright"];
            }
            if (_doors.realLeftDoorStatus!=0) {
                carImageName=[carImageName stringByAppendingString:@"_backleft"];
                lightImageName=[lightImageName stringByAppendingString:@"_backleft"];
            }
            if (_doors.realRightDoorStatus!=0) {
                carImageName=[carImageName stringByAppendingString:@"_backright"];
                lightImageName=[lightImageName stringByAppendingString:@"_backright"];
            }
            view.carImageName=carImageName;
            if ([carImageName isEqualToString:@"car_normal"] ) {
                view.commandButtonImageName=@"btn_command_normal";
            } else {
                view.commandButtonImageName=@"btn_command_unlocked";
            }
            if (_doors.trunkStatus!=0) {
                lightImageName=[lightImageName stringByAppendingString:@"_back"];
                view.commandButtonImageName=@"btn_command_unlocked";
            }
        }
        
        if (![lightImageName isEqualToString:@"car"])
        {
            view.lightImageName=lightImageName;
        }
        
//        NSLog(@"----------------%d",requestIndex);
        if (requestIndex >= 15) {
            //停止锁屏
            [self unlockViewSubtractCount];
            VehicleConditionOfDoorsOrWindowsView *doorsOrWindowsView =  (VehicleConditionOfDoorsOrWindowsView*)self.view;
            doorsOrWindowsView.customTitleBar.rightButton.userInteractionEnabled = YES;
            
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
    
    VehicleConditionOfDoorsOrWindowsView *view=(VehicleConditionOfDoorsOrWindowsView *)self.view;
    view.customTitleBar.rightButton.userInteractionEnabled = YES;
    
    //停止定时任务
    if (requestTimer != nil) {
        [requestTimer invalidate];
        requestTimer = nil;
    }
    if (commandRequestTimer != nil) {
        [commandRequestTimer invalidate];
        commandRequestTimer = nil;
    }
    
    if (businessID == BUSINESS_VEHICLE_SENDCOMMAND) {
        
        [stripCustomMessageBox removeFromSuperview];
        stripCustomMessageBox = nil;
    }
}
-(void)dealloc
{
    vehicle.observer = nil;
}
@end
