//
//  LoginNode.m
//  MessageFrame
//
//  Created by 95190 on 13-4-7.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "TestNode.h"
#import "NodeAndViewControllerID.h"
#import "BaseViewController.h"
#import "testUserViewController.h"
#import "testVehicleViewController.h"
#import "testVersionAndNotificationViewController.h"


@implementation TestNode

-(id)init
{
    self = [super init];
    _nodeId = NODE_TEST;
    _workRange.location = NODE_TEST;
    return self;
}
-(BOOL)receiveMessage:(Message *)message
{
    if(![super receiveMessage:message])
        return NO;
    
    BaseViewController *viewcontroller;
    if(message.receiveObjectID == VIEWCONTROLLER_TEST1)
    {
        viewcontroller = [[testUserViewController alloc] initWithNibName:@"testUserViewController" bundle:nil];
    }
    else if(message.receiveObjectID==VIEWCONTROLLER_TEST2)
    {
        viewcontroller = [[testVehicleViewController alloc] initWithNibName:@"testVehicleViewController" bundle:nil];
    }
    else if (message.receiveObjectID==VIEWCONTROLLER_TEST3)
    {
        viewcontroller=[[testVersionAndNotificationViewController alloc] initWithNibName:@"testVersionAndNotificationViewController" bundle:nil];
    }
    if(viewcontroller != nil)
        [self addViewControllToRootViewController:viewcontroller forMessage:message];
    
    return YES;
}
@end
