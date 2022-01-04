//
//  BusinessHttpConnectFactory.m
//  ZhiJiaX
//
//  Created by 95190 on 13-4-8.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "BusinessHttpConnectFactory.h"

@implementation BusinessHttpConnectFactory

+(id)createBusinessHttpConnect:(enum BusinessHttpConnectType)type
{
    if(type == BUSINESS_HTTPCONNECT_NONE)
        return nil;
    return nil;
}
@end
