//
//  GuideNode.m
//  G-NetLink
//
//  Created by jayden on 14-4-23.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "GuideNode.h"

@implementation GuideNode

-(id)init
{
    self = [super init];
    _nodeId = NODE_GUIDE;
    _workRange.location = NODE_GUIDE;
    return self;
}
-(BOOL)receiveMessage:(Message *)message
{
    if(![super receiveMessage:message])
        return NO;
    
    BaseViewController *viewcontroller;
    if(message.receiveObjectID == VIEWCONTROLLER_GUIDE)
    {
        
    }
    
    if(viewcontroller != nil)
        [self addViewControllToRootViewController:viewcontroller forMessage:message];
    
    return YES;
}

@end
