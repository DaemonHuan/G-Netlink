//
//  VehicleOperateHistoryRecord.m
//  G-NetLink
//
//  Created by jayden on 14-4-17.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleOperateHistoryRecord.h"

@implementation VehicleOperateHistoryRecord
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
