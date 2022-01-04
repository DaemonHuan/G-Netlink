//
//  BusinessHttpConnectFactory.h
//  ZhiJiaX
//
//  Created by 95190 on 13-4-8.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessHttpConnectType.h"
@interface BusinessHttpConnectFactory : NSObject
+(id)createBusinessHttpConnect:(enum BusinessHttpConnectType)type;
@end
