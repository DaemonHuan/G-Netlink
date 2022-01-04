//
//  UserPhoneModificationViewController.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserPhoneModificationViewController.h"
#import "UserPhoneModificationView.h"
#import "User.h"
#import "UserInfo.h"
@interface UserPhoneModificationViewController ()

@end

@implementation UserPhoneModificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadView{
    UserPhoneModificationView *userPhoneModificationView=[[UserPhoneModificationView alloc] initWithFrame:[self createViewFrame]];
    userPhoneModificationView.delegate=self;
    userPhoneModificationView.customTitleBar.buttonEventObserver = self;
    NSString * oldText =NSLocalizedStringFromTable(@"phone_modification_old_label", Res_String, @"");
     userPhoneModificationView.old_phoneNumber_label.text=[NSString stringWithFormat:@"%@%@", oldText, user.mobileNumber];
    self.view=userPhoneModificationView;

}
-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_UPDATEPHONE;
}
-(void)leftButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_USERINFO;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)rightButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_HALL;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)updateMobilePhones:(NSString *)string{
    UserInfo * userInfo=user.userInfo;
    [userInfo updateMobilePhone:string];    
}

@end
