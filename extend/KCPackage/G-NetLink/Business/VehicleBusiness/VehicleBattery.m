//
//  VehicleBattery.m
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleBattery.h"

@interface VehicleBattery()
{
    
}
-(void)fillDataFromDic:(NSDictionary*)dic;
@end

@implementation VehicleBattery
-(id)initWithDic:( NSDictionary*)dic
{
    if(self=[super initWithDic:dic])
    {
        [self fillDataFromDic:dic];
    }
    return self;
}
-(void)fillDataFromDic:(NSDictionary*)dic
{
    _batteryVoltageStatus=[[dic objectForKey:@"battery_voltage"] boolValue];
}
- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary*)businessData
{
    if (business.businessId==BUSINESS_VEHICLE_GETCONDITION) {
        NSDictionary *data=[businessData objectForKey:@"data"];
        [self fillDataFromDic:[data objectForKey:@"battery"]];
    }
    
    [super didBusinessSucess:business withData:businessData];
}
@end
