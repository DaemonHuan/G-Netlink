//
//  HallViewController.m
//  G-NetLink
//
//  Created by jayden on 14-4-24.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "HallViewController.h"
#import "HallView.h"
#import "Message.h"
#import "User.h"
#import "NotificationNews.h"
#import "VehicleInfo.h"
#import "BaseCustomMessageBox.h"

@interface HallViewController ()
{
    HallView * hallView;
    NotificationNews * _notificationNews;
    VehicleInfo *vehicleInfo;
}
@end

@implementation HallViewController

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
    hallView = [[HallView alloc] initWithFrame:frame];
    hallView.customTitleBar.buttonEventObserver = self;
    hallView.delegate = self;
    self.view = hallView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    Message *message = [[Message alloc] init];
    message.commandID = MC_TABBAR_0;
    message.receiveObjectID = NODE_ROOT;
    [self sendMessage:message];
    
    [PushNotification sharePushNotification].observer=self;
    _notificationNews=[[NotificationNews alloc]init];
    _notificationNews.observer=self;
    [_notificationNews getNewsCount];
    [self lockView];
    user.observer=self;
    
    vehicleInfo = [self.parentNode getNodeOfSaveDataAtKey:@"vehicleInfo"];
    if(vehicleInfo == nil )
    {
        vehicleInfo = [[VehicleInfo alloc] init];
        vehicleInfo.observer = self;
        [vehicleInfo getInfo];
        [self lockView];
        [self.parentNode addNodeOfSaveData:@"vehicleInfo" forValue:vehicleInfo];
    }
    else if (vehicleInfo.vehNo == nil || (NSNull *)vehicleInfo.vehNo == [NSNull null]|| vehicleInfo.vehNo.length == 0)
    {
        vehicleInfo.observer = self;
        [vehicleInfo getInfo];
        [self lockView];
        [self.parentNode addNodeOfSaveData:@"vehicleInfo" forValue:vehicleInfo];
    }
    else
        hallView.customTitleBar.titleText = vehicleInfo.vehNo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_HALL;
}
-(void)rightButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_NOTIFICATIONNEWS;
    msg.commandID=MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
//车况查询
-(void)inquiryBtn_onClick_delegate{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_VEHICLECONDITION;
    msg.commandID=MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)locationBtn_onClick_delegate{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_VEHICLELOCATION;
    msg.commandID=MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)helpBtn_onClick_delegate{
    [self performSelector:@selector(callCenter:) withObject:Help_Phone_Num afterDelay:1];
}
-(void)navigationBtn_onClick_delegate{
    [self performSelector:@selector(callCenter:) withObject:Navigation_Phone_Num afterDelay:1];
}

-(void)callCenter:(NSString *)phoneNumber
{
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",phoneNumber];
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:num];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

-(void)didDataModuleNoticeSucess:(BaseDataModule*)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    [super didDataModuleNoticeSucess:baseDataModule forBusinessType:businessID];
    
    if (businessID== BUSINESS_NOTIFICATIONNEWS_COUNT_QUERY) {
        int btn_num =_notificationNews.unreadcount;
//        btn_num=0;
        if (btn_num==0) {
            hallView.nav_right_btn_number_label.alpha=0;
            hallView.nav_right_btn_number.alpha=0;
            return;
        }else{
            if(btn_num<9){
                hallView.nav_right_btn_number_label.text=[NSString stringWithFormat:@"%d",btn_num];
                hallView.nav_right_btn_number_label.textAlignment=NSTextAlignmentCenter;
                hallView.nav_right_btn_number_label.alpha=1;
                hallView.nav_right_btn_number.alpha=1;
            }
            else
//                hallView.nav_right_btn_number_label.text=@"9+";
            hallView.nav_right_btn_number_label.text=[NSString stringWithFormat:@"%d",btn_num];
            hallView.nav_right_btn_number_label.font=[UIFont systemFontOfSize:13];
            hallView.nav_right_btn_number_label.textAlignment=NSTextAlignmentCenter;
            hallView.nav_right_btn_number_label.alpha=1;
            hallView.nav_right_btn_number.alpha=1;
        }
        
    }
    else if(businessID == BUSINESS_GETUSERINFO)
    {
        hallView.customTitleBar.titleText = vehicleInfo.vehNo;
        
        if (vehicleInfo.vehNo != nil && vehicleInfo.vehNo.length > 0) {
            BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"WelcomeWords",Res_String,@""),vehicleInfo.vehNo] forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
            baseCustomMessageBox.animation = YES;
            baseCustomMessageBox.autoCloseTimer = 3;
            [self.view addSubview:baseCustomMessageBox];
        }
    }
}
-(void)dealloc
{
    _notificationNews.observer = nil;
    vehicleInfo.observer = nil;
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

@end
