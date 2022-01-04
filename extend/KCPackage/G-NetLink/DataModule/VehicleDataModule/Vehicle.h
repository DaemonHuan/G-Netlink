//
//  Vehicle.h
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"
#import "VehicleWindow.h"
#import "VehicleDoor.h"
#import "VehicleBattery.h"
#import "VehicleInfo.h"
#import "VehicleOperateHistory.h"
#import "VehicleCommandStatus.h"
#import "CommandMsg.h"

typedef enum {
    SendState_Wait_Handle = 0,
    SendState_Wait_Send = 1,
    SendState_Sending = 2,
    SendState_Send_Success = 5,
    SendState_Send_Fail = 9
}SendState;

typedef enum {
    ExecuteState_Wait_Handle = 0,
    ExecuteState_Execute_Success,
    ExecuteState_Execute_Fail,
    ExecuteState_Execute_TimeOut
}ExecuteState;

@interface Vehicle : BaseDataModule
@property(nonatomic,readonly) VehicleWindow *windows;
@property(nonatomic,readonly) VehicleDoor *doors;
@property(nonatomic,readonly) VehicleBattery *batterys;
@property(nonatomic,readonly) VehicleInfo *vehicleInfo;
@property(nonatomic,readonly) VehicleOperateHistory *vehicleOperateHistory;
@property(nonatomic,readonly) NSString *record_timestamp;
@property(nonatomic,readonly) VehicleCommandStatus *vehicleCommandStatus;
@property(nonatomic,readonly) CommandMsg *commandMsg;
@property(nonatomic,readonly) SendState sendStats;
@property(nonatomic,readonly) NSInteger cmdNumber;
@property(nonatomic,readonly) ExecuteState executeState;
@property(nonatomic,copy) NSString *msgId;

-(void)getCondition;
-(void)getCommandConditionWithMsgId:(NSString *)msgId;
-(void)doubleFlashAndWhistle:(NSString*)code withPin:(NSString*)pin;
-(void)getRemoteSearchCarCommandStatus;
-(void)reReportCondition;
@end
