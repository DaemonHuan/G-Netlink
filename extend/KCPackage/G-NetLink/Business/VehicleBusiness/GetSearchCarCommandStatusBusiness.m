//
//  GetSearchCarCommandStatus.m
//  G-NetLink
//
//  Created by 95190 on 14/12/23.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "GetSearchCarCommandStatusBusiness.h"

@implementation GetSearchCarCommandStatusBusiness

-(id)init
{
    if (self = [super initWithNtspHeader]) {
        self.businessId = BUSINESS_VEHICLE_REMOTESEARCHCAR;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/Command/QueryStatus"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    
    return self;
}
@end
