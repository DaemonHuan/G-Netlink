//
//  VehicleDiagnosisReport.m
//  G-NetLink
//
//  Created by 95190 on 14-10-9.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleDiagnosisReport.h"
#import "BusinessFactory.h"
#import "DiagnosisMsg.h"

@implementation VehicleDiagnosisReport

-(void)getLatestDiagnosisReport
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"0" forKey:@"start"];
    [dict setObject:@"1" forKey:@"rows"];
    
    baseBusiness = [BusinessFactory createBusiness:BUSINESS_VEHICLE_DIAGNOSISREPORT];
    baseBusiness.businessObserver = self;
    [baseBusiness execute:dict];
}

-(void)reReportDiagnosis
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@(INSTANT),@"",DIAGNOSIS_ALL_COMMAND,CLIENT_VERSION] forKeys:@[@"isInstant",@"content",@"type",@"version"]];
    [self creatBusinessWithId:BUSINESS_VEHICLE_REPORT_CONDITION andExecuteWithData:dic];
}

- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary*)businessData
{
    if(business.businessId == BUSINESS_VEHICLE_DIAGNOSISREPORT)
    {
        NSDictionary *data = [businessData objectForKey:@"data"];
        _diagnosisMsg = [[DiagnosisMsg alloc] initWithDict:data];
    }

    [super didBusinessSucess:business withData:businessData];
}
@end
