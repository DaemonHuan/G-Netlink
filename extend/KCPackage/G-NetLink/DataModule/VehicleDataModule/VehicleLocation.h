//
//  VehicleLocation.h
//  G-NetLink
//
//  Created by a95190 on 14-10-9.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"
#import "LocationInfo.h"
#import "VehiclePartModule.h"

@interface VehicleLocation : BaseDataModule

@property (nonatomic,readonly)LocationInfo *locaInfo;

- (void)getLocation;
- (void)reReportLocation;

@end
