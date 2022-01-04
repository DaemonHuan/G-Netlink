//
//  UserManagementViewController.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-28.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserManagementViewController.h"
#import "UserManagementView.h"
#import "Message.h"
//#import "ClientVersion.h"
#import "BaseCustomMessageBox.h"
#import "GNLUserInfo.h"

@interface UserManagementViewController ()
{
    UIAlertView * _alertView;
    UIAlertView * _updataAlertView;
}
@end

@implementation UserManagementViewController

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
    frame.size.height=frame.size.height-[UIImage imageNamed:NSLocalizedStringFromTable(@"tab_bar_background",Res_Image,@"")].size.height;
    UserManagementView *userManagementView=[[UserManagementView alloc] initWithFrame:frame];
    userManagementView.customTitleBar.buttonEventObserver = self;
    userManagementView.delegate=self;
    self.view=userManagementView;
}
-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_USERMANAGEMENT;
}
-(void)leftButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_HALL;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)rightButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_HALL;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    user.observer=self;
	// Do any additional setup after loading the view.
}
-(void)sendMessageDelegate:(NSIndexPath *)indexPath{
    Message *msg=[[Message alloc] init];
    switch (indexPath.row) {
        case 0:
        {
          msg.receiveObjectID=VIEWCONTROLLER_USERINFO;
        }
            break;
        case 1:
        {
            msg.receiveObjectID=VIEWCONTROLLER_PHONENUMBER;
        }
            break;
        case 2:
        {
            //        修改密码url
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Find_Password]];
        }
            break;
//        case 3:
//        {
//            //     检查更新的方法
//            
//             clientVersion = [[ClientVersion alloc] init];
//            clientVersion.observer = self;
//            [clientVersion getLatestVersion];
//            [self lockView];
//        }
//            break;
        case 3:
        {
            msg.receiveObjectID=VIEWCONTROLLER_USERMORE;
        }
            break;
        default:
            break;
    }
  msg.commandID=MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
/*
-(void)didDataModuleNoticeSucess:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    [super didDataModuleNoticeSucess:baseDataModule forBusinessType:businessID];
    
    
    if(businessID == BUSINESS_OTHER_CLIENTVERSION)
    {
        if([clientVersion isNeedUpdate])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"user_check_password_update", Res_String, @"") delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认升级", nil];
            alertView.tag = 1002;
            [alertView show];
        }
        else
        {
            BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:NSLocalizedStringFromTable(@"user_check_password_on_update", Res_String, @"")  forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
            baseCustomMessageBox.animation = YES;
            baseCustomMessageBox.autoCloseTimer = 1;
            [self.view addSubview:baseCustomMessageBox];
        }
    }
 
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==1002 & buttonIndex == 1)
    {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:clientVersion.url]];
    }
}
  */

-(void)userlogout
{
    [GNLUserInfo setGoOut:NO];
    [user logout];
    
    //
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    
//    Message *message = [[Message alloc] init];
//    message.receiveObjectID = NODE_ROOT;
//    message.sendObjectID = _viewControllerId;
//    message.commandID = MC_CHILD_NODE_CLEAR_VALUE;
//    [self sendMessage:message];
//    
//    message = [[Message alloc] init];
//    message.receiveObjectID = VIEWCONTROLLER_LOGIN;
//    message.sendObjectID = _viewControllerId;
//    message.commandID = MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
//    [self sendMessage:message];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
