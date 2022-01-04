//
//  AppletNode.m
//  G-NetLink
//
//  Created by jayden on 14-4-23.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "AppletNode.h"
#import "VehicleConditionNode.h"
#import "VehicleControlNode.h"
#import "UserManagerNode.h"
#import "NotificationNewsNode.h"
#import "HallViewController.h"
#import "NotificationViewController.h"
#import "VehicleLocationNode.h"
#import "DiagnosisNode.h"

@implementation AppletNode
-(id)init
{
    if(self = [super init]){
        _nodeId = NODE_APPLET;
        _workRange.location = NODE_APPLET;
    }
    return self;
}
-(BOOL)createChildNode
{
    NotificationNewsNode *notificationNewsNode = [[NotificationNewsNode alloc] init];
    notificationNewsNode.rootViewController = self.rootViewController;
    notificationNewsNode.parentNode = self;
    [notificationNewsNode createChildNode];
//    [_childNode setObject:notificationNewsNode forKey:[NSString stringWithFormat:@"%d",notificationNewsNode.nodeId]];
    
    VehicleConditionNode *vehicleConditionNode = [[VehicleConditionNode alloc] init];
    vehicleConditionNode.rootViewController = self.rootViewController;
    vehicleConditionNode.parentNode = self;
    [vehicleConditionNode createChildNode];
//    [_childNode setObject:vehicleConditionNode forKey:[NSString stringWithFormat:@"%d",vehicleConditionNode.nodeId]];
    
    VehicleControlNode *vehicleControlNode = [[VehicleControlNode alloc] init];
    vehicleControlNode.rootViewController = self.rootViewController;
    vehicleControlNode.parentNode = self;
    [vehicleControlNode createChildNode];
//    [_childNode setObject:vehicleControlNode forKey:[NSString stringWithFormat:@"%d",vehicleControlNode.nodeId]];
    
    VehicleLocationNode *vehicleLocationNode =[[VehicleLocationNode alloc] init];
    vehicleLocationNode.rootViewController = self.rootViewController;
    vehicleLocationNode.parentNode = self;
    [vehicleLocationNode createChildNode];
    
    UserManagerNode *userManagerNode = [[UserManagerNode alloc] init];
    userManagerNode.rootViewController = self.rootViewController;
    userManagerNode.parentNode = self;
    [userManagerNode createChildNode];
//    [_childNode setObject:userManagerNode forKey:[NSString stringWithFormat:@"%d",userManagerNode.nodeId]];
    
    DiagnosisNode *diagnosisNode = [[DiagnosisNode alloc] init];
    diagnosisNode.rootViewController = self.rootViewController;
    diagnosisNode.parentNode = self;
    [diagnosisNode createChildNode];
    
    _childNode=[NSMutableDictionary dictionaryWithObjects:@[notificationNewsNode,vehicleConditionNode,vehicleControlNode,userManagerNode,vehicleLocationNode,diagnosisNode] forKeys:@[[NSString stringWithFormat:@"%d",notificationNewsNode.nodeId],[NSString stringWithFormat:@"%d",vehicleConditionNode.nodeId],[NSString stringWithFormat:@"%d",vehicleControlNode.nodeId],[NSString stringWithFormat:@"%d",userManagerNode.nodeId],[NSString stringWithFormat:@"%d",vehicleLocationNode.nodeId],[NSString stringWithFormat:@"%d",diagnosisNode.nodeId]]];
    return YES;
}

-(BOOL)receiveMessage:(Message *)message
{
    if(![super receiveMessage:message])
        return NO;
    BaseViewController *viewcontroller;
    if(message.receiveObjectID == VIEWCONTROLLER_HALL)
    {
        //创建主页Controller
        viewcontroller=[[HallViewController alloc] init];
    }

    
    if(viewcontroller != nil)
        [self addViewControllToRootViewController:viewcontroller forMessage:message];
    
    return YES;
}
@end
