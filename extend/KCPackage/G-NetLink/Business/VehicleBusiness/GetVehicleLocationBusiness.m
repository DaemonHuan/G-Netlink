//
//  GetVehicleLocationBusiness.m
//  G-NetLink
//
//  Created by a95190 on 14-10-9.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "GetVehicleLocationBusiness.h"

@implementation GetVehicleLocationBusiness

- (id)init
{
    if (self = [super initWithNtspHeader]) {
        self.businessId = BUSINESS_VEHICLE_GETLOCATION;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/location/query"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    return self;
}

@end
