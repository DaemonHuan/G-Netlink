//
//  BaseNode.h
//  MessageFrame
//
//  Created by 95190 on 13-4-1.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeAndViewControllerID.h"
#import "Message.h"

@class BaseViewController;
@class RootViewController;

@interface BaseNode : NSObject
{
@protected
    NSMutableDictionary *_childNode;
    enum NodeAndViewControllerID _nodeId;
    NSRange _workRange;
    NSMutableDictionary *saveData;
}
@property(nonatomic,readonly)NSDictionary *childNode;
@property(nonatomic,readonly)enum NodeAndViewControllerID nodeId;
@property(nonatomic,readonly)NSRange workRange;
@property(nonatomic,assign)BaseNode *parentNode;
@property(nonatomic,assign)RootViewController *rootViewController;

-(BOOL)receiveMessage:(Message*)message;
-(void)sendMessage:(Message*)message;
-(void)addViewControllToRootViewController:(BaseViewController*)viewcontroller forMessage:(Message*)message;
-(BOOL)createChildNode;
-(BOOL)checkWorkRange:(enum NodeAndViewControllerID)ID;
-(BaseNode*)checkChildNodeWorkRange:(enum NodeAndViewControllerID)ID;
//-(BOOL)nodeSaveValue:(Message*)message;
-(void)nodeClearValue;
-(void)clearChildNodeSaveData;
-(void)addNodeOfSaveData:(NSString*)key forValue:(id)value;
-(id)getNodeOfSaveDataAtKey:(NSString*)key;
@end
