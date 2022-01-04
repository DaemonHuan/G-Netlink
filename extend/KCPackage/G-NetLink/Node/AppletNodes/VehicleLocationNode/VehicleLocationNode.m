//
//  VehicleLocationNode.m
//  G-NetLink
//
//  Created by a95190 on 14-10-12.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleLocationNode.h"
#import "VehicleLocationViewController.h"

@implementation VehicleLocationNode

-(id)init
{
    if(self = [super init]){
        _nodeId = NODE_VEHICLELOCATION;
        _workRange.location = NODE_VEHICLELOCATION;
    }
    return self;
}

-(BOOL)receiveMessage:(Message *)message
{
    if(![super receiveMessage:message])
        return NO;
    BaseViewController *viewcontroller;
    if (message.receiveObjectID==VIEWCONTROLLER_VEHICLELOCATION)
    {
        viewcontroller=[[VehicleLocationViewController alloc] init];
    }
    
    if(viewcontroller != nil)
        [self addViewControllToRootViewController:viewcontroller forMessage:message];
    
    return YES;
}


@end
