//
//  UserMoreViewController.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserMoreViewController.h"
#import "UserMoreView.h"
//#import "ClientVersion.h"
@interface UserMoreViewController ()
{
    UserMoreView *_userMoreView;
}
@end

@implementation UserMoreViewController

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
    [self setExtraCellLineHidden:_userMoreView.tableView];
	// Do any additional setup after loading the view.
}
-(void)loadView
{
    _userMoreView=[[UserMoreView alloc] initWithFrame:[self createViewFrame] tableViewStyle:UITableViewStylePlain];
    _userMoreView.delegate=self;
    _userMoreView.customTitleBar.buttonEventObserver = self;
    self.view=_userMoreView;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_USERMORE;
}
-(void)leftButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_USERMANAGEMENT;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)rightButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_HALL;
    msg.commandID=MC_CREATE_GRADUALLYINTO_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)sendMessageDelegate:(NSIndexPath *)indexPath{
    Message *msg=[[Message alloc] init];
    if (indexPath.row==0)
    {
        msg.receiveObjectID=VIEWCONTROLLER_USERHELP;
    }
    else if (indexPath.row==1)
    {
        msg.receiveObjectID=VIEWCONTROLLER_USERFEEDBACK;
    }
//    else if(indexPath.row==2)
//    {
//       给软件评分
//         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", @"itms-apps://itunes.apple.com/cn/app/guang-dian-bi-zhi/id511587202?mt=8"]]];
        //     检查更新
        
//    }
    else if(indexPath.row==2)
    {
        //       欢迎页
        msg.sendObjectID = self.viewControllerId;
        msg.receiveObjectID=VIEWCONTROLLER_WELCOME;
    }
    else if(indexPath.row==3)
    {
        msg.receiveObjectID=VIEWCONTROLLER_USERABOUT;
    }

    msg.commandID=MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
