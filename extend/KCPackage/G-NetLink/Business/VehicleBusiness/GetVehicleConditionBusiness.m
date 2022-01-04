//
//  GetVehicleCondition.m
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "GetVehicleConditionBusiness.h"

@implementation GetVehicleCondition
-(id)init
{
    if (self = [super initWithNtspHeader]) {
        self.businessId = BUSINESS_VEHICLE_GETCONDITION;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/condition/query"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    
    return self;
}
@end
