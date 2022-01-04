//
//  PhoneNumberGetBusiness.m
//  G-NetLink
//
//  Created by liuxiaobo on 15/1/21.
//  Copyright (c) 2015年 95190. All rights reserved.
//

#import "PhoneNumberGetBusiness.h"
#import "G-NetLink-Prefix.pch"

@implementation PhoneNumberGetBusiness
-(id)init
{
    if(self = [super initWithNtspHeader]){
        self.businessId = BUSINESS_PHONENUMBERGET;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"/system/User/GetAppBindMobilePhoneList"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    
    return self;
}
@end
