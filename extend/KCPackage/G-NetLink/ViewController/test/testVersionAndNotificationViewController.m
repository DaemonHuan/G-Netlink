//
//  testVersionAndNotificationViewController.m
//  G-NetLink
//
//  Created by jayden on 14-4-22.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "testVersionAndNotificationViewController.h"
#import "News.h"

@interface testVersionAndNotificationViewController ()

@end

@implementation testVersionAndNotificationViewController

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
    clientVersion=[[ClientVersion alloc] init];
    notificationNews=[[NotificationNews alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_back_click:(id)sender
{
    Message *message = [[Message alloc] init];
    message.sendObjectID = _viewControllerId;
    message.commandID = MC_CREATE_PUSHFROMRIGHT_VIEWCONTROLLER;
    message.receiveObjectID=VIEWCONTROLLER_TEST1;
    [self sendMessage:message];
}

- (IBAction)btn_getNewVersion_click:(id)sender
{
    [clientVersion getLatestVersion];
}

- (IBAction)btn_getCount_click:(id)sender
{
    [notificationNews getNewsCount];
}

- (IBAction)btn_getNotifications_click:(id)sender
{
    [notificationNews getNews:1 forpagesize:20];
}

- (IBAction)btn_setNotRead_click:(id)sender
{
    [(News *)notificationNews.news[0] updateReadStatus];
}

- (IBAction)btn_deleteNot_click:(id)sender
{
    if ((NSNull *)notificationNews.news!=[NSNull null]) {
        [notificationNews deleteNews: [notificationNews.news objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]]];
    }
}

-(void)didDataModuleNoticeSucess:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    if (businessID==BUSINESS_NOTIFICATIONNEWS_QUERY) {
    }
}
@end
