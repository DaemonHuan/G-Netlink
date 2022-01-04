//
//  UserLoginBusiness.m
//  G-NetLink
//
//  Created by jayden on 14-4-14.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserLoginBusiness.h"

@implementation UserLoginBusiness
-(id)init
{
    if(self = [super init]){
        self.businessId = BUSINESS_LOGIN;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/user/login"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    
    return self;
}
@end
