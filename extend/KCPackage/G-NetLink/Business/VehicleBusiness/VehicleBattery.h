//
//  VehicleBattery.h
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehiclePartModule.h"

@interface VehicleBattery : VehiclePartModule
@property(nonatomic,assign,readonly)BOOL batteryVoltageStatus;
-(id)initWithDic:( NSDictionary*)dic;
@end
