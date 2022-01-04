//
//  DiagnosisMsg.m
//  G-NetLink
//
//  Created by 95190 on 14-10-9.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "DiagnosisMsg.h"

@implementation DiagnosisMsg
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        if (dict != nil && (NSNull *)dict != [NSNull null])
        {
            _acu_status = [dict objectForKey:@"acu_status"];
            _tpms_status = [dict objectForKey:@"tpms_status"];
            _ems_status = [dict objectForKey:@"ems_status"];
            _eps_status = [dict objectForKey:@"eps_status"];
            _esp_status = [dict objectForKey:@"esp_status"];
            _pas_status = [dict objectForKey:@"pas_status"];
            _peps_status = [dict objectForKey:@"peps_status"];
            _acc_status = [dict objectForKey:@"acc_status"];
            _lde_status = [dict objectForKey:@"lde_status"];
            _tcu_status = [dict objectForKey:@"tcu_status"];
            _bcm_light_status = [dict objectForKey:@"bcm_light_status"];
            _diagnosis_time = [dict objectForKey:@"diagnosis_time"];
        }
    }
    return self;
}

@end
