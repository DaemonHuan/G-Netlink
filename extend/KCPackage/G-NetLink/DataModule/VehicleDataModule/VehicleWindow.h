//
//  VehicleWindow.h
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehiclePartModule.h"

@interface VehicleWindow : VehiclePartModule
@property(nonatomic,assign,readonly) int sunroofStatus;
@property(nonatomic,assign,readonly) int driverWindowStatus;
@property(nonatomic,assign,readonly) int copilotWindowStatus;
@property(nonatomic,assign,readonly) int rearRightWindowStatus;
@property(nonatomic,assign,readonly) int rearLeftWindowStatus;
@property (nonatomic,copy) NSString *msgId;
-(id)initWithDic:( NSDictionary*)dic;
-(void)closeDormer:(NSString*)code withPin:(NSString*)pin;
@end
