//
//  SetNotificationRead.m
//  G-NetLink
//
//  Created by jayden on 14-4-22.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "SetNotificationReadBusiness.h"

@implementation SetNotificationReadBusiness
-(id)init
{
    if (self = [super initWithNtspHeader]) {
        self.businessId = BUSINESS_NOTIFICATIONNEWS_READ;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/sendmsg/hasread"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    
    return self;
}
@end
