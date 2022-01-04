//
//  UserInfoNode.m
//  G-NetLink
//
//  Created by jayden on 14-4-23.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserInfoNode.h"
#import "UserPhoneModificationViewController.h"
#import "UserMoreViewController.h"

@implementation UserInfoNode
-(id)init
{
    if(self = [super init]){
        _nodeId = NODE_USERINFO;
        _workRange.location = NODE_USERINFO;
    }
    return self;
}

-(BOOL)receiveMessage:(Message *)message
{
    if(![super receiveMessage:message])
        return NO;
    
    BaseViewController *viewcontroller;
    if(message.receiveObjectID == VIEWCONTROLLER_UPDATEPHONE)
    {
        // 创建VIEWCONTROLLER_UPDATEPHONE对应的Controller
        viewcontroller=[[UserPhoneModificationViewController alloc]init];
        
    }
    if(message.receiveObjectID == VIEWCONTROLLER_USERMORE)
    {
        // 创建VIEWCONTROLLER_UPDATEPHONE对应的Controller
        viewcontroller=[[UserMoreViewController alloc]init];
        
    }

    
    
    if(viewcontroller != nil)
        [self addViewControllToRootViewController:viewcontroller forMessage:message];
    
    return YES;
}
@end
