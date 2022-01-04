//
//  VehiclePartModule.m
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehiclePartModule.h"

@implementation VehiclePartModule
-(id)initWithDic:( NSDictionary*)dic
{
    if (self=[super init]) {
        
    }
    return self;
}
-(void)getCondition
{
    [self creatBusinessWithId:BUSINESS_VEHICLE_GETCONDITION andExecuteWithData:nil];
}
@end
