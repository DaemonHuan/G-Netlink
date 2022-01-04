//
//  GetNotificationDetailBusiness.m
//  G-NetLink
//
//  Created by 95190 on 14-11-4.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "GetNotificationDetailBusiness.h"

@implementation GetNotificationDetailBusiness

-(id)init
{
    if (self = [super initWithNtspHeader]) {
        self.businessId = BUSINESS_NOTIFICATIONNEWS_DETAIL;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/sendmsg/querydetail"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    
    return self;
}
@end
