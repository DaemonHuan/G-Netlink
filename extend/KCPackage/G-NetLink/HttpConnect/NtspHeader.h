//
//  NtspHeader.h
//  G_NetLink
//
//  Created by 95190 on 14-3-20.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpConnectDefineData.h"

@interface NtspHeader : NSObject
{
    int _errcode;
}
@property(strong , nonatomic) NSString * uuid;
@property(strong , nonatomic) NSString * mobileNumber;
@property(strong , nonatomic) NSString * accessToken;
@property(strong , nonatomic) NSString * tuid;

+ (NtspHeader *) shareHeader;
+ (void)setWithJson:(NSDictionary*)jsonDic;
- (NSDictionary *)toDicValue;
@end
