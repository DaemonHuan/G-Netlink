//
//  VehiclePartModule.h
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"

#define CLOSE_WINDOW_COMMAND @("CLOSE-WINDOW")
#define LOCK_DOOR_COMMAND @("CLOSE-DOOR")
#define CLOSE_DORMER_COMMAND @("CLOSE-DORMER")
#define RP_LOCAL_COMMAND @("RP-LOCAL")
#define RP_VEH_CON_COMMAND @("RP-VEH-CON")
#define DIAGNOSIS_ALL_COMMAND @("DIAGNOSIS-ALL")
#define SEEK_CAR_COMMAND @("SEEK-CAR")

enum IsInstant
{
    UNINSTANT,
    INSTANT,
};
@protocol VehicleOperateInterface <NSObject>
@optional
- (void)open:(NSString*)code withPin:(NSString*)pin;
- (void)close:(NSString*)code withPin:(NSString*)pin;
- (void)lock:(NSString*)code withPin:(NSString*)pin;
- (void)unlock:(NSString*)code withPin:(NSString*)pin;
@end

@interface VehiclePartModule : BaseDataModule<VehicleOperateInterface>

-(id)initWithDic:( NSDictionary*)dic;
-(void)getCondition;
@end
