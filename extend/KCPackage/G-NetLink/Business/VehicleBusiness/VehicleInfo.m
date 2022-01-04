//
//  VehicleInfo.m
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleInfo.h"

@implementation VehicleInfo
-(void)getInfo
{
    [self creatBusinessWithId:BUSINESS_GETUSERINFO andExecuteWithData:nil];
}

#pragma mark - BusinessProtocl
- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary*)businessData
{
    if(business.businessId == BUSINESS_GETUSERINFO)
    {
        NSDictionary *data=[businessData objectForKey:@"data"];
        _vehNo=[data objectForKey:@"veh_no"];
        _frameNo=[data objectForKey:@"frame_no"];
        _vehicleType=[data objectForKey:@"vehicle_type"];
        _bodyColor=[data objectForKey:@"body_color"];
        _salesName=[data objectForKey:@"sales_name"];
        _salesAddress=[data objectForKey:@"sales_address"];
        _salesPhone=[data objectForKey:@"sales_phone"];
    }
    [super didBusinessSucess:business withData:businessData];
}
@end
