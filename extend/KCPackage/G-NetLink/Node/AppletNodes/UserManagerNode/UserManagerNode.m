//
//  UserManagerNode.m
//  G-NetLink
//
//  Created by jayden on 14-4-23.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserManagerNode.h"
#import "UserInfoNode.h"
#import "UserManagementViewController.h"
#import "UserInfoViewController.h"
#import "UserMoreViewController.h"
#import "UserPhoneModificationViewController.h"
#import "UserAboutViewController.h"
#import "UserHelpViewController.h"
#import "UserWelcomeViewController.h"
#import "UserFeedbackViewController.h"
#import "AppLoadingViewController.h"
#import "PhoneNumberViewController.h"
@implementation UserManagerNode
-(id)init
{
    if(self = [super init]){
        _nodeId = NODE_USERMANAGER;
        _workRange.location = NODE_USERMANAGER;
    }
    return self;
}
-(BOOL)createChildNode
{
    UserInfoNode *userInfoNode = [[UserInfoNode alloc] init];
    userInfoNode.rootViewController = self.rootViewController;
    userInfoNode.parentNode = self;
    [userInfoNode createChildNode];
//    [_childNode setObject:userInfoNode forKey:[NSString stringWithFormat:@"%d",userInfoNode.nodeId]];
    _childNode=[NSMutableDictionary dictionaryWithObjects:@[userInfoNode] forKeys:@[[NSString stringWithFormat:@"%d",userInfoNode.nodeId]]];
    return YES;
}

-(BOOL)receiveMessage:(Message *)message
{
    if(![super receiveMessage:message])
        return NO;
    BaseViewController *viewcontroller;
    if (message.receiveObjectID==VIEWCONTROLLER_USERMANAGEMENT)
    {
        viewcontroller=[[UserManagementViewController alloc] init];
    }
    else if (message.receiveObjectID==VIEWCONTROLLER_USERINFO)
    {
        viewcontroller=[[UserInfoViewController alloc] init];
    }
    else if(message.receiveObjectID==VIEWCONTROLLER_USERMORE)
    {
               viewcontroller=[[UserMoreViewController alloc] init];
    }
    else if(message.receiveObjectID==VIEWCONTROLLER_USERABOUT)
    {
               viewcontroller=[[UserAboutViewController alloc] init];
    }
    else if(message.receiveObjectID==VIEWCONTROLLER_USERHELP)
    {
               viewcontroller=[[UserHelpViewController alloc] init];
    }
    else if(message.receiveObjectID==VIEWCONTROLLER_USERFEEDBACK)
    {
               viewcontroller=[[UserFeedbackViewController alloc] init];
    }
    else if(message.receiveObjectID==VIEWCONTROLLER_WELCOME)
    {
        viewcontroller=[[UserWelcomeViewController alloc] init];
    }
    else if(message.receiveObjectID == VIEWCONTROLLER_LOADING)
    {
        viewcontroller = [[AppLoadingViewController alloc] init];
    }else if (message.receiveObjectID == VIEWCONTROLLER_PHONENUMBER)
    {
        viewcontroller = [[PhoneNumberViewController alloc] init];
    }
    
    if(viewcontroller != nil)
        [self addViewControllToRootViewController:viewcontroller forMessage:message];
    
    return YES;
}


@end
