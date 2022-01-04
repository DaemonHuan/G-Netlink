//
//  NtspHeader.m
//  G_NetLink
//
//  Created by 95190 on 14-3-20.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "NtspHeader.h"
static NtspHeader *ntspHeader;
@implementation NtspHeader

- (id)init
{
    if (self = [super init]) {
        self.uuid = UUID;
        self.mobileNumber = MOBILE_NUMBER;
        self.accessToken = ACCESS_TOKEN;
        self.tuid = TUID;
    }
    return  self;
}

+ (void)setWithJson:(NSDictionary*)jsonDic
{
    if(!ntspHeader)
        ntspHeader=[[NtspHeader alloc] init];
    ntspHeader.uuid = [jsonDic objectForKey:@"uuid"];
    ntspHeader.mobileNumber = [jsonDic objectForKey:@"mobilenumber"];
    ntspHeader.accessToken = [jsonDic objectForKey:@"access_token"];
    ntspHeader.tuid = [jsonDic objectForKey:@"tuid"];
}

+ (NtspHeader *) shareHeader
{
    if(!ntspHeader)
        ntspHeader=[[NtspHeader alloc] init];
    return ntspHeader;
}

- (NSDictionary *)toDicValue
{
    NSMutableDictionary * ntspHeaderDictionary = [[NSMutableDictionary alloc] init];
    if (self.uuid) {
        [ntspHeaderDictionary setValue:self.uuid forKey:@"uuid"];
    }
    if (self.mobileNumber) {
        [ntspHeaderDictionary setValue:self.mobileNumber forKey:@"mobilenumber"];
    }
    if (self.accessToken) {
        [ntspHeaderDictionary setValue:self.accessToken forKey:@"access_token"];
    }
    if (self.tuid) {
        [ntspHeaderDictionary setValue:self.tuid forKey:@"tuid"];
    }

    if ([ntspHeaderDictionary count] == 0) {
        return nil;
    }else{
        return ntspHeaderDictionary;
    }
}
@end
