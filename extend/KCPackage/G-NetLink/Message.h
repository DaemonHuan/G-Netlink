//
//  Message.h
//  MessageFrame
//
//  Created by 95190 on 13-4-1.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandID.h"
#import "NodeAndViewControllerID.h"

@interface Message : NSObject
{
@protected
    enum NodeAndViewControllerID _receiveObjectID;
    enum NodeAndViewControllerID _sendObjectID;
    enum CommandID _commandID;
    id _externData;
}
@property(nonatomic)enum NodeAndViewControllerID receiveObjectID;
@property(nonatomic)enum NodeAndViewControllerID sendObjectID;
@property(nonatomic)enum CommandID commandID;
@property(nonatomic,retain)id externData;
@end
