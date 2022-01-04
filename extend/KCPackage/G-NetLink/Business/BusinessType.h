//
//  BusinessType.h
//  ZhiJiaX
//
//  Created by 95190 on 13-4-8.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#ifndef G_NetLink_BusinessType_h
#define G_NetLink_BusinessType_h

enum BusinessType
{
    BUSINESS_LOGIN = 0,
    BUSINESS_LOGOUT,
    BUSINESS_COMMITFEEDBACK,
    BUSINESS_GETUSERINFO,
    BUSINESS_UPDATEUSERINFO,
    BUSINESS_LOGINCOUNT,
    BUSINESS_PHONENUMBERGET,
    BUSINESS_PHONENUMBERBINDING,
    BUSINESS_PHONENUMBERREMOVE,
    
    BUSINESS_VEHICLE_GETCONDITION=100,
    BUSINESS_VEHICLE_SENDCOMMAND,
    BUSINESS_VEHICLE_REPORT_CONDITION,
    BUSINESS_VEHICLE_GETCOMMAND_CONDITION,
    BUSINESS_VEHICLE_GETOPERATEHISTORY,
    BUSINESS_VEHICLE_GETLOCATION,
    BUSINESS_VEHICLE_DIAGNOSISREPORT,
    BUSINESS_VEHICLE_REMOTESEARCHCAR,
    
    BUSINESS_NOTIFICATIONNEWS_QUERY=200,
    BUSINESS_NOTIFICATIONNEWS_DELETE,
    BUSINESS_NOTIFICATIONNEWS_READ,
    BUSINESS_NOTIFICATIONNEWS_COUNT_QUERY,
    BUSINESS_NOTIFICATIONNEWS_DETAIL,
    
    BUSINESS_OTHER_CLIENTVERSION=300,
    BUSINESS_OTHER_SENDVERIFYCODE,
    
    BUSINESS_DOWNLOADFILE = 9999,
    BUSINESS_NONE = 10000
};

#endif
