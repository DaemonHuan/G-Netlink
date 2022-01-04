//
//  VerifyCode.m
//  G-NetLink
//
//  Created by 95190 on 14-10-9.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VerifyCode.h"
#import "BusinessFactory.h"

@implementation VerifyCode

-(void)getVerifyCode
{
    baseBusiness = [BusinessFactory createBusiness:BUSINESS_OTHER_SENDVERIFYCODE];
    baseBusiness.businessObserver = self;
    [baseBusiness execute:nil];
}

@end
