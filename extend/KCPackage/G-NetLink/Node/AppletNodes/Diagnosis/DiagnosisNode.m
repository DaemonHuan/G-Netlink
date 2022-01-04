//
//  DiagnosisNode.m
//  G-NetLink
//
//  Created by 95190 on 14-10-15.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "DiagnosisNode.h"
#import "DiagnosisViewController.h"

@implementation DiagnosisNode

-(id)init
{
    self = [super init];
    _nodeId = NODE_REMOTEDIAGNOSIS;
    _workRange.location = NODE_REMOTEDIAGNOSIS;
    return self;
}

-(BOOL)receiveMessage:(Message *)message
{
    if(![super receiveMessage:message])
        return NO;
    
    BaseViewController *viewcontroller;
    if(message.receiveObjectID == VIEWCONTROLLER_DIAGNOSIS)
    {
        viewcontroller = [[DiagnosisViewController alloc] init];
    }
    
    if(viewcontroller != nil)
        [self addViewControllToRootViewController:viewcontroller forMessage:message];
    
    return YES;
}
@end
