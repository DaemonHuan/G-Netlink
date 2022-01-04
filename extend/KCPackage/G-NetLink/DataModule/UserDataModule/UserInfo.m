//
//  UserInfo.m
//  G-NetLink
//
//  Created by jayden on 14-4-14.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserInfo.h"

@interface UserInfo()
{
    NSString *newPhone;
}

@end
@implementation UserInfo
-(void)getInfo
{
    [self creatBusinessWithId:BUSINESS_GETUSERINFO andExecuteWithData:nil];
}
-(void)updateMobilePhone:(NSString *)newMoblePhone
{
    newPhone=newMoblePhone;
    NSDictionary *dic=[NSDictionary dictionaryWithObject:newMoblePhone forKey:@"mobilephone"];
    [self creatBusinessWithId:BUSINESS_UPDATEUSERINFO andExecuteWithData:dic];
}

#pragma mark - BusinessProtocl
- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary*)businessData
{
    if(business.businessId == BUSINESS_GETUSERINFO)
    {
        NSDictionary *data=[businessData objectForKey:@"data"];
        _realname=[data objectForKey:@"realname"];
        _gender=[data objectForKey:@"gender"];
        _certificate_num=[data objectForKey:@"certificate_num"];
        _mobilephone=[data objectForKey:@"mobilephone"];
    }
    else if (business.businessId==BUSINESS_UPDATEUSERINFO)
    {
        _mobilephone=[NSString stringWithString:newPhone];
    }
    [super didBusinessSucess:business withData:businessData];
}
@end
