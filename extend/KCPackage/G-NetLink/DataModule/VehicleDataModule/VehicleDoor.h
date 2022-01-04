//
//  VehicleDoor.h
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehiclePartModule.h"
enum DoorsGlobalStatus
{
    UNKNOWN=-1,
    ALL_CLOSED_AND_LOCKED=0,
    ALL_CLOSED_WITHOUT_LOCKED,
    ONE_OR_MORE_OPENED,
    ALL_CLOSED_WITH_UNKNOWN_LOCK_STATUS,
};

enum DoorsStatus
{
    DOOR_UNKNOWN=-1,
    DOOR_CLOSED_AND_LOCKED=0,
    DOOR_CLOSED_WITHOUT_LOCKED,
    DOOR_OPENED,
    DOOR_CLOSED_WITH_UNKNOWN_LOCK_STATUS,
};

@interface VehicleDoor : VehiclePartModule
@property(nonatomic,assign,readonly) enum DoorsGlobalStatus doorStatus;
@property(nonatomic,assign,readonly) enum DoorsStatus driverDoorStatus;
@property(nonatomic,assign,readonly) enum DoorsStatus copilotDoorStatus;
@property(nonatomic,assign,readonly) enum DoorsStatus realRightDoorStatus;
@property(nonatomic,assign,readonly) enum DoorsStatus realLeftDoorStatus;
@property(nonatomic,assign,readonly) enum DoorsStatus trunkStatus;
@property (nonatomic,copy) NSString *msgId;
-(id)initWithDic:( NSDictionary*)dic;
@end
