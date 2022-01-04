//
//  UserLogoutBusiness.m
//  G-NetLink
//
//  Created by jayden on 14-4-14.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserLogoutBusiness.h"
#import "G-NetLink-Prefix.pch"

@implementation UserLogoutBusiness
-(id)init
{
    if(self = [super initWithNtspHeader]){
        self.businessId = BUSINESS_LOGOUT;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/user/logout"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    return self;
}
@end
