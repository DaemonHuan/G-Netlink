//
//  BaseViewController.m
//  MessageFrame
//
//  Created by 95190 on 13-4-2.
//  Copyright (c) 2013年 95190. All rights reserved.
//
#import "BaseUIView.h"
#import "TitleBarView.h"
#import "BaseViewController.h"
#import "ViewControllerPathManager.h"
#import "BaseCustomMessageBox.h"
#import "VehicleOperateHistoryRecord.h"
#import "User.h"
#import "News.h"

//@interface NotificationEventObject : BaseViewController<UIAlertViewDelegate>
//
//@property(nonatomic,copy)void (^confirmButtonOnClick)(void);
//@property(nonatomic,copy)void (^cancelButtonOnClick)(void);
//
//@end
//
//@implementation NotificationEventObject
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        self.cancelButtonOnClick();
//    } else if (buttonIndex == 1) {
//        self.confirmButtonOnClick();
//    }
//}
//
//@end


@interface BaseViewController ()
{
    News *news;
    enum MessageType messageType;
    NSString *msgId;
    BOOL isForgroundNotification;
    UIAlertView *alertViewNotification;
//    NotificationEventObject *notificationEventObject;
}
-(void)unlockView;
-(void)createUIActivityIndicatorView;
@end

@implementation BaseViewController
@synthesize viewControllerId = _viewControllerId;
@synthesize lockViewCount = _lockViewCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)sendMessage:(Message*)message
{
    if(self.parentNode == nil)
        return;
    if(message.receiveObjectID == VIEWCONTROLLER_RETURN)
    {
        NSNumber *ID = [ViewControllerPathManager getPreviousViewControllerIDWithDelete];
        if(ID!=nil)
            message.receiveObjectID = [ID intValue];
    }
    [self.parentNode receiveMessage:message];
}

-(void)receiveMessage:(Message*)message
{
    
}

-(void)didDataModuleNoticeSucess:(BaseDataModule*)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    [self unlockViewSubtractCount];
    
//    if (isForgroundNotification) {
//        if (alertViewNotification == nil) {
//            notificationEventObject = [[NotificationEventObject alloc] init];
//            alertViewNotification = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您收到一条通知" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
//            alertViewNotification.delegate = notificationEventObject;
//            [alertViewNotification show];
//        }
//    } else {
        if(news == baseDataModule && businessID == BUSINESS_NOTIFICATIONNEWS_DETAIL)
        {
            Message *message = [[Message alloc] init];
            message.receiveObjectID = VIEWCONTROLLER_NOTIFICATIONNEWS_DETAIL;
            message.commandID = MC_CREATE_PUSHFROMLEFT_VIEWCONTROLLER;
            message.externData = news;
            [self sendMessage:message];
        }
//    }
}

-(void)didDataModuleNoticeFail:(BaseDataModule*)baseDataModule forBusinessType:(enum BusinessType)businessID forErrorCode:(int)errorCode forErrorMsg:(NSString*)errorMsg
{
    [self unlockViewSubtractCount];
    NSLog(@"%d",businessID);
    NSString *error = @""; //= @"failMessage:";
    if(errorMsg==nil)
        return;
    error = [error stringByAppendingString:errorMsg];
    
    BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:error forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
    baseCustomMessageBox.animation = YES;
    baseCustomMessageBox.autoCloseTimer = 1;
    
//    CustomMessageBox *customMessageBox = [[CustomMessageBox alloc] initWithTitle:NSLocalizedStringFromTable(@"Message",Res_String,@"") forText:error forLeftButtonText:nil forRightButtonText:nil forIconImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"messagebox_title_icon",Res_Image,@"")]];
//    customMessageBox.lbl_text.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:baseCustomMessageBox];
    NSLog(@"%@",error);
    
}
-(void)createUIActivityIndicatorView
{
    customActivityIndicatorView = [[CustomActivityIndicatorView alloc]initWithFrame:self.view.bounds];
    customActivityIndicatorView.alpha = 0.9;
    [self.view addSubview:customActivityIndicatorView];
}
-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_NONE;
}
-(void)lockView
{
    _lockViewCount++;
    if(![customActivityIndicatorView isAnimating])
    {
        [self.view bringSubviewToFront:customActivityIndicatorView];
        [customActivityIndicatorView startAnimating];
    }
}
-(BOOL)lockViewAddCount
{
    if([customActivityIndicatorView isAnimating])
    {
        _lockViewCount++;
        return YES;
    }
    return NO;
}
-(void)unlockView
{
    customActivityIndicatorView.showText = nil;
    [customActivityIndicatorView stopAnimating];
}
-(BOOL)unlockViewSubtractCount
{
    if(![customActivityIndicatorView isAnimating])
        return NO;
    
    _lockViewCount--;
    if(_lockViewCount<0)
        _lockViewCount = 0;
    if(_lockViewCount == 0)
        [self unlockView];
    return YES;
}
-(CGRect)createViewFrame
{
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = [UIScreen mainScreen].applicationFrame.size.width;
    frame.size.height = [UIScreen mainScreen].applicationFrame.size.height;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7)
        frame.origin.y = [UIScreen mainScreen].applicationFrame.origin.y;
    
    if([UIApplication sharedApplication].statusBarFrame.size.height>20)
        frame.origin.y = 20;
    
    return frame;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    user = [User shareUser];
	// Do any additional setup after loading the view.
    _lockViewCount = 0;
    [self createUIActivityIndicatorView];
    [self settingViewControllerId];
    [ViewControllerPathManager addViewControllerID:[NSNumber numberWithInt:_viewControllerId]];
    
    if(_viewControllerId != VIEWCONTROLLER_LOGIN)
        [JPushNotification sharePushNotification].observer = self;
  }
-(IBAction)textFiledReturnEditing:(id)sender
{
    [sender resignFirstResponder];
}
-(void)destroyDataBeforeDealloc
{
    [JPushNotification sharePushNotification].observer = nil;
    news.observer = nil;
}
#pragma mark --- CustomTitleBar_ButtonDelegate
-(IBAction)leftButton_onClick:(id)sender
{
    Message *message = [[Message alloc] init];
    //message.receiveObjectID = VIEWCONTROLLER_RETURN;
    message.commandID = MC_CREATE_PUSHFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:message];
}
-(IBAction)rightButton_onClick:(id)sender
{
    Message *message = [[Message alloc] init];
    //message.receiveObjectID = VIEWCONTROLLER_SYSTEM_HALL;
    message.commandID = MC_CREATE_PUSHFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:message];
}
#pragma mark - PushNotificationDelegate
-(BOOL)didReceivePushNotification:(NSDictionary *)userInfo
{
//    if(_viewControllerId == VIEWCONTROLLER_NONE || _viewControllerId == VIEWCONTROLLER_LOGIN || _viewControllerId == VIEWCONTROLLER_LOADING)
//        return NO;
//    
//    isForgroundNotification = NO;
//    
//    msgId = [userInfo objectForKey:@"msgid"];
//    messageType = [[userInfo objectForKey:@"messagetype"] integerValue];
//    
//    if (messageType == MessageType_Normal) {
//        if(news == nil)
//            news = [[News alloc] init];
//        news.observer = self;
//        [news getDetailInfo:msgId];
//    } else if (messageType == MessageType_Control) {
//        Message *msg=[[Message alloc] init];
//        msg.receiveObjectID=VIEWCONTROLLER_VEHICLECONTROLHISTORY;
//        msg.commandID=MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
//        [self sendMessage:msg];
//    }
//    
    return YES;
}

//-(BOOL)didReceiveForegroundPushNotification:(NSDictionary *)userInfo
//{
//    if(_viewControllerId == VIEWCONTROLLER_NONE || _viewControllerId == VIEWCONTROLLER_LOGIN || _viewControllerId == VIEWCONTROLLER_LOADING)
//        return NO;
//    
//    isForgroundNotification = YES;
//    
//    msgId = [userInfo objectForKey:@"msgid"];
//    messageType = [[userInfo objectForKey:@"messagetype"] integerValue];
//    
//    if (messageType == MessageType_Normal) {
//        if(news == nil)
//            news = [[News alloc] init];
//        news.observer = self;
//        [news getDetailInfo:msgId];
//    } else if (messageType == MessageType_Control) {
//        if (alertViewNotification == nil) {
//            notificationEventObject = [[NotificationEventObject alloc] init];
//            alertViewNotification = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您收到一条通知" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
//            alertViewNotification.delegate = notificationEventObject;
//            [alertViewNotification show];
//        }
//    }
//    
//    __block typeof(self) bself = self;
//    __block typeof(messageType) type = messageType;
//    __block typeof(news) notificationNews = news;
//    notificationEventObject.confirmButtonOnClick = ^{
//        if (type == MessageType_Normal) {
//            alertViewNotification = nil;
//            Message *message = [[Message alloc] init];
//            message.receiveObjectID = VIEWCONTROLLER_NOTIFICATIONNEWS_DETAIL;
//            message.commandID = MC_CREATE_PUSHFROMLEFT_VIEWCONTROLLER;
//            message.externData = notificationNews;
//            [bself sendMessage:message];
//        } else if(type == MessageType_Control){
//            alertViewNotification = nil;
//            Message *msg=[[Message alloc] init];
//            msg.receiveObjectID=VIEWCONTROLLER_VEHICLECONTROLHISTORY;
//            msg.commandID=MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
//            [bself sendMessage:msg];
//        }
//    };
//    
//    notificationEventObject.cancelButtonOnClick = ^{
//        alertViewNotification = nil;
//    };
//    
//    return YES;
//}

-(void)dealloc
{
    if([self.view isKindOfClass:[TitleBarView class]])
        ((TitleBarView*)self.view).customTitleBar.buttonEventObserver = nil;
    
    if(news != nil)
        news.observer = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
