//
//  UserCommitFeedbackBusiness.m
//  G-NetLink
//
//  Created by jayden on 14-4-14.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserCommitFeedbackBusiness.h"

@implementation UserCommitFeedbackBusiness
-(id)init
{
    if (self = [super initWithNtspHeader]){
        self.businessId = BUSINESS_COMMITFEEDBACK;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/feedbackinfo/add"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    return self;
}
@end
