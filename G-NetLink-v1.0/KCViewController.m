//
//  KCViewController.m
//  gnl
//
//  Created by jk on 1/4/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "KCViewController.h"
#import "JPushNotification.h"

@interface KCViewController ()

@end

@implementation KCViewController

@synthesize username, password;
@synthesize delegate;

- (void)viewDidLoad {
//    [super viewDidLoad];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        user.observer = self;
//        [user login:username withPassword:password];
//    });
}

- (void) douserlogin {
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        user.observer = self;
        [user login:username withPassword:password];
    });
}

- (void) didDataModuleNoticeFail:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID forErrorCode:(int)errorCode forErrorMsg:(NSString *)errorMsg {
    if (errorCode == 0) {
        [delegate doKCLoginActions: 0];
    }
    else if (errorCode == 1) {
        [delegate doKCLoginActions: -1];
    }
    else [delegate doKCLoginActions: 0];
}

- (void) didDataModuleNoticeSucess:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID {
    [super didDataModuleNoticeSucess:baseDataModule forBusinessType:businessID];
    if(businessID == BUSINESS_LOGIN)
    {
        [delegate doKCLoginActions: 1];
        
        //设置推送的对象为当前用户
        [((JPushNotification*)[JPushNotification sharePushNotification]) registerUserTags:nil andAlias:user.mobileNumber callbackSelector:nil target:nil];
        
        Message *msg=[[Message alloc] init];
        msg.receiveObjectID=VIEWCONTROLLER_HALL;
        msg.commandID=MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
        [self sendMessage:msg];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
