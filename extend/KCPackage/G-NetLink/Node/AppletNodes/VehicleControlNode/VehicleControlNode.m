//
//  VehicleControlNode.m
//  G-NetLink
//
//  Created by jayden on 14-4-23.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleControlNode.h"
#import "VehicleControlViewController.h"
#import "VehicleControlHistoryViewController.h"
#import "VehicleControlHistoryDetailViewController.h"

@implementation VehicleControlNode
-(id)init
{
    if(self = [super init]){
        _nodeId = NODE_VEHICLECONTROL;
        _workRange.location = NODE_VEHICLECONTROL;
    }
    return self;
}

-(BOOL)receiveMessage:(Message *)message
{
    if(![super receiveMessage:message])
        return NO;
    BaseViewController *viewcontroller;
    if (message.receiveObjectID==VIEWCONTROLLER_VEHICLECONTROL)
    {
        viewcontroller=[[VehicleControlViewController alloc] init];
    }
    else if (message.receiveObjectID==VIEWCONTROLLER_VEHICLECONTROLHISTORY)
    {
        viewcontroller=[[VehicleControlHistoryViewController alloc] init];
    }
    else if(message.receiveObjectID==VIEWCONTROLLER_VEHICLECONTROLHISTORYDETAIL)
    {
        viewcontroller=[[VehicleControlHistoryDetailViewController alloc] init];
    }
    if(viewcontroller != nil)
        [self addViewControllToRootViewController:viewcontroller forMessage:message];
    
    return YES;
}
@end
