//
//  VehicleCommandStatus.h
//  G-NetLink
//
//  Created by 95190 on 14/12/23.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"

enum CommandStatus
{
    Command_UNKNOWN = 0,
    Command_CAN_DO,
    Command_NOT_CAN_DO,
};

@interface VehicleCommandStatus : BaseDataModule

@property(nonatomic,assign,readonly) enum CommandStatus carCammandStatus;
@property(nonatomic,copy) NSString *statusDesc;

-(id)initWithDic:( NSDictionary*)dic;
@end
