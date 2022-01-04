//
//  VehicleOperateHistory.m
//  G-NetLink
//
//  Created by jayden on 14-4-17.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleOperateHistory.h"
#import "VehicleOperateHistoryRecord.h"
@interface VehicleOperateHistory()
{
    int pageSize;
}
@end
@implementation VehicleOperateHistory

-(id)init
{
    if(self=[super init]){
        _historyRecords=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)getHistoryRecordsWithDate:(NSString *)date forPageindex:(int)pageindex forPagesize:(int)pagesize
{
    pageSize=pagesize;
    
    NSDictionary *dic;
    if (date == nil || [date  isEqual: @""]) {
        dic = [NSDictionary dictionaryWithObjects:@[@(pageindex * pagesize),@(pagesize)] forKeys:@[@"start",@"rows"]];
    } else {
        dic = [NSDictionary dictionaryWithObjects:@[@(pageindex * pagesize),@(pagesize),date] forKeys:@[@"start",@"rows",@"send_time"]];
//        dic = [NSDictionary dictionaryWithObjects:@[@(pageindex * pagesize),@(pagesize)] forKeys:@[@"start",@"rows"]];
    }
    
    [self creatBusinessWithId:BUSINESS_VEHICLE_GETOPERATEHISTORY andExecuteWithData:dic];
}

#pragma mark - BusinessProtocl
- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary*)businessData
{
    if (business.businessId==BUSINESS_VEHICLE_GETOPERATEHISTORY) {
        
        [_historyRecords removeAllObjects];
        
        NSDictionary *data=[businessData objectForKey:@"data"];
        _allcount=[[data objectForKey:@"cmd_num"] intValue];
        _pagecount=ceil(_allcount*1.0/pageSize );
        NSArray *records=[data objectForKey:@"cmd_list"];
        if ((NSNull *)records!=[NSNull null]) {
            [records enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                VehicleOperateHistoryRecord *record=[[VehicleOperateHistoryRecord alloc] initWithDic:obj];
                [_historyRecords addObject:record];
            }];
        }
        
    }
    
    [super didBusinessSucess:business withData:businessData];
    
}
@end
