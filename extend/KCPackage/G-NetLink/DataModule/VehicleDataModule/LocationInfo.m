//
//  LocationInfo.m
//  G-NetLink
//
//  Created by a95190 on 14-10-9.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "LocationInfo.h"

@implementation LocationInfo

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        if ((NSNull *)dict == [NSNull null])
            return self;
        _lng = [dict objectForKey:@"lng"];
        _lat = [dict objectForKey:@"lat"];
        _speed = [dict objectForKey:@"speed"];
        _heading = [dict objectForKey:@"heading"];
        _alti = [dict objectForKey:@"alti"];
        _coordType = [dict objectForKey:@"coord_type"];
        _accel = [dict objectForKey:@"accel"];
        _pitch = [dict objectForKey:@"pitch"];
        _roll = [dict objectForKey:@"roll"];
        _satNum = [dict objectForKey:@"sat_num"];
        NSDictionary *geo_infoDic= [dict objectForKey:@"geo_info"];
        _region = [geo_infoDic objectForKey:@"region"];
        _province = [geo_infoDic objectForKey:@"province"];
        _city = [geo_infoDic objectForKey:@"city"];
        _sublocality = [geo_infoDic objectForKey:@"sublocality"];
        _postAddress = [geo_infoDic objectForKey:@"post_address"];
        _rawAddress = [dict objectForKey:@"raw_address"];
        _gpsTimestamp = [dict objectForKey:@"gps_timestamp"];
        _recordTimestamp = [dict objectForKey:@"record_timestamp"];
        //时间戳转日期 (秒数转日期)
        NSString *timeStamp2 = _recordTimestamp;
        long long int date1 = (long long int)[timeStamp2 intValue];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
        //时间转换
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _recordTimestamp = [dateFormatter stringFromDate:date2];
    }
    
    return self;
}

@end
