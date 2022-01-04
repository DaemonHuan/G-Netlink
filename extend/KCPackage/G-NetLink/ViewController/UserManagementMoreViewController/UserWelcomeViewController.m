//
//  UserWelcomeViewController.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-5-5.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserWelcomeViewController.h"
#import "UserWelcomeView.h"
@interface UserWelcomeViewController ()
{
    enum NodeAndViewControllerID holdViewControllerId;
}
@end

@implementation UserWelcomeViewController

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
-(void)receiveMessage:(Message *)message
{
    [super receiveMessage:message];
    holdViewControllerId = message.sendObjectID;
}
-(void)loadView
{
    UserWelcomeView *userWelcome=[[UserWelcomeView alloc] initWithFrame:[self createViewFrame]];
    userWelcome.delegate=self;
    userWelcome.customTitleBar.buttonEventObserver = self;
    self.view=userWelcome;
}
-(void)userWelcomeViewDelegateGoHome{
    Message *msg = [[Message alloc] init];
    if (holdViewControllerId == VIEWCONTROLLER_USERMORE)
    {
        msg.receiveObjectID = VIEWCONTROLLER_USERMORE;
    }else
    {
        msg.receiveObjectID = VIEWCONTROLLER_LOADING;
    }
    msg.commandID = MC_CREATE_NORML_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_WELCOME;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
