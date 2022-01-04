//
//  SystemNode.m
//  G-NetLink
//
//  Created by jayden on 14-4-23.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "SystemNode.h"
#import "GuideNode.h"
#import "AppNode.h"
#import "LoginViewController.h"
#import "HallViewController.h"

@implementation SystemNode

-(id)init
{
    if(self = [super init]){
        _nodeId = NODE_SYSTEM;
        _workRange.location = NODE_SYSTEM;
    }
    return self;
}
-(BOOL)createChildNode
{
    GuideNode *guideNode = [[GuideNode alloc] init];
    guideNode.rootViewController = self.rootViewController;
    guideNode.parentNode = self;
    [guideNode createChildNode];
    //    [_childNode setObject:guideNode forKey:[NSString stringWithFormat:@"%d",guideNode.nodeId]];
    
    AppNode *appNode = [[AppNode alloc] init];
    appNode.rootViewController = self.rootViewController;
    appNode.parentNode = self;
    [appNode createChildNode];
    //    [_childNode setObject:appNode forKey:[NSString stringWithFormat:@"%d",appNode.nodeId]];
    
    _childNode=[NSMutableDictionary dictionaryWithObjects:@[guideNode,appNode] forKeys:@[[NSString stringWithFormat:@"%d",guideNode.nodeId],[NSString stringWithFormat:@"%d",appNode.nodeId]]];

    return YES;
}

-(BOOL)receiveMessage:(Message *)message
{
    if(![super receiveMessage:message])
        return NO;
    BaseViewController *viewcontroller;
    if(message.receiveObjectID == VIEWCONTROLLER_LOGIN)
    {
        viewcontroller=[[LoginViewController alloc] init];
//        viewcontroller = [[HallViewController alloc] init];
    }
    
    if(viewcontroller != nil)
        [self addViewControllToRootViewController:viewcontroller forMessage:message];
    
    return YES;
}
@end
