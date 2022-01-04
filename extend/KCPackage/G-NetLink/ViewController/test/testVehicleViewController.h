//
//  testVehicleViewController.h
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseViewController.h"
#import "Vehicle.h"
#import "VehicleLocation.h"
#import "VehicleDiagnosisReport.h"
#import "VerifyCode.h"

@interface testVehicleViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *btnCloseWindow;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseDormer;
@property (weak, nonatomic) IBOutlet UIButton *btnLockDoor;
@property(nonatomic,readonly)Vehicle *vehicle;
@property (nonatomic,readonly) VehicleLocation *vehicleLocaiton;
@property (nonatomic,readonly) VehicleDiagnosisReport *diagnosisReport;
@property (nonatomic,readonly) VerifyCode *verifyCode;
- (IBAction)btn_closewindow_click:(id)sender;
- (IBAction)btn_closeDormer_click:(id)sender;
- (IBAction)btn_lockDoor_click:(id)sender;
- (IBAction)btn_getHistory_click:(id)sender;
- (IBAction)btn_getLocation_click:(id)sender;
- (IBAction)btn_back_click:(id)sender;
- (IBAction)btn_getdiagnosisreport_click:(id)sender;
- (IBAction)btn_getverifycode_click:(id)sender;
@end
