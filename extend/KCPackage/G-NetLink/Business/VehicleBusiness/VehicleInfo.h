//
//  VehicleInfo.h
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"

@interface VehicleInfo : BaseDataModule
@property(nonatomic,readonly) NSString *vehNo;
@property(nonatomic,readonly) NSString *frameNo;
@property(nonatomic,readonly) NSString *vehicleType;
@property(nonatomic,readonly) NSString *bodyColor;
@property(nonatomic,readonly) NSString *salesName;
@property(nonatomic,readonly) NSString *salesAddress;
@property(nonatomic,readonly) NSString *salesPhone;
-(void)getInfo;
@end
