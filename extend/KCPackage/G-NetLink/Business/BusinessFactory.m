//
//  BusinessFactory.m
//  ZhiJiaX
//
//  Created by 95190 on 13-4-8.
//  Copyright (c) 2013å¹? 95190. All rights reserved.
//

#import "BusinessFactory.h"
#import "UserLoginBusiness.h"
#import "UserLogoutBusiness.h"
#import "UserCommitFeedbackBusiness.h"
#import "UserInfoGetInfoBusiness.h"
#import "UserInfoUpdateBusiness.h"
#import "SendCommandBusiness.h"
#import "GetVehicleConditionBusiness.h"
#import "GetVehicleOperateHistoryBusiness.h"
#import "ClientVersionBusiness.h"
#import "GetNotificationListBusiness.h"
#import "GetNotificationUnreadAndReadCountBusiness.h"
#import "SetNotificationReadBusiness.h"
#import "DeleteNotificationsBusiness.h"
#import "LoginCountBusiness.h"
#import "SendVerifyCodeBusiness.h"
#import "DiagnosisReportBusiness.h"
#import "GetVehicleLocationBusiness.h"
#import "GetNotificationDetailBusiness.h"
#import "GetSearchCarCommandStatusBusiness.h"
#import "PhoneNumberGetBusiness.h"
#import "PhoneNumberBindingBusiness.h"
#import "PhoneNumberRemoveBusiness.h"

#import "NewDiagnosisReportBusiness.h"
#import "NewGetVehicleConditionBusiness.h"
#import "NewGetVehicleLocationBusiness.h"
#import "GetCommandStatusBusiness.h"
#import "ReportConditionBusiness.h"

@implementation BusinessFactory

+(id)createBusiness:(enum BusinessType)type
{
    if(type == BUSINESS_NONE)
        return nil;
    else if (type==BUSINESS_LOGIN)
    {
        return [[UserLoginBusiness alloc] init];
    }
    else if(type==BUSINESS_LOGOUT)
    {
        return [[UserLogoutBusiness alloc] init];
    }
    else if(type==BUSINESS_COMMITFEEDBACK)
    {
        return [[UserCommitFeedbackBusiness alloc] init];
    }
    else if (type==BUSINESS_GETUSERINFO)
    {
        return [[UserInfoGetInfoBusiness alloc] init];
    }
    else if (type==BUSINESS_UPDATEUSERINFO)
    {
        return [[UserInfoUpdateBusiness alloc] init];
    }
    else if (type==BUSINESS_VEHICLE_GETCONDITION)
    {
        return [[NewGetVehicleConditionBusiness alloc] init];
    }
    else if (type==BUSINESS_VEHICLE_SENDCOMMAND)
    {
        return [[SendCommandBusiness alloc] init];
    }
    else if (type==BUSINESS_VEHICLE_GETOPERATEHISTORY)
    {
        return [[GetVehicleOperateHistoryBusiness alloc] init];
    }
    else if (type == BUSINESS_VEHICLE_GETLOCATION)
    {
        return [[NewGetVehicleLocationBusiness alloc] init];
    }
    else if(type==BUSINESS_NOTIFICATIONNEWS_QUERY)
    {
         return [[GetNotificationListBusiness alloc] init];
    }
    else if(type==BUSINESS_NOTIFICATIONNEWS_COUNT_QUERY)
    {
        return [[GetNotificationUnreadAndReadCountBusiness alloc] init];
    }
    else if(type==BUSINESS_NOTIFICATIONNEWS_READ)
    {
        return [[SetNotificationReadBusiness alloc] init];
    }
    else if(type==BUSINESS_NOTIFICATIONNEWS_DELETE)
    {
        return [[DeleteNotificationsBusiness alloc] init];
    }
    else if(type==BUSINESS_OTHER_CLIENTVERSION)
    {
         return [[ClientVersionBusiness alloc] init];
    }
    else if(type==BUSINESS_LOGINCOUNT)
    {
        return [[LoginCountBusiness alloc] init];
    }
    else if(type==BUSINESS_OTHER_SENDVERIFYCODE)
    {
        return [[SendVerifyCodeBusiness alloc] init];
    }
    else if(type==BUSINESS_VEHICLE_DIAGNOSISREPORT)
    {
        return [[NewDiagnosisReportBusiness alloc] init];
    }
    else if(type==BUSINESS_NOTIFICATIONNEWS_DETAIL)
    {
        return [[GetNotificationDetailBusiness alloc] init];
    }
    else if (type==BUSINESS_VEHICLE_REMOTESEARCHCAR)
    {
        return [[GetSearchCarCommandStatusBusiness alloc] init];
    }
    else if (type==BUSINESS_PHONENUMBERGET)
    {
        return [[PhoneNumberGetBusiness alloc] init];
    }
    else if (type==BUSINESS_PHONENUMBERBINDING)
    {
        return [[PhoneNumberBindingBusiness alloc] init];
    }
    else if (type==BUSINESS_PHONENUMBERREMOVE)
    {
        return [[PhoneNumberRemoveBusiness alloc] init];
    }
    else if (type == BUSINESS_VEHICLE_GETCOMMAND_CONDITION)
    {
        return [[GetCommandStatusBusiness alloc] init];
    }
    else if (type == BUSINESS_VEHICLE_REPORT_CONDITION)
    {
        return [[ReportConditionBusiness alloc] init];
    }
    
    return nil;
    
}
@end
