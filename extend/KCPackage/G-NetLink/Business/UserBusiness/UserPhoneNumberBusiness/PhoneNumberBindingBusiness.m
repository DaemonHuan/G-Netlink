//
//  PhoneNumberBindingBusiness.m
//  G-NetLink
//
//  Created by liuxiaobo on 15/1/21.
//  Copyright (c) 2015年 95190. All rights reserved.
//

#import "PhoneNumberBindingBusiness.h"

@implementation PhoneNumberBindingBusiness
-(id)init
{
    if(self = [super initWithNtspHeader]){
        self.businessId = BUSINESS_PHONENUMBERBINDING;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"/system/User/AppBindMobilePhone"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    
    return self;
}
@end
