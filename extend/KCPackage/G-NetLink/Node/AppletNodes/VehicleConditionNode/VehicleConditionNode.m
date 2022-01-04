//
//  VehicleConditionNode.m
//  G-NetLink
//
//  Created by jayden on 14-4-23.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleConditionNode.h"
#import "VehicleConditionViewController.h"
#import "VehicleConditionOfDoorsOrWindowsViewController.h"
#import "VehicleConditionOfBatteryViewController.h"

@implementation VehicleConditionNode
-(id)init
{
    if(self = [super init]){
        _nodeId = NODE_VEHICLECONDITION;
        _workRange.location = NODE_VEHICLECONDITION;
    }
    return self;
}

-(BOOL)receiveMessage:(Message *)message
{
    if(![super receiveMessage:message])
        return NO;
    BaseViewController *viewcontroller;
    if (message.receiveObjectID==VIEWCONTROLLER_VEHICLECONDITION)
    {
        viewcontroller=[[VehicleConditionViewController alloc] init];
    }
    else if (message.receiveObjectID==VIEWCONTROLLER_VEHICLECONDITIONOFDOORORWINDOW)
    {
        viewcontroller=[[VehicleConditionOfDoorsOrWindowsViewController alloc] init];
    }
    else if (message.receiveObjectID==VIEWCONTROLLER_VEHICLECONDITIONOFBATTERY){
        viewcontroller=[[VehicleConditionOfBatteryViewController alloc] init];
    }
    if(viewcontroller != nil)
        [self addViewControllToRootViewController:viewcontroller forMessage:message];
    
    return YES;
}
@end
