//
//  BaseViewController.h
//  MessageFrame
//
//  Created by 95190 on 13-4-2.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeAndViewControllerID.h"
#import "Message.h"
#import "BaseNode.h"
#import "DataModuleDelegate.h"
#import "ResDefine.h"
#import "CustomActivityIndicatorView.h"
#import "TextFiledReturnEditingDelegate.h"
#import "CustomTitleBar_ButtonDelegate.h"
#import "User.h"
#import "JPushNotification.h"


@interface BaseViewController : UIViewController<DataModuleDelegate,TextFiledReturnEditingDelegate,CustomTitleBar_ButtonDelegate,PushNotificationDelegate>
{
@protected
    enum NodeAndViewControllerID _viewControllerId;
    CustomActivityIndicatorView *customActivityIndicatorView;
    User *user;
    int _lockViewCount;

}
@property(nonatomic,readonly)enum NodeAndViewControllerID viewControllerId;
@property(nonatomic,assign)BaseNode *parentNode;
@property(nonatomic,readonly)int lockViewCount;

-(void)destroyDataBeforeDealloc;
-(void)sendMessage:(Message*)message;
-(void)receiveMessage:(Message*)message;
-(void)lockView;
-(BOOL)lockViewAddCount;
-(BOOL)unlockViewSubtractCount;
-(void)settingViewControllerId;
-(CGRect)createViewFrame;
@end
