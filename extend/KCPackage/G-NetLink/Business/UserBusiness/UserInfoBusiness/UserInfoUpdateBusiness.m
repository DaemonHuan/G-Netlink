//
//  UserInfoUpdatePhoneBusiness.m
//  G-NetLink
//
//  Created by jayden on 14-4-15.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserInfoUpdateBusiness.h"

@implementation UserInfoUpdateBusiness
-(id)init
{
    if(self = [super initWithNtspHeader]){
        self.businessId = BUSINESS_UPDATEUSERINFO;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/user/update"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    return self;
}
@end
