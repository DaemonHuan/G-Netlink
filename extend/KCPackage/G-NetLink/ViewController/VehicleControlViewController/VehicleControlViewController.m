//
//  VehicleControlViewController.m
//  G-NetLink
//
//  Created by jayden on 14-4-24.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleControlViewController.h"
#import "VehicleInfo.h"

@interface VehicleControlViewController ()
{
    StripCustomMessageBox *stripCustomMessageBox;
    VehicleControlView *vehicleControlView;
    VehicleInfo *vehicleInfo;
    BOOL _VehicleStatus;
    NSInteger requestIndex;
    NSTimer *commandRequestTimer;
    NSString *error;
}

@end

@implementation VehicleControlViewController

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
    CGRect frame = [self createViewFrame];    
    frame.size.height = frame.size.height - [UIImage imageNamed:NSLocalizedStringFromTable(@"tab_bar_background",Res_Image,@"")].size.height;

    vehicleControlView=[[VehicleControlView alloc] initWithFrame:frame];
    vehicleControlView.customTitleBar.buttonEventObserver=self;
    vehicleControlView.eventObserver=self;
    self.view=vehicleControlView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _VehicleStatus = NO;
    vehicleWindow=[[VehicleWindow alloc]init];
    vehicleWindow.observer=self;
    vehicleDoor=[[VehicleDoor alloc] init];
    vehicleDoor.observer=self;
    verifyCode = [[VerifyCode alloc]init];
    verifyCode.observer = self;
    vehicle= [[Vehicle alloc]init];
    vehicle.observer = self;
    [vehicle getCondition];
    [self lockView];
    
    vehicleInfo = [self.parentNode getNodeOfSaveDataAtKey:@"vehicleInfo"];
    if(vehicleInfo == nil )
    {
        vehicleInfo = [[VehicleInfo alloc] init];
        vehicleInfo.observer = self;
        [vehicleInfo getInfo];
        [self.parentNode addNodeOfSaveData:@"vehicleInfo" forValue:vehicleInfo];
    }
    else if (vehicleInfo.vehNo == nil || (NSNull *)vehicleInfo.vehNo == [NSNull null]|| vehicleInfo.vehNo.length == 0)
    {
        vehicleInfo.observer = self;
        [vehicleInfo getInfo];
        [self.parentNode addNodeOfSaveData:@"vehicleInfo" forValue:vehicleInfo];
    }
    else
        vehicleControlView.lbl_vehNo.text = vehicleInfo.vehNo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)settingViewControllerId
{
    _viewControllerId=VIEWCONTROLLER_VEHICLECONTROL;
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
    msg.receiveObjectID=VIEWCONTROLLER_VEHICLECONTROLHISTORY;
    msg.commandID=MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
    [self sendMessage:msg];
}

-(IBAction)lightButtonOnClick:(id)sender
{
    // 进行”远程寻车指令操作状态”查询
    [self lockView];
    [self closeTipDelegate];
    [vehicle getRemoteSearchCarCommandStatus];
}

- (void)sendVehicleCommand
{
    VehicleControlView *view = (VehicleControlView *)self.view;
    [view closeTip];
    
    NSString *sendingText;
    UIImage *image=[UIImage imageNamed:NSLocalizedStringFromTable(@"noticebar_back",Res_Image,@"")];
    
    if (view.currentType == CurrentType_Doors && view.doorsStatus == StatusNotOK) {
        [vehicleDoor lock:nil withPin:nil];
        sendingText=NSLocalizedStringFromTable(@"SendingLockDoors",Res_String,@"");
    }
    
    if (view.currentType == CurrentType_Windows && view.windowsStatus == StatusNotOK) {
        [vehicleWindow close:nil withPin:nil];
        sendingText=NSLocalizedStringFromTable(@"SendingCloseWindows",Res_String,@"");
    }
    
    if (view.currentType == CurrentType_LightHorn) {
        [vehicle doubleFlashAndWhistle:nil withPin:nil];
        sendingText=NSLocalizedStringFromTable(@"SendingLightOpen",Res_String,@"");
    }
    
    stripCustomMessageBox.animation=YES;
    stripCustomMessageBox=[[StripCustomMessageBox alloc]initWithOriginY:60 forText:sendingText forBackgroundImage:image];
    stripCustomMessageBox.autoCloseTimer = 8.0;
    stripCustomMessageBox.animation=YES;
    [view addSubview:stripCustomMessageBox];
}

#pragma mark - VehicleControlViewDelegate
-(IBAction)keyButton_onClick:(id)sender
{
    if (!_VehicleStatus)
    {
        BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:error forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
        baseCustomMessageBox.animation = YES;
        baseCustomMessageBox.autoCloseTimer = 1;
        [self.view addSubview:baseCustomMessageBox];
        
    }else if (vehicle.doors.doorStatus ==  ALL_CLOSED_AND_LOCKED && vehicle.doors.trunkStatus != DOOR_CLOSED_AND_LOCKED)
    {
        [self lockView];
        [self closeTipDelegate];
        VehicleControlView *view = (VehicleControlView *)self.view;
        UIImage *image=[UIImage imageNamed:NSLocalizedStringFromTable(@"noticebar_back",Res_Image,@"")];
        stripCustomMessageBox=[[StripCustomMessageBox alloc]initWithOriginY:60 forText:@"请您手动关闭后备箱" forBackgroundImage:image];
        stripCustomMessageBox.animation=YES;
        stripCustomMessageBox.autoCloseTimer = 2;
        [view addSubview:stripCustomMessageBox];
        return;
    }
    else
    {
        VehicleControlView *view = (VehicleControlView *)self.view;
        NSString *sendingText;
        if (view.doorsStatus == StatusOK && view.currentType == CurrentType_Doors) {
            sendingText=NSLocalizedStringFromTable(@"DoorsAllClosed_txt",Res_String,@"");
            UIImage *image=[UIImage imageNamed:NSLocalizedStringFromTable(@"noticebar_back",Res_Image,@"")];
            [stripCustomMessageBox removeFromSuperview];
            stripCustomMessageBox=[[StripCustomMessageBox alloc]initWithOriginY:60 forText:sendingText forBackgroundImage:image];
            stripCustomMessageBox.lbl_text.font = [UIFont systemFontOfSize:11];
            stripCustomMessageBox.animation=YES;
            stripCustomMessageBox.autoCloseTimer = 2;
            [view addSubview:stripCustomMessageBox];
        } else {
            [self sendVehicleCommand];
        }
    }
}

-(IBAction)keyButton_longPressGesture:(id)sender
{
    if (!_VehicleStatus)
    {
        BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:error forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
        baseCustomMessageBox.animation = YES;
        baseCustomMessageBox.autoCloseTimer = 1;
        [self.view addSubview:baseCustomMessageBox];
        
    }else
    {
        [self closeTipDelegate];
        VehicleControlView *view = (VehicleControlView *)self.view;
        NSString *sendingText;
        if (view.windowsStatus == StatusOK && view.currentType == CurrentType_Windows) {
            sendingText = NSLocalizedStringFromTable(@"WindowsAllClosed_txt",Res_String,@"");
            UIImage *image = [UIImage imageNamed:NSLocalizedStringFromTable(@"noticebar_back",Res_Image,@"")];
            stripCustomMessageBox = [[StripCustomMessageBox alloc] initWithOriginY:60 forText:sendingText forBackgroundImage:image];
            stripCustomMessageBox.lbl_text.font = [UIFont systemFontOfSize:11];
            stripCustomMessageBox.animation = YES;
            stripCustomMessageBox.autoCloseTimer = 2;
            [view addSubview:stripCustomMessageBox];
        } else {
            [self sendVehicleCommand];
        }
    }
}

- (void)getCommandStateWithMsgId:(NSString *)MsgId
{
    customActivityIndicatorView.showText = @"指令执行状态获取中";
    [self lockView];
    VehicleControlView *view = (VehicleControlView *)self.view;
    view.customTitleBar.rightButton.userInteractionEnabled = NO;
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

- (void)getCommandStateOfTimerWithMsgId:(NSTimer *)timer
{
    requestIndex++;
    if (!vehicle) {
        vehicle=[[Vehicle alloc] init];
    }
    vehicle.observer=self;
    [vehicle getCommandConditionWithMsgId:[timer userInfo]];
}

#pragma mark - DataModuleDelegate
-(void)didDataModuleNoticeSucess:(BaseDataModule*)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    VehicleControlView *view = (VehicleControlView *)self.view;
    if(businessID == BUSINESS_VEHICLE_GETCONDITION)
    {
        [self unlockViewSubtractCount];
        _VehicleStatus = YES;
        VehicleControlView *view=(VehicleControlView*)self.view;
        if (vehicle.windows.driverWindowStatus|vehicle.windows.copilotWindowStatus|vehicle.windows.rearLeftWindowStatus|vehicle.windows.rearRightWindowStatus|vehicle.windows.sunroofStatus!=0) {
            view.windowsStatus=StatusNotOK;
        }else{
            view.windowsStatus=StatusOK;
        }
        
        if (vehicle.doors.driverDoorStatus|vehicle.doors.copilotDoorStatus|vehicle.doors.realLeftDoorStatus|vehicle.doors.realRightDoorStatus|vehicle.doors.trunkStatus!=0) {
            view.doorsStatus=StatusNotOK;
        }else{
            view.doorsStatus=StatusOK;
        }
    }
    else if(businessID == BUSINESS_VEHICLE_SENDCOMMAND){
        [self unlockViewSubtractCount];
        view.isSuccess = YES;
        stripCustomMessageBox.text=NSLocalizedStringFromTable(@"CommandSent",Res_String,@"");
        stripCustomMessageBox.autoCloseTimer=2;
//        if (view.currentType == CurrentType_Doors && view.doorsStatus == StatusNotOK) {
//            [self getCommandStateWithMsgId:vehicleDoor.msgId];
//        }
//        if (view.currentType == CurrentType_Windows && view.windowsStatus == StatusNotOK) {
//            [self getCommandStateWithMsgId:vehicleWindow.msgId];
//        }
//        if (view.currentType == CurrentType_LightHorn) {
//            [self getCommandStateWithMsgId:vehicle.msgId];
//        }
    }
    else if(businessID == BUSINESS_VEHICLE_GETCOMMAND_CONDITION) {
        
        if (vehicle.executeState != ExecuteState_Wait_Handle) {
            //停止轮询
            [self unlockViewSubtractCount];
            view.customTitleBar.rightButton.userInteractionEnabled = YES;
            
            //停止定时任务
            if (commandRequestTimer != nil) {
                [commandRequestTimer invalidate];
                commandRequestTimer = nil;
            }
            
            NSString *errorText = @"";
            switch (vehicle.executeState) {
                case ExecuteState_Execute_Fail:
                    //执行失败
                    errorText = @"执行失败";
                    break;
                case ExecuteState_Execute_TimeOut:
                    //执行超时
                    errorText = @"执行超时";
                    break;
                default:
                    break;
            }
            
            if (errorText.length > 0) {
                BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:errorText forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
                baseCustomMessageBox.animation = YES;
                baseCustomMessageBox.autoCloseTimer = 1;
                [self.view addSubview:baseCustomMessageBox];
            }
            
            return;
        }
        
        if (requestIndex == 15) {
            //停止锁屏
            [self unlockViewSubtractCount];
            view.customTitleBar.rightButton.userInteractionEnabled = YES;
            
            //停止定时任务
            if (commandRequestTimer != nil) {
                [commandRequestTimer invalidate];
                commandRequestTimer = nil;
            }
        }
        
    }else if (businessID == BUSINESS_GETUSERINFO){
        [self unlockViewSubtractCount];
        view.lbl_vehNo.text = vehicleInfo.vehNo;
    } else if (businessID == BUSINESS_VEHICLE_REMOTESEARCHCAR) {
        [self unlockViewSubtractCount];
        if (vehicle.vehicleCommandStatus.carCammandStatus == Command_CAN_DO) {
            [self sendVehicleCommand];
        } else if (vehicle.vehicleCommandStatus.carCammandStatus == Command_NOT_CAN_DO) {
            BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:vehicle.vehicleCommandStatus.statusDesc forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
            baseCustomMessageBox.animation = YES;
            baseCustomMessageBox.autoCloseTimer = 5;
            [self.view addSubview:baseCustomMessageBox];
        }
    }
}

- (void)didDataModuleNoticeFail:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID forErrorCode:(int)errorCode forErrorMsg:(NSString *)errorMsg
{
    [super didDataModuleNoticeFail:baseDataModule forBusinessType:businessID forErrorCode:errorCode forErrorMsg:errorMsg];
    
    //停止定时任务
    if (commandRequestTimer != nil) {
        [commandRequestTimer invalidate];
        commandRequestTimer = nil;
    }
    
    if (businessID == BUSINESS_VEHICLE_SENDCOMMAND)
    {
        [stripCustomMessageBox removeFromSuperview];
        stripCustomMessageBox = nil;
    }
    else if(businessID == BUSINESS_VEHICLE_GETCONDITION)
    {
        _VehicleStatus = NO;
        error = @"";
        error = [error stringByAppendingString:errorMsg];
    }
}
-(void)closeTipDelegate
{
    [vehicleControlView.tipLable removeFromSuperview];
    [vehicleControlView.closeTipBtn removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unlockViewSubtractCount];
    //停止定时任务
    if (commandRequestTimer != nil) {
        [commandRequestTimer invalidate];
        commandRequestTimer = nil;
    }
}

-(void)dealloc
{
    vehicleInfo.observer = nil;
}
@end
