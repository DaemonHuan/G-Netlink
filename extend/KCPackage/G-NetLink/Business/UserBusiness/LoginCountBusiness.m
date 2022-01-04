//
//  LoginCountBusiness.m
//  G-NetLink
//
//  Created by 95190 on 14-10-9.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "LoginCountBusiness.h"

@implementation LoginCountBusiness
-(id)init
{
    if(self = [super initWithNtspHeader]){
        self.businessId = BUSINESS_LOGINCOUNT;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/user/getlogincount"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    
    return self;
}
@end
