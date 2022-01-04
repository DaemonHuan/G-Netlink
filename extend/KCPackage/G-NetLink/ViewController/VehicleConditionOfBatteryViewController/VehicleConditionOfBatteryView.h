//
//  VehicleConditionOfBatteryView.h
//  G-NetLink
//
//  Created by jayden on 14-5-6.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarView.h"
enum BatteryStatusEnum
{
    StatusLower,
    StatusNormal
};
@interface VehicleConditionOfBatteryView : TitleBarView
@property(nonatomic)enum BatteryStatusEnum batteryStatus;
@property(nonatomic)double batteryValue;
@property(nonatomic,readonly) UILabel *lbl_recordTime;
@end
