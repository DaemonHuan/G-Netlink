//
//  LocationInfo.h
//  G-NetLink
//
//  Created by a95190 on 14-10-9.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"

@interface LocationInfo : BaseDataModule

@property (nonatomic,readonly) NSString *lng;
@property (nonatomic,readonly) NSString *lat;
@property (nonatomic,readonly) NSString *speed;
@property (nonatomic,readonly) NSString *heading;
@property (nonatomic,readonly) NSString *alti;
@property (nonatomic,readonly) NSString *coordType;
@property (nonatomic,readonly) NSString *accel;
@property (nonatomic,readonly) NSString *pitch;
@property (nonatomic,readonly) NSString *roll;
@property (nonatomic,readonly) NSString *satNum;
@property (nonatomic,readonly) NSString *region;
@property (nonatomic,readonly) NSString *province;
@property (nonatomic,readonly) NSString *city;
@property (nonatomic,readonly) NSString *sublocality;
@property (nonatomic,readonly) NSString *postAddress;
@property (nonatomic,readonly) NSString *rawAddress;
@property (nonatomic,readonly) NSString *gpsTimestamp;
@property (nonatomic,readonly) NSString *recordTimestamp;

- (id)initWithDict:(NSDictionary *)dict;

@end
