//
//  GetCommandStatusBusiness.m
//  G-NetLink
//
//  Created by a95190 on 15/11/18.
//  Copyright © 2015年 95190. All rights reserved.
//

#import "GetCommandStatusBusiness.h"

@implementation GetCommandStatusBusiness

- (id)init
{
    if (self = [super initWithNtspHeader]) {
        self.businessId = BUSINESS_VEHICLE_GETCOMMAND_CONDITION;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/command/query11"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    return self;
}


@end
