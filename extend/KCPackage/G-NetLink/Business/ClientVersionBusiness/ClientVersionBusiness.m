//
//  ClientVersionBusiness.m
//  G-NetLink
//
//  Created by jayden on 14-4-22.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "ClientVersionBusiness.h"
#import "G-NetLink-Prefix.pch"

@implementation ClientVersionBusiness
-(id)init
{
    if (self = [super init]) {
        self.businessId = BUSINESS_OTHER_CLIENTVERSION;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/version/get"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    
    return self;
}
@end
