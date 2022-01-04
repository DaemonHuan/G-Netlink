//
//  CommandMsg.m
//  G-NetLink
//
//  Created by a95190 on 15/11/18.
//  Copyright © 2015年 95190. All rights reserved.
//

#import "CommandMsg.h"

@implementation CommandMsg

-(id)initWithDic:(NSDictionary *)dic
{
    if (self=[super init]) {
        _uuid = [dic objectForKey:@"uuid"];
        _tuid = [dic objectForKey:@"tuid"];
        _cmdType = [dic objectForKey:@"command"];
        _sendState = [[dic objectForKey:@"send_state"] integerValue];
        _sendTime = [dic objectForKey:@"send_time"];
        _executeState = [[dic objectForKey:@"execute_state"] integerValue];
        _executeDesc = [dic objectForKey:@"execute_desc"];
    }
    return self;
}

@end
