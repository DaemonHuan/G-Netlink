//
//  Message.m
//  MessageFrame
//
//  Created by 95190 on 13-4-1.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "Message.h"

@implementation Message
@synthesize externData = _externData;
@synthesize commandID = _commandID;
@synthesize receiveObjectID = _receiveObjectID;
@synthesize sendObjectID = _sendObjectID;


-(id)init
{
    self = [super init];
    _receiveObjectID = NODE_NONE;
    _sendObjectID = NODE_NONE;
    return self;
}

-(void)dealloc
{
    self.externData = nil;
}
@end
