//
//  VehicleOperateHistory.h
//  G-NetLink
//
//  Created by jayden on 14-4-17.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"

@interface VehicleOperateHistory : BaseDataModule
{
    @private
    NSMutableArray *_historyRecords;
}
@property(nonatomic,readonly)  NSArray *historyRecords;
@property(nonatomic,assign,readonly) int pagecount;
@property(nonatomic,assign,readonly) int recordcount;
@property(nonatomic,assign,readonly) int allcount;
-(void)getHistoryRecordsWithDate:(NSString *)date forPageindex:(int)pageindex forPagesize:(int)pagesize;
@end
