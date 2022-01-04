//
//  VehicleLocation.m
//  G-NetLink
//
//  Created by a95190 on 14-10-9.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleLocation.h"
#import "LocationInfo.h"

@implementation VehicleLocation

- (id)init
{
    if (self = [super init]) {

    }
    return self;
}

- (void)getLocation
{
    [self creatBusinessWithId:BUSINESS_VEHICLE_GETLOCATION andExecuteWithData:nil];
}

- (void)reReportLocation
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@(INSTANT),@"",RP_LOCAL_COMMAND,CLIENT_VERSION] forKeys:@[@"isInstant",@"content",@"type",@"version"]];
    [self creatBusinessWithId:BUSINESS_VEHICLE_REPORT_CONDITION andExecuteWithData:dic];
}

- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary *)businessData
{
    if (business.businessId == BUSINESS_VEHICLE_GETLOCATION) {
        
        NSDictionary *data = [businessData objectForKey:@"data"];
        
        _locaInfo = [[LocationInfo alloc] initWithDict:data];
    }
    
    [super didBusinessSucess:business withData:businessData];
}

@end
