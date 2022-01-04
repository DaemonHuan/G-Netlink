//
//  BaseNode.m
//  MessageFrame
//
//  Created by 95190 on 13-4-1.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "BaseNode.h"
#import "BaseViewController.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

#define AnimationDuration 0.6
#define QueueName "rootViewControllerQueue"
static enum CommandID currentCommandID;
static dispatch_queue_t queue;
static NSCondition *lock;

@interface BaseNode()
{
    BaseViewController *previousViewController;
    BaseViewController *holdViewController;
    BaseViewController *showViewController;
    BaseViewController *tempViewController;
}
-(void)animationSystemBlock:(BaseViewController*)viewcontroller forDuration:(double)duration forType:(NSString*)type forSubtype:(NSString*)subtype;
-(void)customAnimationBlock:(BaseViewController*)viewcontroller forCommandID:(enum CommandID)ID;
-(void)animationDidStop;
@end

@implementation BaseNode
@synthesize childNode = _childNode;
@synthesize nodeId = _nodeId;
@synthesize workRange = _workRange;

-(id)init
{
    self = [super init];
    _childNode = [[NSMutableDictionary alloc] init];
    _workRange.length = NODE_WORK_LENGTH;
    previousViewController = nil;
    
    if(lock == nil)
    {
        lock = [[NSCondition alloc] init];
        queue = dispatch_queue_create(QueueName, DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}
-(void)sendMessage:(Message*)message
{
    if(self.parentNode == nil)
        return;
    [self.parentNode receiveMessage:message];
}
-(BOOL)receiveMessage:(Message*)message
{
    BOOL checkFlag = YES;
    if(![self checkWorkRange:message.receiveObjectID])
    {
        checkFlag = NO;
        //[self sendMessage:message];
        //return NO;
    }
    if(!checkFlag)
    {
        BaseNode *node = [self checkChildNodeWorkRange:message.receiveObjectID];
        if(node!=nil)
            [node receiveMessage:message];
        else
        {
            [self sendMessage:message];
            return NO;
        }
    }
    //[self nodeSaveValue:message];
    return YES;
}
-(BOOL)checkWorkRange:(enum NodeAndViewControllerID)ID
{
    if(ID != self.nodeId)
    {
        if(ID<self.workRange.location || ID>self.workRange.location+self.workRange.length)
        {
            return NO;
        }
    }
    return YES;
}
-(void)animationSystemBlock:(BaseViewController*)viewcontroller forDuration:(double)duration forType:(NSString*)type forSubtype:(NSString*)subtype
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:duration];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseIn]];
    [animation setDelegate:self];
    [animation setType:type];
    [animation setSubtype: subtype];
    [viewcontroller.view.layer addAnimation:animation forKey:@"animation"];
}
-(void)addViewControllToRootViewController:(BaseViewController*)viewcontroller forMessage:(Message*)message
{
    //NSArray *a = self.rootViewController.childViewControllers;

    dispatch_async(queue, ^{
    [lock lock];
    dispatch_sync(dispatch_get_main_queue(), ^{
    
    tempViewController = viewcontroller;
    if(currentCommandID == MC_CREATE_OPENFROMRIGHT_VIEWCONTROLLER)
        holdViewController = [self.rootViewController.childViewControllers objectAtIndex:1];
    
    if(self.rootViewController.childViewControllers.count>0)
    {
        previousViewController = [self.rootViewController.childViewControllers objectAtIndex:0];
        if(message.commandID != MC_CREATE_CLOSEFROMRIGHT_VIEWCONTROLLER)
            [previousViewController destroyDataBeforeDealloc];
        else
        {
            tempViewController = previousViewController;
            previousViewController = holdViewController;
        }
    }
    
    currentCommandID = message.commandID;
    tempViewController.parentNode = self;
    [tempViewController receiveMessage:message];
    showViewController = tempViewController;
    if(message.commandID!=MC_CREATE_NORML_VIEWCONTROLLER)
        showViewController.view.userInteractionEnabled = NO;
    
    [self.rootViewController addChildViewController:tempViewController];
    //a = self.rootViewController.childViewControllers;
    if(message.commandID == MC_CREATE_NORML_VIEWCONTROLLER)
    {
        [self animationDidStop];
        [self.rootViewController.view addSubview:tempViewController.view];
    }
    else if(message.commandID == MC_CREATE_FLIPFROMLEFT_VIEWCONTROLLER)
    {
        [self customAnimationBlock:tempViewController forCommandID:MC_CREATE_FLIPFROMLEFT_VIEWCONTROLLER];
        [self.rootViewController.view addSubview:tempViewController.view];
    }
    else if(message.commandID == MC_CREATE_PUSHFROMRIGHT_VIEWCONTROLLER)
    {
        [self animationSystemBlock:tempViewController forDuration:AnimationDuration forType:kCATransitionPush forSubtype:kCATransitionFromRight];
        [self.rootViewController.view addSubview:tempViewController.view];
    }
    else if(message.commandID == MC_CREATE_PUSHFROMLEFT_VIEWCONTROLLER)
    {
        [self animationSystemBlock:tempViewController forDuration:AnimationDuration forType:kCATransitionPush forSubtype:kCATransitionFromLeft];
        [self.rootViewController.view addSubview:tempViewController.view];
    }
    else if(message.commandID == MC_CREATE_OPENFROMRIGHT_VIEWCONTROLLER)
    {
        [self customAnimationBlock:previousViewController forCommandID:message.commandID];
        [self.rootViewController.view insertSubview:tempViewController.view belowSubview:previousViewController.view];
    }
    else if(message.commandID == MC_CREATE_CLOSEFROMRIGHT_VIEWCONTROLLER)
    {
        [self customAnimationBlock:tempViewController forCommandID:message.commandID];
        [self.rootViewController.view addSubview:tempViewController.view];
    }
    else if(message.commandID == MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER)
    {
        [self customAnimationBlock:tempViewController forCommandID:message.commandID];
        [self.rootViewController.view addSubview:tempViewController.view];
    }
    else if(message.commandID == MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER)
    {
        [self customAnimationBlock:tempViewController forCommandID:message.commandID];
        [self.rootViewController.view addSubview:tempViewController.view];
    }
    else if(message.commandID == MC_CREATE_GRADUALLYINTO_VIEWCONTROLLER)
    {
        [self customAnimationBlock:tempViewController forCommandID:message.commandID];
        [self.rootViewController.view addSubview:tempViewController.view];
    }
    else if(message.commandID == MC_CREATE_GRADUALLYOUT_VIEWCONTROLLER)
    {
        [self customAnimationBlock:tempViewController forCommandID:message.commandID];
        [self.rootViewController.view insertSubview:tempViewController.view belowSubview:previousViewController.view];
    }
    else
        return;
    previousViewController.view.userInteractionEnabled = NO;
    tempViewController = nil;
      });
    });
}
//-(BOOL)nodeSaveValue:(Message*)message
//{
//    if(message.commandID!=MC_NODE_SAVE_VALUE)
//        return NO;
//    return YES;
//}
-(void)addNodeOfSaveData:(NSString*)key forValue:(id)value
{
    if(saveData==nil)
        saveData = [[NSMutableDictionary alloc] init];
    
    [saveData setObject:value forKey:key];
}
-(id)getNodeOfSaveDataAtKey:(NSString*)key
{
    return [saveData objectForKey:key];
}
-(void)clearChildNodeSaveData
{
    [saveData removeAllObjects];
    
    NSArray *baseNodeArray = _childNode.allValues;
    for(int n=0;n<baseNodeArray.count;n++)
    {
        BaseNode *node = [baseNodeArray objectAtIndex:n];
        [node clearChildNodeSaveData];
    }
}
-(void)nodeClearValue
{
    [saveData removeAllObjects];
}
-(void)customAnimationBlock:(BaseViewController*)viewcontroller forCommandID:(enum CommandID)ID
{
    if(ID == MC_CREATE_OPENFROMRIGHT_VIEWCONTROLLER)
    {
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:AnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
        
        CGRect frame = viewcontroller.view.frame;
        frame.origin.x = [UIScreen mainScreen].bounds.size.width-100;
        viewcontroller.view.frame = frame;
        [UIView commitAnimations];
    }
    else if(ID == MC_CREATE_CLOSEFROMRIGHT_VIEWCONTROLLER)
    {
        CGRect frame = viewcontroller.view.frame;
        frame.origin.x = [UIScreen mainScreen].bounds.size.width-100;
        viewcontroller.view.frame = frame;
        
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:AnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
        
        frame.origin.x = 0;
        viewcontroller.view.frame = frame;
        [UIView commitAnimations];
    }
    else if(ID == MC_CREATE_FLIPFROMLEFT_VIEWCONTROLLER)
    {
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:AnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
        [UIView transitionFromView:previousViewController.view toView:viewcontroller.view duration:AnimationDuration options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
        [UIView commitAnimations];
    }
    else if(ID == MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER)
    {
        CGRect newFrame = viewcontroller.view.frame;
        newFrame.origin.x = newFrame.size.width;
        viewcontroller.view.frame = newFrame;
        
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:AnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
        
        newFrame.origin.x = 0;
        viewcontroller.view.frame = newFrame;
        
        CGRect previousFrame = previousViewController.view.frame;
        previousFrame.origin.x=previousFrame.origin.x-previousFrame.size.width;
        previousViewController.view.frame = previousFrame;
        [UIView commitAnimations];
    }
    else if(ID == MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER)
    {
        CGRect newFrame = viewcontroller.view.frame;
        newFrame.origin.x = newFrame.origin.x - newFrame.size.width;
        viewcontroller.view.frame = newFrame;
        
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:AnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
        
        newFrame.origin.x = 0;
        viewcontroller.view.frame = newFrame;
        
        CGRect previousFrame = previousViewController.view.frame;
        previousFrame.origin.x=previousFrame.size.width;
        previousViewController.view.frame = previousFrame;
        [UIView commitAnimations];
    }
    else if(ID == MC_CREATE_GRADUALLYINTO_VIEWCONTROLLER)
    {
        viewcontroller.view.alpha = 0.0;
        
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:AnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
        viewcontroller.view.alpha = 1.0;
        [UIView commitAnimations];
    }
    else if(ID == MC_CREATE_GRADUALLYOUT_VIEWCONTROLLER)
    {
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:AnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
        previousViewController.view.alpha = 0.0;
        [UIView commitAnimations];
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self animationDidStop];
}
-(void)animationDidStop
{
    @autoreleasepool
    {
        if(previousViewController!=nil)
        {
            if(currentCommandID != MC_CREATE_OPENFROMRIGHT_VIEWCONTROLLER)
            {
                [previousViewController.view removeFromSuperview];
                [previousViewController removeFromParentViewController];
            }
            if(holdViewController!=nil)
            {
                [holdViewController.view removeFromSuperview];
                [holdViewController removeFromParentViewController];
                holdViewController = nil;
            }
            previousViewController = nil;
        }
        [lock unlock];
        showViewController.view.userInteractionEnabled = YES;
        showViewController = nil;
    }
//    NSArray *a = self.rootViewController.childViewControllers;
//    int n;
//    n=10;
}
-(BaseNode*)checkChildNodeWorkRange:(enum NodeAndViewControllerID)ID
{
    NSArray *baseNodeArray = _childNode.allValues;
    for(int n=0;n<baseNodeArray.count;n++)
    {
        BaseNode *node = [baseNodeArray objectAtIndex:n];
        if([node checkWorkRange:ID])
            return node;
        node = [node checkChildNodeWorkRange:ID];
        if(node)
            return node;
    }
    return nil;
}
-(BOOL)createChildNode
{
    return NO;
}
@end
