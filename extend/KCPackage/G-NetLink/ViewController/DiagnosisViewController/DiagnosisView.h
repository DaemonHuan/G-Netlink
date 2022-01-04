//
//  DiagnosisView.h
//  G-NetLink
//
//  Created by 95190 on 14-10-15.
//  Copyright (c) 2014年 95190. All rights reserved.
//

@protocol DiagnosisViewDelegate <NSObject>
-(void)stopDiagnoseDelegate;
@end

#import "TitleBarView.h"
#import "DiagnoseTurntableView.h"
#import "AttributedLabel.h"
#import "BaseCustomMessageBox.h"

@interface DiagnosisView : TitleBarView

@property(nonatomic,readonly)DiagnoseTurntableView *diagnoseTurntableView;
@property(nonatomic,readonly)UIButton *btn_acu;
@property(nonatomic,readonly)UIButton *btn_tpms;
@property(nonatomic,readonly)UIButton *btn_ems;
@property(nonatomic,readonly)UIButton *btn_eps;
@property(nonatomic,readonly)UIButton *btn_esp;
@property(nonatomic,readonly)UIButton *btn_pas;
@property(nonatomic,readonly)UIButton *btn_peps;
@property(nonatomic,readonly)UIButton *btn_acc;
@property(nonatomic,readonly)UIButton *btn_lde;
@property(nonatomic,readonly)UIButton *btn_tcu;
@property(nonatomic,readonly)UIButton *btn_bcm_light;
@property(nonatomic,readonly)UIButton *btn_Diagnosis_time;
@property(nonatomic,readonly)UILabel *lbl_vehNo;
-(void)startDiagnose;
-(void)stopDiagnose;
@property( nonatomic)id<DiagnosisViewDelegate>delegate;
@end
