//
//  VehicleOperateHistoryRecord.h
//  G-NetLink
//
//  Created by jayden on 14-4-17.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"

@interface VehicleOperateHistoryRecord : BaseDataModule
@property(nonatomic,copy,readonly)  NSString *uuid;
@property(nonatomic,copy,readonly)  NSString *tuid;
@property(nonatomic,copy,readonly)  NSString *cmdType;
@property(nonatomic,assign,readonly) NSInteger sendState;
@property(nonatomic,copy,readonly)  NSString *sendTime;
@property(nonatomic,assign,readonly) NSInteger executeState;
@property(nonatomic,copy,readonly) NSString *executeDesc;

-(id)initWithDic:(NSDictionary *)dic;
@end
