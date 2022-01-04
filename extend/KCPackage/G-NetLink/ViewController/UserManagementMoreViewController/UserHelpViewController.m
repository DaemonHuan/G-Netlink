//
//  UserHelpViewController.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserHelpViewController.h"
#import "UserHelpView.h"
@interface UserHelpViewController ()

@end

@implementation UserHelpViewController

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
-(void)loadView
{
    UserHelpView *userHelpView=[[UserHelpView alloc] initWithFrame:[self createViewFrame]];
    userHelpView.customTitleBar.buttonEventObserver = self;
    self.view=userHelpView;
}
-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_USERHELP;
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
