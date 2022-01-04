//
//  UserPhone.m
//  G-NetLink
//
//  Created by liuxiaobo on 15/1/21.
//  Copyright (c) 2015年 95190. All rights reserved.
//

#import "UserPhone.h"

@implementation UserPhone

-(id)init
{
    if(self = [super init]){
       _mobile_phone = @"";
        _bnd_time = @"";
    }
    
    return self;
}
-(id)initWithDic:(NSDictionary*)dic
{
    if (self =[super init]) {
        if((NSNull *)dic==[NSNull null])
            return self;
        [self fillData:dic];
    }
    
    return self;
}
-(void)fillData:(NSDictionary*)dic
{
    _mobile_phone = [dic objectForKey:@"mobile_phone"];
    _bnd_time =[dic objectForKey:@"bnd_time"];

}
@end
