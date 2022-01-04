//
//  VehicleControlHistoryDetailViewController.m
//  G-NetLink
//
//  Created by jayden on 14-4-25.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleControlHistoryDetailViewController.h"
#import "VehicleOperateHistoryRecord.h"
#import "VehicleInfo.h"
@interface VehicleControlHistoryDetailViewController ()
@end

@implementation VehicleControlHistoryDetailViewController
{
    VehicleInfo * vehicleInfo;
    VehicleOperateHistoryRecord * record;
}
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
    VehicleControlHistoryDetailView *vehicleControlHistoryDetailView=[[VehicleControlHistoryDetailView alloc] initWithFrame:[self createViewFrame]];
    vehicleControlHistoryDetailView.customTitleBar.buttonEventObserver=self;
    self.view=vehicleControlHistoryDetailView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    vehicleInfo = [self.parentNode getNodeOfSaveDataAtKey:@"vehicleInfo"];
    if(vehicleInfo == nil )
    {
        vehicleInfo = [[VehicleInfo alloc] init];
        vehicleInfo.observer = self;
        [vehicleInfo getInfo];
        [self.parentNode addNodeOfSaveData:@"vehicleInfo" forValue:vehicleInfo];
    }else
    {
        VehicleControlHistoryDetailView *view=(VehicleControlHistoryDetailView *)self.view;
        view.title = [self translationForChinese:record.cmdType];
        view.content = [NSString stringWithFormat:@"为您的爱车进行了%@，\n%@",[self translationForChinese:record.cmdType],record.executeDesc];
        view.status=record.executeState;
        view.time=record.sendTime;
    }
}

-(void)didDataModuleNoticeSucess:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    [super didDataModuleNoticeSucess:baseDataModule forBusinessType:businessID];
    if (businessID == BUSINESS_GETUSERINFO)
    {
        VehicleControlHistoryDetailView *view=(VehicleControlHistoryDetailView *)self.view;
        view.title = [self translationForChinese:record.cmdType];
        view.content = [NSString stringWithFormat:@"为您的爱车进行了%@，\n%@",[self translationForChinese:record.cmdType],record.executeDesc];
        view.status=record.executeState;
        view.time=record.sendTime;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)settingViewControllerId
{
    _viewControllerId=VIEWCONTROLLER_VEHICLECONTROLHISTORYDETAIL;
}

-(void)receiveMessage:(Message *)message
{
    [super receiveMessage:message];
//    VehicleControlHistoryDetailView *view=(VehicleControlHistoryDetailView *)self.view;
    record= (VehicleOperateHistoryRecord*)message.externData;
//    view.title = [self translationForChinese:record.cmdType];
//    view.content = [NSString stringWithFormat:@"车牌号为%@的车辆进行了%@",@"",[self translationForChinese:record.cmdType]];
////    vehicleInfo.vehNo
////    view.title=record.cmdType;
////    view.content=record.cmdType;
//    view.status=[record.sendState intValue];
//    view.time=record.sendTime;
}
-(NSString*)translationForChinese:(NSString * )english
{
    NSString * chinese;
    if ([english isEqualToString:@"SEEK-CAR"])
    {
        chinese = @"闪灯鸣笛操作";
    }
    else if ([english isEqualToString:@"CLOSE-DOOR"])
    {
       chinese = @"落锁车门操作";
    }
    else if ([english isEqualToString:@"CLOSE-WINDOW"])
    {
        chinese = @"关闭天窗/车窗操作";
    }
    return chinese;
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
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
@end
