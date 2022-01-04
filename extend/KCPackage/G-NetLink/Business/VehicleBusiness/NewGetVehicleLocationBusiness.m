//
//  NewGetVehicleLocationBusiness.m
//  
//
//  Created by a95190 on 15/11/2.
//
//

#import "NewGetVehicleLocationBusiness.h"

@implementation NewGetVehicleLocationBusiness

- (id)init
{
    if (self = [super initWithNtspHeader]) {
        self.businessId = BUSINESS_VEHICLE_GETLOCATION;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/location/query11"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    return self;
}

@end
