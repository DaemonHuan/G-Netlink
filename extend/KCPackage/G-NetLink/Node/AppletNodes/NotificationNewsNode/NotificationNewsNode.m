//
//  NotificationNewsNode.m
//  G-NetLink
//
//  Created by jayden on 14-4-23.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "NotificationNewsNode.h"
#import "NotificationDetailedViewController.h"
#import "NotificationViewController.h"
@implementation NotificationNewsNode

-(id)init
{
    self = [super init];
    _nodeId = NODE_NOTIFICATIONNEWS;
    _workRange.location = NODE_NOTIFICATIONNEWS;
    return self;
}

-(BOOL)receiveMessage:(Message *)message
{
    if(![super receiveMessage:message])
        return NO;
    
    BaseViewController *viewcontroller;
    if(message.receiveObjectID == VIEWCONTROLLER_NOTIFICATIONNEWS)
    {
       // 创建VIEWCONTROLLER_NOTIFICATIONNEWS对应的Controller
        
        viewcontroller=[[NotificationViewController alloc]init];
    }
    else if(message.receiveObjectID == VIEWCONTROLLER_NOTIFICATIONNEWS_DETAIL)
    {
        viewcontroller=[[NotificationDetailedViewController alloc]init];
    }
    
    if(viewcontroller != nil)
        [self addViewControllToRootViewController:viewcontroller forMessage:message];
    
    return YES;
}
@end
