//
//  DiagnosisViewController.m
//  G-NetLink
//
//  Created by 95190 on 14-10-15.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "DiagnosisViewController.h"
#import "VehicleDiagnosisReport.h"

@interface DiagnosisViewController ()
{
    DiagnosisView *diagnosisView;
    VehicleDiagnosisReport *diagnosisReport;
    UIButton *reflushBtn;
    NSTimer *requestTimer;
    NSString *tempDiagnosisTime;
    NSInteger requestIndex;
    BOOL isShowingCurrentView;
    BOOL isGetTimeStemp;
}

@end

@implementation DiagnosisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)stopDiagnoseDelegate
{
      [reflushBtn.layer removeAnimationForKey:@"rotationAnimation"];
}
- (void)loadView
{
    CGRect frame = [self createViewFrame];
    frame.size.height = frame.size.height - [UIImage imageNamed:NSLocalizedStringFromTable(@"tab_bar_background",Res_Image,@"")].size.height;
    
    diagnosisView = [[DiagnosisView alloc] initWithFrame:frame];
    reflushBtn = diagnosisView.customTitleBar.rightButton;
    
    diagnosisView.customTitleBar.buttonEventObserver = self;
    diagnosisView.diagnoseTurntableView.delegate = self;
    diagnosisView.delegate =self;
    self.view = diagnosisView;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    [reflushBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isShowingCurrentView = YES;
}

- (void)getLastDiagnosisReport
{
    if (isShowingCurrentView) {
        [diagnosisView startDiagnose];
        if (!diagnosisReport) {
            diagnosisReport = [[VehicleDiagnosisReport alloc]init];
        }
        requestIndex = 1;
        diagnosisReport.observer = self;
        [diagnosisReport getLatestDiagnosisReport];
        
        if (requestTimer == nil) {
            __block DiagnosisViewController *blockSelf = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                blockSelf->requestTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:blockSelf selector:@selector(getLastDiagnosisReportOfTimer) userInfo:nil repeats:YES] ;
                [[NSRunLoop currentRunLoop] addTimer:blockSelf->requestTimer forMode:NSDefaultRunLoopMode];
                [[NSRunLoop currentRunLoop] run];
            });
        }
    }
}

- (void)getLastDiagnosisReportOfTimer
{
    requestIndex++;
    if (!diagnosisReport) {
        diagnosisReport = [[VehicleDiagnosisReport alloc]init];
    }
    diagnosisReport.observer = self;
    [diagnosisReport getLatestDiagnosisReport];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    customActivityIndicatorView.showText = @"最新诊断信息获取中";
    [self lockView];
    isGetTimeStemp = YES;
    if (!diagnosisReport) {
        diagnosisReport = [[VehicleDiagnosisReport alloc]init];
    }
    diagnosisReport.observer = self;
    [diagnosisReport getLatestDiagnosisReport];
}

-(void)didDataModuleNoticeSucess:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    if (businessID == BUSINESS_VEHICLE_REPORT_CONDITION) {
        [self getLastDiagnosisReport];
    } else if (businessID == BUSINESS_VEHICLE_DIAGNOSISREPORT) {
        
        if (isGetTimeStemp) {
            isGetTimeStemp = NO;
            tempDiagnosisTime = diagnosisReport.diagnosisMsg.diagnosis_time;
            if (!diagnosisReport) {
                diagnosisReport = [[VehicleDiagnosisReport alloc]init];
            }
            diagnosisReport.observer = self;
            [diagnosisReport reReportDiagnosis];
        } else {
            if (requestIndex >= 15 && [tempDiagnosisTime isEqualToString:diagnosisReport.diagnosisMsg.diagnosis_time]) {
                //如果是第15次查询请求并且时间戳较第一次请求的时间戳相同，那么将弹窗提示查询超时警告
                BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:@"查询超时" forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
                baseCustomMessageBox.animation = YES;
                baseCustomMessageBox.autoCloseTimer = 1;
                [self.view addSubview:baseCustomMessageBox];
            }
            
            if((tempDiagnosisTime != nil || ![tempDiagnosisTime isEqualToString:@""]) && ![tempDiagnosisTime isEqualToString:diagnosisReport.diagnosisMsg.diagnosis_time]){
                //两次不相同
                //停止锁屏
                [self unlockViewSubtractCount];
                
                //停止定时任务
                if (requestTimer != nil) {
                    [requestTimer invalidate];
                    requestTimer = nil;
                }
            }
        }
        
        //设置数据
        diagnosisView.lbl_vehNo.text = diagnosisReport.diagnosisMsg.diagnosis_time;
        
        int status = diagnosisReport.diagnosisMsg.acu_status.intValue;
        
        if (status) {
            [diagnosisView.btn_acu setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_acu_error",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_acu.userInteractionEnabled = YES;
        } else {
            [diagnosisView.btn_acu setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_acu_normal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_acu.userInteractionEnabled = NO;
        }
        
        status = diagnosisReport.diagnosisMsg.tpms_status.intValue;
        if (status) {
            [diagnosisView.btn_tpms setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_tpms2_abnormal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_tpms.userInteractionEnabled = YES;
        } else {
            [diagnosisView.btn_tpms setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_tpms2_normal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_tpms.userInteractionEnabled = NO;
        }
        
        status = diagnosisReport.diagnosisMsg.ems_status.intValue;
        if (status) {
            [diagnosisView.btn_ems setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_ems_abnormal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_ems.userInteractionEnabled = YES;
        } else {
            [diagnosisView.btn_ems setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_ems_normal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_ems.userInteractionEnabled = NO;
        }
        
        status = diagnosisReport.diagnosisMsg.eps_status.intValue;
        if (status) {
            [diagnosisView.btn_eps setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_eps_abnormal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_eps.userInteractionEnabled = YES;
        } else {
            [diagnosisView.btn_eps setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_eps_normal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_eps.userInteractionEnabled = NO;
        }
        
        status = diagnosisReport.diagnosisMsg.esp_status.intValue;
        if (status) {
            [diagnosisView.btn_esp setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_esp_abnormal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_esp.userInteractionEnabled = YES;
        } else {
            [diagnosisView.btn_esp setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_esp_normal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_esp.userInteractionEnabled = NO;
        }
        
        status = diagnosisReport.diagnosisMsg.pas_status.intValue;
        if (status) {
            [diagnosisView.btn_pas setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_pas_abnormal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_pas.userInteractionEnabled = YES;
        } else {
            [diagnosisView.btn_pas setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_pas_normal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_pas.userInteractionEnabled = NO;
        }
        
        status = diagnosisReport.diagnosisMsg.peps_status.intValue;
        if (status) {
            [diagnosisView.btn_peps setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_peps_abnormal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_peps.userInteractionEnabled = YES;
        } else {
            [diagnosisView.btn_peps setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_peps_normal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_peps.userInteractionEnabled = NO;
        }
        
        
        status = diagnosisReport.diagnosisMsg.acc_status.intValue;
        if (status) {
            [diagnosisView.btn_acc setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_acc_error",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_acc.userInteractionEnabled = YES;
        } else {
            [diagnosisView.btn_acc setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_acc_normal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_acc.userInteractionEnabled = NO;
        }
        
        status = diagnosisReport.diagnosisMsg.lde_status.intValue;
        if (status) {
            [diagnosisView.btn_lde setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_ldw_abnormal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_lde.userInteractionEnabled = YES;
        } else {
            [diagnosisView.btn_lde setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_ldw_normal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_lde.userInteractionEnabled = NO;
        }
        
        status = diagnosisReport.diagnosisMsg.tcu_status.intValue;
        if (status) {
            [diagnosisView.btn_tcu setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_tcu_abnormal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_tcu.userInteractionEnabled = YES;
        } else {
            [diagnosisView.btn_tcu setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_tcu_normal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_tcu.userInteractionEnabled = NO;
        }
        
        status = diagnosisReport.diagnosisMsg.bcm_light_status.intValue;
        if (status) {
            [diagnosisView.btn_bcm_light setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_bcm_abnormal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_bcm_light.userInteractionEnabled = YES;
        } else {
            [diagnosisView.btn_bcm_light setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_bcm_normal",Res_Image,@"")] forState:UIControlStateNormal];
            diagnosisView.btn_bcm_light.userInteractionEnabled = NO;
        }
        
        NSLog(@"------------%d",requestIndex);
        if (requestIndex >= 15) {
            //停止锁屏
            [self unlockViewSubtractCount];
            
            //停止定时任务
            if (requestTimer != nil) {
                [requestTimer invalidate];
                requestTimer = nil;
            }
        }
    }
}

- (void)diagnoseTurntableViewAnimationDidStop
{
    [diagnosisView stopDiagnose];
}

- (void)rightButton_onClick:(id)sender
{
    requestIndex = 0;
    customActivityIndicatorView.showText = @"最新诊断信息获取中";
    [self lockView];
    isGetTimeStemp = YES;
    if (!diagnosisReport) {
        diagnosisReport = [[VehicleDiagnosisReport alloc]init];
    }
    diagnosisReport.observer = self;
    [diagnosisReport getLatestDiagnosisReport];
}

- (void)didDataModuleNoticeFail:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID forErrorCode:(int)errorCode forErrorMsg:(NSString *)errorMsg
{
    [super didDataModuleNoticeFail:baseDataModule forBusinessType:businessID forErrorCode:errorCode forErrorMsg:errorMsg];
    if (requestTimer != nil) {
        [requestTimer invalidate];
        requestTimer = nil;
    }
    
    [self stopDiagnoseDelegate];
}

-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_DIAGNOSIS;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    diagnosisReport.observer = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (requestTimer != nil) {
        [requestTimer invalidate];
        requestTimer = nil;
    }
    
    isShowingCurrentView = NO;
    requestIndex = 0;
}

@end
