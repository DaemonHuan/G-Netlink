//
//  GetVehicleOperateHistoryBusiness.m
//  G-NetLink
//
//  Created by jayden on 14-4-17.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "GetVehicleOperateHistoryBusiness.h"

@implementation GetVehicleOperateHistoryBusiness
-(id)init
{
    if (self = [super initWithNtspHeader]) {
        self.businessId = BUSINESS_VEHICLE_GETOPERATEHISTORY;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/command/query11"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    
    return self;
}
@end
