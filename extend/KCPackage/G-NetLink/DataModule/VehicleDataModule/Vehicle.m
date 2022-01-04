//
//  Vehicle.m
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "Vehicle.h"


@implementation Vehicle
-(id)init
{
    if (self=[super init]) {
        _vehicleInfo=[[VehicleInfo alloc] init];
        _vehicleOperateHistory=[[VehicleOperateHistory alloc] init];
    }
    return self;
}
-(void)getCondition
{
    [self creatBusinessWithId:BUSINESS_VEHICLE_GETCONDITION andExecuteWithData:nil];
}
-(void)getCommandConditionWithMsgId:(NSString *)msgId
{
//    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *sendTime = [formater stringFromDate:[NSDate date]];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@(0),@(1)] forKeys:@[@"start",@"rows"]];
    
    if (msgId != nil && msgId.length > 0) {
        [dic setObject:msgId forKey:@"msg_id"];
    }
    
    [self creatBusinessWithId:BUSINESS_VEHICLE_GETCOMMAND_CONDITION andExecuteWithData:dic];
}
-(void)reReportCondition
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@(INSTANT),@"",RP_VEH_CON_COMMAND,CLIENT_VERSION] forKeys:@[@"isInstant",@"content",@"type",@"version"]];
    [self creatBusinessWithId:BUSINESS_VEHICLE_REPORT_CONDITION andExecuteWithData:dic];
}
- (void)getRemoteSearchCarCommandStatus
{
    [self creatBusinessWithId:BUSINESS_VEHICLE_REMOTESEARCHCAR andExecuteWithData:nil];
}
-(void)doubleFlashAndWhistle:(NSString*)code withPin:(NSString*)pin
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@(INSTANT),@"",SEEK_CAR_COMMAND,CLIENT_VERSION] forKeys:@[@"isInstant",@"content",@"type",@"version"]];
    
    [self creatBusinessWithId:BUSINESS_VEHICLE_SENDCOMMAND andExecuteWithData:dic];
}
#pragma mark - BusinessProtocl
- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary*)businessData
{
    if (business.businessId==BUSINESS_VEHICLE_GETCONDITION) {
         NSDictionary *data=[businessData objectForKey:@"data"];
        _windows=[[VehicleWindow alloc]initWithDic:[data objectForKey:@"window"]];
        _doors=[[VehicleDoor alloc]initWithDic:[data objectForKey:@"doorand_trunk"]];
        _batterys=[[VehicleBattery alloc]initWithDic:[data objectForKey:@"battery"]];
        _record_timestamp = [data objectForKey:@"record_timestamp"];
    } else if (business.businessId == BUSINESS_VEHICLE_REMOTESEARCHCAR) {
        NSDictionary *data = [businessData objectForKey:@"data"];
        _vehicleCommandStatus = [[VehicleCommandStatus alloc] initWithDic:data];
    } else if (business.businessId == BUSINESS_VEHICLE_GETCOMMAND_CONDITION) {
        NSDictionary *data = [businessData objectForKey:@"data"];
        _cmdNumber = [[data objectForKey:@"cmd_num"] integerValue];
        _commandMsg = [[CommandMsg alloc] initWithDic:[[data objectForKey:@"cmd_list"] lastObject]];
        _sendStats = _commandMsg.sendState;
        _executeState = _commandMsg.executeState;
    } else if (business.businessId == BUSINESS_VEHICLE_SENDCOMMAND) {
        NSDictionary *data = [businessData objectForKey:@"data"];
        _msgId = [data objectForKey:@"msg_id"];
    }
    
    [super didBusinessSucess:business withData:businessData];
}
@end
