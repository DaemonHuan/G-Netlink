//
//  LocationInfo.m
//  ZhiJiaX
//
//  Created by jishu on 13-4-18.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "LocationInfomation.h"

@implementation LocationInfomation

- (id)init
{
    if (self = [super init])
    {
        _longitude = @"";
        _latitude = @"";
        _height = @"";
        _localedtime = @"";
        _speed = @"";
        _direction = @"";
        _star = @"";
        _descriptionInfo = @"";
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    LocationInfomation *new = [[[self class] allocWithZone: zone]init];
    new->_longitude = [self.longitude copyWithZone:zone];
    new->_latitude = [self.latitude copyWithZone:zone];
    new->_height = [self.height copyWithZone:zone];
    new->_localedtime = [self.localedtime copyWithZone:zone];
    new->_speed = [self.speed copyWithZone:zone];
    new->_direction = [self.direction copyWithZone:zone];
    new->_star = [self.star copyWithZone:zone];
    new->_descriptionInfo = [self.description copyWithZone:zone];
    new.localedType = self.localedType;
    
    return new;
}


- (id)initWithDic:(NSDictionary *)locationDicInfo
{
    self = [super init];
    
    if((NSNull *)locationDicInfo != [NSNull null] && locationDicInfo != nil)
    {
        if((NSNull *)[locationDicInfo objectForKey:@"lon"] != [NSNull null] && [locationDicInfo objectForKey:@"lon"] != nil)
        {
            if([[locationDicInfo objectForKey:@"lon"] isKindOfClass:[NSNumber class]])
                _longitude = [NSString stringWithFormat:@"%g",[[locationDicInfo objectForKey:@"lon"] doubleValue]];
            else
                _longitude = [locationDicInfo objectForKey:@"lon"];
        }
        else
            _longitude = @"";
        
        if((NSNull *)[locationDicInfo objectForKey:@"lat"] != [NSNull null] && [locationDicInfo objectForKey:@"lat"] != nil)
        {
            if([[locationDicInfo objectForKey:@"lat"] isKindOfClass:[NSNumber class]])
                _latitude = [NSString stringWithFormat:@"%g",[[locationDicInfo objectForKey:@"lat"] doubleValue]];
            else
                _latitude = [locationDicInfo objectForKey:@"lat"];
        }
        else
            _latitude = @"";
        
        if((NSNull *)[locationDicInfo objectForKey:@"height"] != [NSNull null] && [locationDicInfo objectForKey:@"height"] != nil)
            _height = [locationDicInfo objectForKey:@"height"];
        else
            _height = @"";
        
        if((NSNull *)[locationDicInfo objectForKey:@"locationtime"] != [NSNull null] && [locationDicInfo objectForKey:@"locationtime"] != nil)
            _localedtime = [locationDicInfo objectForKey:@"locationtime"];
        else
            _localedtime = @"";
        
        if((NSNull *)[locationDicInfo objectForKey:@"speed"] != [NSNull null] && [locationDicInfo objectForKey:@"speed"] != nil)
            _speed = [locationDicInfo objectForKey:@"speed"];
        else
            _speed = @"";
        
        if((NSNull *)[locationDicInfo objectForKey:@"direction"] != [NSNull null] && [locationDicInfo objectForKey:@"direction"] != nil)
            _direction = [locationDicInfo objectForKey:@"direction"];
        else
            _direction = @"";
        
        if((NSNull *)[locationDicInfo objectForKey:@"star"] != [NSNull null] && [locationDicInfo objectForKey:@"star"] != nil)
            _star = [locationDicInfo objectForKey:@"star"];
        else
            _star = @"";
        
        if((NSNull *)[locationDicInfo objectForKey:@"type"] != [NSNull null] && [locationDicInfo objectForKey:@"type"] != nil)
            _localedType = [[locationDicInfo objectForKey:@"type"] intValue];
        else
            _localedType = 0;
        
        if((NSNull *)[locationDicInfo objectForKey:@"description"] != [NSNull null] && [locationDicInfo objectForKey:@"description"] != nil)
            _descriptionInfo = [locationDicInfo objectForKey:@"description"];
        else
            _descriptionInfo = @"";
        
    }
    
    return  self;
}
-(CGPoint)convertToTubaCoordinate
{
    CGPoint point = CGPointMake(0, 0);
    if(_longitude!=nil && _longitude.length>0)
        point.x = [_longitude doubleValue]*100000;
    if(_latitude!=nil && _latitude.length>0)
        point.y = [_latitude doubleValue]*100000;
    return point;
}
+(CGPoint)convertToTubaCoordinate:(CGPoint)coordinate
{
    CGPoint point = CGPointMake(0, 0);
    
    point.x = coordinate.x*100000;
    point.y = coordinate.y*100000;
    return point;
}
- (NSDictionary *)toDic
{
    NSMutableDictionary * localInfoDic = [[NSMutableDictionary alloc] init];
    [localInfoDic setObject:self.longitude forKey:@"lon"];
    [localInfoDic setObject:self.latitude forKey:@"lat"];
    [localInfoDic setObject:self.height forKey:@"height"];
    [localInfoDic setObject:self.localedtime forKey:@"locationtime"];
    [localInfoDic setObject:self.speed forKey:@"speed"];
    [localInfoDic setObject:self.direction forKey:@"direction"];
    [localInfoDic setObject:self.star forKey:@"star"];
    [localInfoDic setObject:self.description forKey:@"description"];
    [localInfoDic setObject:[[[NSString alloc] init] stringByAppendingFormat:@"%d",self.localedType] forKey:@"type"];
    return localInfoDic;
}


@end
