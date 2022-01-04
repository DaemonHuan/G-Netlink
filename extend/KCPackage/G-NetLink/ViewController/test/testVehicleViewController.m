//
//  testVehicleViewController.m
//  G-NetLink
//
//  Created by jayden on 14-4-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "testVehicleViewController.h"

@interface testVehicleViewController ()

@end

@implementation testVehicleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewControllerId = VIEWCONTROLLER_TEST2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _vehicle=[[Vehicle alloc]init];
    _vehicleLocaiton = [[VehicleLocation alloc] init];
    _vehicleLocaiton.observer = self;
    _vehicle.observer=self;
    [_vehicle getCondition];
    
    _diagnosisReport = [[VehicleDiagnosisReport alloc]init];
    _diagnosisReport.observer = self;
    [_diagnosisReport getLatestDiagnosisReport];
    
    _verifyCode = [[VerifyCode alloc]init];
    _verifyCode.observer = self;
    // Do any additional setup after loading the view from its nib.
}


-(void)didDataModuleNoticeSucess:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    [super didDataModuleNoticeSucess:baseDataModule forBusinessType:businessID];
    
    if (businessID==BUSINESS_VEHICLE_GETCONDITION) {
        _btnCloseWindow.enabled=YES;
        _btnCloseDormer.enabled=YES;
        _btnLockDoor.enabled=YES;
    } else if (businessID == BUSINESS_VEHICLE_GETLOCATION) {
        NSLog(@"%@",_vehicleLocaiton.locaInfo);
    }
    else if (businessID == BUSINESS_VEHICLE_DIAGNOSISREPORT) {
        NSLog(@"%@",_diagnosisReport.diagnosisMsg);
    }
    else if (businessID == BUSINESS_OTHER_SENDVERIFYCODE) {
        NSLog(@"%@",baseDataModule);
    }
    
}

-(void)didDataModuleNoticeFail:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID forErrorCode:(int)errorCode forErrorMsg:(NSString *)errorMsg
{
    [super didDataModuleNoticeFail:baseDataModule forBusinessType:businessID forErrorCode:errorCode forErrorMsg:errorMsg];
    
    if (businessID==BUSINESS_VEHICLE_GETCONDITION) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%d",errorCode] message:errorMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if (businessID==BUSINESS_VEHICLE_GETOPERATEHISTORY){
        NSLog(@"%@",_vehicle.vehicleOperateHistory);
    } else if (businessID == BUSINESS_VEHICLE_GETLOCATION) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%d",errorCode] message:errorMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if (businessID == BUSINESS_VEHICLE_DIAGNOSISREPORT) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%d",errorCode] message:errorMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if (businessID == BUSINESS_OTHER_SENDVERIFYCODE) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%d",errorCode] message:errorMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_closewindow_click:(id)sender
{
    [_vehicle.windows closeDormer:@"1000" withPin:@"0222"];
}

- (IBAction)btn_closeDormer_click:(id)sender
{
    [_vehicle.windows closeDormer:@"1111" withPin:@"1111"];
}

- (IBAction)btn_lockDoor_click:(id)sender
{
    [_vehicle.doors lock:@"1111" withPin:@"1111"];
}

- (IBAction)btn_getHistory_click:(id)sender
{
    [_vehicle.vehicleOperateHistory getHistoryRecordsWithDate:@"2014-01-01" forPageindex:1 forPagesize:20];
}

- (IBAction)btn_getLocation_click:(id)sender {
    [_vehicleLocaiton getLocation];
}

- (IBAction)btn_back_click:(id)sender
{
    Message *message = [[Message alloc] init];
    message.sendObjectID = _viewControllerId;
    message.commandID = MC_CREATE_PUSHFROMRIGHT_VIEWCONTROLLER;
    message.receiveObjectID=VIEWCONTROLLER_TEST1;
    [self sendMessage:message];
}

- (IBAction)btn_getdiagnosisreport_click:(id)sender {
    [_diagnosisReport getLatestDiagnosisReport];
}

- (IBAction)btn_getverifycode_click:(id)sender {
    [_verifyCode getVerifyCode];
}
@end
