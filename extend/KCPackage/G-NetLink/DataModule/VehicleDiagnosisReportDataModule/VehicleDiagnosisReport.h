//
//  VehicleDiagnosisReport.h
//  G-NetLink
//
//  Created by 95190 on 14-10-9.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"
#import "DiagnosisMsg.h"
#import "VehiclePartModule.h"

@interface VehicleDiagnosisReport : BaseDataModule

@property (nonatomic,readonly)DiagnosisMsg *diagnosisMsg;
-(void)getLatestDiagnosisReport;
-(void)reReportDiagnosis;
@end
