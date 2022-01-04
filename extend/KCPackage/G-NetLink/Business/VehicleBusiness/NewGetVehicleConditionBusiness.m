//
//  NewGetVehicleConditionBusiness.m
//  
//
//  Created by a95190 on 15/11/2.
//
//

#import "NewGetVehicleConditionBusiness.h"

@implementation NewGetVehicleConditionBusiness

- (id)init
{
    if (self = [super initWithNtspHeader]) {
        self.businessId = BUSINESS_VEHICLE_GETCONDITION;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/condition/query11"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    return self;
}

@end
