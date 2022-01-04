//
//  NodeRoot.m
//  MessageFrame
//
//  Created by 95190 on 13-4-2.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "NodeRoot.h"
#import "NodeAndViewControllerID.h"
#import "BaseViewController.h"
#import "RootViewController.h"
#import "TestNode.h"
#import "SystemNode.h"
#import "AppletNode.h"

@interface NodeRoot()
{
    
}
-(void)allNodeClearValue;
@end

@implementation NodeRoot

-(id)init
{
    self = [super init];
    _nodeId = NODE_ROOT;
    _workRange.location = NODE_ROOT;
    return self;
}
-(BOOL)createChildNode
{
    TestNode *testNode = [[TestNode alloc] init];
    testNode.rootViewController = self.rootViewController;
    testNode.parentNode = self;
    [testNode createChildNode];
//    [_childNode setObject:testNode forKey:[NSString stringWithFormat:@"%d",testNode.nodeId]];
    
    SystemNode *systemNode = [[SystemNode alloc] init];
    systemNode.rootViewController = self.rootViewController;
    systemNode.parentNode = self;
    [systemNode createChildNode];
//    [_childNode setObject:systemNode forKey:[NSString stringWithFormat:@"%d",systemNode.nodeId]];
    
    AppletNode *appletNode = [[AppletNode alloc] init];
    appletNode.rootViewController = self.rootViewController;
    appletNode.parentNode = self;
    [appletNode createChildNode];
//    [_childNode setObject:appletNode forKey:[NSString stringWithFormat:@"%d",appletNode.nodeId]];
    _childNode=[NSMutableDictionary dictionaryWithObjects:@[testNode,systemNode,appletNode] forKeys:@[[NSString stringWithFormat:@"%d",testNode.nodeId],[NSString stringWithFormat:@"%d",systemNode.nodeId ],[NSString stringWithFormat:@"%d",appletNode.nodeId]]];
    return YES;
}
//-(void)allNodeClearValue
//{
//    NSArray *baseNodeArray = _childNode.allValues;
//    for(int n=0;n<baseNodeArray.count;n++)
//    {
//        BaseNode *node = [baseNodeArray objectAtIndex:n];
//        [node nodeClearValue];
//    }
//}
-(BOOL)receiveMessage:(Message *)message
{
    if(![super receiveMessage:message])
        return NO;
    
    if(message.commandID == MC_CHILD_NODE_CLEAR_VALUE)
        [self clearChildNodeSaveData];
    else if(message.commandID>=MC_TABBAR_0 && message.commandID<=MC_TABBAR_3)
    {
        [self.rootViewController receiveMessage:message];
    }
//    BaseNode *node = [self checkChildNodeWorkRange:message.receiveObjectID];
//    
//    if(node==nil)
//    {
//        BaseViewController *viewcontroller;
//        if(message.receiveObjectID == VIEWCONTROLLER_TEST2)
//        {
//            viewcontroller = [[test2ViewController alloc] initWithNibName:@"test2ViewController" bundle:nil];
//        }
//        else if(message.receiveObjectID == VIEWCONTROLLER_TEST3)
//        {
//            viewcontroller = [[testProductViewController alloc] initWithNibName:@"testProductViewController" bundle:nil];
//        }
//        if(viewcontroller != nil)
//            [self addViewControllToRootViewController:viewcontroller forMessage:message];
//    }
    
    return YES;
}
@end
