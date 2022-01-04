//
//  AppNode.m
//  G_NetLink
//
//  Created by 95190 on 14-4-22.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "AppNode.h"

@implementation AppNode

-(id)init
{
    if (self = [super init]) {
        _nodeId = NODE_APP;
        _workRange.location = NODE_APP;
    }
    return self;
}

-(BOOL)receiveMessage:(Message *)message
{
    if(![super receiveMessage:message])
        return NO;
    
    BaseViewController *viewcontroller;
    if(message.receiveObjectID == VIEWCONTROLLER_ABOUT)
    {//根据ControllerID创建不同的Controller
        //viewcontroller = [[SettingViewController alloc] init];
    }
    
    if(viewcontroller != nil)
        [self addViewControllToRootViewController:viewcontroller forMessage:message];
    
    return YES;
}
@end
