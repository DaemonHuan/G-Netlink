//
//  Location.m
//  ZhiJiaX
//
//  Created by jishu on 13-4-18.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "Location.h"
#import "BusinessFactory.h"
#import <CoreLocation/CLLocationManager.h>

@interface Location()
{
    MBGpsLocation *_gpsLocation;
    MBPoint _point;
}
@end

@implementation Location

- (void)requestLocation
{
    _locationStatus = YES;
    _gpsLocation = [[MBGpsLocation alloc] init];
    _gpsLocation.delegate = self;
    [_gpsLocation startUpdatingLocation];
}
-(void)didGpsDisconnected
{
    if(self.observer!=nil)
        [self.observer didGpsDisconnected];
}
- (void)didGpsInfoUpdated:(MBGpsInfo*)info
{
    //在此获得所得到的gps信息
    _point = info.pos;
    NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
	
	[date_formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *locationtime = [date_formater stringFromDate:[NSDate date]];
    
    NSDictionary * localInfoDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%d",_point.x],@"lon",
                                       [NSString stringWithFormat:@"%d",_point.y],@"lat",
                                       [NSString stringWithFormat:@"%d",info.altitude],@"height",
                                       locationtime,@"locationtime",
                                       [NSString stringWithFormat:@"%d",info.speed],@"speed",
                                       [NSString stringWithFormat:@"%d",info.ori],@"direction",
                                       @"A",@"star",
                                       @"2",@"type",
                                       nil];
    
    LocationInfomation *locationInfo = [[LocationInfomation alloc] initWithDic:localInfoDic];
    
    if(self.observer!=nil)
        [self.observer didGetCurrentGpsInfo:locationInfo];
}
-(void)close
{
    _locationStatus = NO;
    _gpsLocation.delegate = nil;
    [_gpsLocation stopUpdatingLocation];
}
+(BOOL)checkLocationServer
{
    if([CLLocationManager locationServicesEnabled])
    {
        if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
            return YES;
    }
    return NO;
}

- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary*)businessData
{

    [super didBusinessSucess:business withData:businessData];
}

@end