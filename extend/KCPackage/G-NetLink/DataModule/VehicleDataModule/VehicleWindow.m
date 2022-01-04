//
//  VehicleWindow.m
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleWindow.h"

@interface VehicleWindow()
{
    
}
-(void)fillDataFromDic:(NSDictionary*)dic;
@end

@implementation VehicleWindow
-(id)initWithDic:( NSDictionary*)dic
{
    if (self=[super initWithDic:dic]) {
        [self fillDataFromDic:dic];
    }
    return self;
}
-(void)fillDataFromDic:(NSDictionary*)dic
{
    _sunroofStatus=[[dic objectForKey:@"sunroof_status"] intValue];
    _driverWindowStatus=[[dic objectForKey:@"driver_window_status"] intValue];
    _copilotWindowStatus=[[dic objectForKey:@"copilot_window_status"] intValue];
    _rearRightWindowStatus=[[dic objectForKey:@"rear_right_window_status"] intValue];
    _rearLeftWindowStatus=[[dic objectForKey:@"rear_left_window_status"] intValue];
}

#pragma mark - VehicleOperateInterface
- (void)close:(NSString*)code withPin:(NSString*)pin
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@(INSTANT),@"",CLOSE_WINDOW_COMMAND,CLIENT_VERSION] forKeys:@[@"isInstant",@"content",@"type",@"version"]];
    
    [self creatBusinessWithId:BUSINESS_VEHICLE_SENDCOMMAND andExecuteWithData:dic];
}

-(void)closeDormer:(NSString*)code withPin:(NSString*)pin
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@(INSTANT),@"",CLOSE_DORMER_COMMAND,code,pin,CLIENT_VERSION] forKeys:@[@"isInstant",@"content",@"type",@"verify_code",@"pin",@"version"]];
    
    [self creatBusinessWithId:BUSINESS_VEHICLE_SENDCOMMAND andExecuteWithData:dic];
}


#pragma mark - BusinessProtocl
- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary*)businessData
{
    if (business.businessId==BUSINESS_VEHICLE_GETCONDITION) {
        NSDictionary *data=[businessData objectForKey:@"data"];
        [self fillDataFromDic:[data objectForKey:@"window"]];
    } else if (business.businessId == BUSINESS_VEHICLE_SENDCOMMAND) {
        NSDictionary *data=[businessData objectForKey:@"data"];
        self.msgId = [data objectForKey:@"msg_id"];
    }
    
    [super didBusinessSucess:business withData:businessData];
}
@end
