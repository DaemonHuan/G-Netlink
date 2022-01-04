//
//  AppLoadingViewController.m
//  ZhiJiaAnX
//
//  Created by wei.xu.95190 on 13-8-15.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "AppLoadingViewController.h"
#import "AppLoadingView.h"
#import "ClientVersion.h"

@interface AppLoadingViewController ()
{
    ClientVersion *clientVersion;
}
@end

@implementation AppLoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)loadView
{
    AppLoadingView *appLoadingView= [[AppLoadingView alloc] initWithFrame:[self createViewFrame]];
    self.view = appLoadingView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self lockView];
    [self performSelector:@selector(goToLogin) withObject:nil afterDelay:1];
    
//    clientVersion = [[ClientVersion alloc] init];
//    clientVersion.observer = self;
//    [clientVersion getLatestVersion];
//    
//    [self lockView];

}


/*
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self goToLogin];
        [self lockView];
    }else if(buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:clientVersion.url]];
        [self lockView];
        [self goToLogin];
    }
}

 -(void)didDataModuleNoticeSucess:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID
 {
     [super didDataModuleNoticeSucess:baseDataModule forBusinessType:businessID];
     
     if(businessID == BUSINESS_OTHER_CLIENTVERSION)
     {
         if([clientVersion isNeedUpdate] && clientVersion.autoUpdateFlag)
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"user_check_password_update", Res_String, @"") delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认升级", nil];
             [alertView show];
         }
         else
         {
             [self lockView];
             [self performSelector:@selector(goToLogin) withObject:nil afterDelay:2];
         }
     }
 }
 
- (void)didDataModuleNoticeFail:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID forErrorCode:(int)errorCode forErrorMsg:(NSString *)errorMsg
{
    
    [super didDataModuleNoticeFail:baseDataModule forBusinessType:businessID forErrorCode:errorCode forErrorMsg:errorMsg];
    
    [self unlockViewSubtractCount];
    if(self.lockViewCount == 0)
    {
        [self goToLogin];
        return;
    }
}
*/

- (void)goToLogin
{
    Message *message = [[Message alloc] init];
    message.receiveObjectID = VIEWCONTROLLER_LOGIN;
    message.commandID = MC_CREATE_GRADUALLYINTO_VIEWCONTROLLER;
    [self sendMessage:message];
}

-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_LOADING;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
