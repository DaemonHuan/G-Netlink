//
//  testLoginViewController.m
//  G-NetLink
//
//  Created by jayden on 14-4-14.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "testUserViewController.h"

@interface testUserViewController ()

@end

@implementation testUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewControllerId = VIEWCONTROLLER_TEST1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_login_click:(id)sender
{
//    [user login:MOBILE_NUMBER withPassword:PASSWORD];
}

- (IBAction)btn_logout_click:(id)sender
{
    [user logout];
}

- (IBAction)btn_commit_click:(id)sender
{
    [user commitFeed:@"test" withContract:@"18610901432"];
}

- (IBAction)btn_getUserinfo_click:(id)sender
{
    [user.userInfo getInfo];
}

- (IBAction)btn_updatePhone_click:(id)sender
{
     [user.userInfo updateMobilePhone:@"18610901433"];
}

- (IBAction)btn_gotoVehicle_click:(id)sender
{
    Message *message = [[Message alloc] init];
    message.sendObjectID = _viewControllerId;
    message.commandID = MC_CREATE_PUSHFROMRIGHT_VIEWCONTROLLER;
    message.receiveObjectID=VIEWCONTROLLER_TEST2;
    [self sendMessage:message];
}

- (IBAction)btn_gotoVersionAndNot_click:(id)sender
{
    Message *message = [[Message alloc] init];
    message.sendObjectID = _viewControllerId;
    message.commandID = MC_CREATE_PUSHFROMRIGHT_VIEWCONTROLLER;
    message.receiveObjectID=VIEWCONTROLLER_TEST3;
    [self sendMessage:message];
}
@end
