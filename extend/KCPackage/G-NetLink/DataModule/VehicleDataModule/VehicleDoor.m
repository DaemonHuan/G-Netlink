//
//  VehicleDoor.m
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleDoor.h"

@interface VehicleDoor()
{
    
}
-(void)fillDataFromDic:(NSDictionary*)dic;
@end

@implementation VehicleDoor
-(id)initWithDic:( NSDictionary*)dic
{
    if(self=[super initWithDic:dic])
    {
        [self fillDataFromDic:dic];
    }
    return self;
}
-(void)fillDataFromDic:(NSDictionary*)dic
{
    _doorStatus=  [[dic objectForKey:@"door_status"] intValue];
    _driverDoorStatus=[[dic objectForKey:@"driver_door_status"] intValue];
    _copilotDoorStatus= [[dic objectForKey:@"copilot_door_status"] intValue];
    _realRightDoorStatus=[[dic objectForKey:@"real_right_door_status"] intValue];
    _realLeftDoorStatus=[[dic objectForKey:@"real_left_door_status"] intValue];
    _trunkStatus=[[dic objectForKey:@"trunk_status"] intValue];
}
-(void)lock:(NSString*)code withPin:(NSString*)pin
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@(INSTANT),@"",LOCK_DOOR_COMMAND,CLIENT_VERSION] forKeys:@[@"isInstant",@"content",@"type",@"version"]];

    [self creatBusinessWithId:BUSINESS_VEHICLE_SENDCOMMAND andExecuteWithData:dic];
}

#pragma mark - BusinessProtocl
- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary*)businessData
{
    if (business.businessId==BUSINESS_VEHICLE_GETCONDITION) {
        NSDictionary *data=[businessData objectForKey:@"data"];
        [self fillDataFromDic:[data objectForKey:@"doorand_trunk"]];
    } else if (business.businessId == BUSINESS_VEHICLE_SENDCOMMAND) {
        NSDictionary *data=[businessData objectForKey:@"data"];
        self.msgId = [data objectForKey:@"msg_id"];
    }
    [super didBusinessSucess:business withData:businessData];
}
@end
