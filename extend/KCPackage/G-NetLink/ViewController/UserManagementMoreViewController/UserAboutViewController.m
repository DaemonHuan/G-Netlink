//
//  UserAboutViewController.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserAboutViewController.h"
#import "UserAboutView.h"
#import "ClientVersion.h"
@interface UserAboutViewController ()
{
    ClientVersion * _version;
    UserAboutView * _userAboutView;
}
@end

@implementation UserAboutViewController

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
     [_userAboutView setClientVersion:CLIENT_VERSION];

	// Do any additional setup after loading the view.
}
-(void)loadView
{
    _userAboutView=[[UserAboutView alloc] initWithFrame:[self createViewFrame]];
    _userAboutView.customTitleBar.buttonEventObserver = self;
    self.view=_userAboutView;
}

-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_USERABOUT;
}
-(void)leftButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_USERMORE;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)rightButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_HALL;
    msg.commandID=MC_CREATE_GRADUALLYINTO_VIEWCONTROLLER;
    [self sendMessage:msg];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
