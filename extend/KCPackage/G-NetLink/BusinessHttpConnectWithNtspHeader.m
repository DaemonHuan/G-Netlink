//
//  BusinessHttpConnectWithNtspHeader.m
//  G_NetLink
//
//  Created by 95190 on 14-3-21.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BusinessHttpConnectWithNtspHeader.h"
#import "NtspHeader.h"

@implementation BusinessHttpConnectWithNtspHeader

-(id)init
{
    if(self=[super init]){
        self.ntspHeaderJLH=[NtspHeader shareHeader];
    }
    return self;
}


//创建消息体
- (void)createBaseBussinessHttpBody:(NSDictionary *)theParam
{
    NSError *theError;
    NSMutableDictionary * baseBusinessHttpBodyDic;
    if(theParam!=nil)
        baseBusinessHttpBodyDic = [[NSMutableDictionary alloc] initWithDictionary:theParam];
    else
        baseBusinessHttpBodyDic = [[NSMutableDictionary alloc] init];
    
    if (self.ntspHeaderJLH != nil){
        [baseBusinessHttpBodyDic setObject:[self.ntspHeaderJLH toDicValue] forKey:@"ntspheader"];
    }
    if ([self.resquestType isEqualToString:HTTP_REQUEST_POST]) {
        if ([body isKindOfClass:[NSMutableData class]]) {
            [(NSMutableData *)body appendData:[NSJSONSerialization dataWithJSONObject:baseBusinessHttpBodyDic options:NSJSONWritingPrettyPrinted error:&theError]];
        }
    }
}
@end
