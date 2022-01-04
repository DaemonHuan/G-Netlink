//
//  VehicleCommandStatus.m
//  G-NetLink
//
//  Created by 95190 on 14/12/23.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleCommandStatus.h"

@implementation VehicleCommandStatus

-(id)initWithDic:( NSDictionary*)dic
{
    if (self=[super init]) {
        [self fillDataFromDic:dic];
    }
    return self;
}
-(void)fillDataFromDic:(NSDictionary*)dic
{
    if((NSNull *)dic[@"seek_car_status"]!=[NSNull null] && dic[@"seek_car_status"] != nil)
        _carCammandStatus = [dic[@"seek_car_status"] intValue];
    else
        _carCammandStatus = Command_UNKNOWN;
    
    if((NSNull *)dic[@"status_desc"]!=[NSNull null] && dic[@"status_desc"] != nil)
        _statusDesc = dic[@"status_desc"];
    else
        _statusDesc = @"";

}
@end
