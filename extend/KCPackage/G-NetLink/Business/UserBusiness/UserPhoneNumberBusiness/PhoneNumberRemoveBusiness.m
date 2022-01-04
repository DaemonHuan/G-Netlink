//
//  PhoneNumberRemoveBusiness.m
//  G-NetLink
//
//  Created by liuxiaobo on 15/1/21.
//  Copyright (c) 2015年 95190. All rights reserved.
//

#import "PhoneNumberRemoveBusiness.h"

@implementation PhoneNumberRemoveBusiness
-(id)init
{
    if(self = [super initWithNtspHeader]){
        self.businessId = BUSINESS_PHONENUMBERREMOVE;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"/system/User/AppUnBindMobilePhone"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    
    return self;
}
@end
