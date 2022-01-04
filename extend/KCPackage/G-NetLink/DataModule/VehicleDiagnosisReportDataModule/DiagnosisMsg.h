//
//  DiagnosisMsg.h
//  G-NetLink
//
//  Created by 95190 on 14-10-9.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"

@interface DiagnosisMsg : BaseDataModule

@property (nonatomic,readonly)NSString  *acu_status;
@property (nonatomic,readonly)NSString  *tpms_status;
@property (nonatomic,readonly)NSString  *ems_status;
@property (nonatomic,readonly)NSString  *eps_status;
@property (nonatomic,readonly)NSString  *esp_status;
@property (nonatomic,readonly)NSString  *pas_status;
@property (nonatomic,readonly)NSString  *peps_status;
@property (nonatomic,readonly)NSString  *acc_status;
@property (nonatomic,readonly)NSString  *lde_status;
@property (nonatomic,readonly)NSString  *tcu_status;
@property (nonatomic,readonly)NSString  *bcm_light_status;
@property (nonatomic,readonly)NSString  *diagnosis_time;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
