//
//  NotificationDetailedViewController.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-5-8.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "NotificationDetailedViewController.h"
#import "NotificationDetailedView.h"
#import "News.h"
@interface NotificationDetailedViewController ()
{
    News * _news;
}
@end

@implementation NotificationDetailedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)receiveMessage:(Message *)message{
    _news=message.externData;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_news updateReadStatus];
    _news.observer = self;
	// Do any additional setup after loading the view.
}
-(void)loadView
{
    NotificationDetailedView * notificationDetailView=[[NotificationDetailedView alloc]initWithFrame:[self createViewFrame]];
     notificationDetailView.customTitleBar.buttonEventObserver = self;
    notificationDetailView.titleLabel.text=_news.title;
    notificationDetailView.textView.text=_news.detailContent;
    notificationDetailView.dateLabel.text=_news.source;
    notificationDetailView.nameLabel.text=_news.addTime;
    self.view=notificationDetailView;
}
-(void)didDataModuleNoticeSucess:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    [super didDataModuleNoticeSucess:baseDataModule forBusinessType:businessID];
    if (businessID == BUSINESS_NOTIFICATIONNEWS_READ) {
        NSLog(@"readStatus  改变");
        NSLog(@"%d",_news.isRead);
    }
}
-(void)didDataModuleNoticeFail:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID forErrorCode:(int)errorCode forErrorMsg:(NSString *)errorMsg
{
    [super didDataModuleNoticeFail:baseDataModule forBusinessType:businessID forErrorCode:errorCode forErrorMsg:errorMsg];
    
}
-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_NOTIFICATIONNEWS_DETAIL;
}
-(void)leftButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_NOTIFICATIONNEWS;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}

-(void)rightButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_HALL;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
