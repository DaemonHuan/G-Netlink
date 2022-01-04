//
//  BaseBusinessHttpConnect.m
//  G_NetLink
//
//  Created by 95190 on 14-3-20.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseBusinessHttpConnect.h"

@implementation BaseBusinessHttpConnect

- (void)createBaseBussinessHeads
{
    HttpHead * headerContentType = [[HttpHead alloc] init];
    HttpHead * headerContentEncoding = [[HttpHead alloc] init];
    
    headerContentType.headName = HEADER_CONTENT_TYPE_NAME;
    headerContentType.headValue = HEADER_CONTENT_TYPE_VALUE;
    
    headerContentEncoding.headName = HEADER_CONTENT_LENGTH_NAME;
    headerContentEncoding.headValue = HEADER_CONTENT_LENGTH_VALUE;
    
    [self.resquestHeads addObject:headerContentType];
    [self.resquestHeads addObject:headerContentEncoding];
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
    
    if ([self.resquestType isEqualToString:HTTP_REQUEST_POST]) {
        if ([body isKindOfClass:[NSMutableData class]]) {
            [(NSMutableData *)body appendData:[NSJSONSerialization dataWithJSONObject:baseBusinessHttpBodyDic options:NSJSONWritingPrettyPrinted error:&theError]];
        }
    }
}

- (void)sendWithParam:(NSDictionary *)theParam
{
    [self createBaseBussinessHeads];  
    [self createBaseBussinessHttpBody:theParam];
    //test
#ifdef DEBUG_LOG
    NSString *str = [[NSString alloc] initWithData:self.body encoding:NSUTF8StringEncoding];
    NSLog(@"send:%@\n%@",self.url, str);
#endif
    [super send];
}


@end
