//
//  DiagnosisView.m
//  G-NetLink
//
//  Created by 95190 on 14-10-15.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "DiagnosisView.h"

@implementation DiagnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _customTitleBar.titleText = NSLocalizedStringFromTable(@"remoteDiagnosis_title",Res_String,@"");
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"btn_refresh",Res_Image,@"")];
        
        _customTitleBar.backgroundImage = nil;
        _lbl_vehNo = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100, CGRectGetMaxY(_customTitleBar.frame) - 5, 200, 20)];
        _lbl_vehNo.textAlignment = NSTextAlignmentCenter;
        _lbl_vehNo.font = [UIFont systemFontOfSize:12];
        _lbl_vehNo.textColor = [UIColor whiteColor];
        _lbl_vehNo.backgroundColor = [UIColor clearColor];
        [self addSubview:_lbl_vehNo];
        
        UIImageView *lineView0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_middle_line",Res_Image,@"")]];
        lineView0.frame = CGRectMake(0, _customTitleBar.frame.size.height + 20, self.bounds.size.width, 1);
        [self addSubview:lineView0];
        
        double turntableBackgroundHeight = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_faultInfo_cell_background",Res_Image,@"")].size.height;
        
        UIView *turntableBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, _customTitleBar.bounds.size.height + 21, self.bounds.size.width, turntableBackgroundHeight)];
        turntableBackgroundView.backgroundColor = [UIColor colorWithRed:35.0f/255.0f green:44.0f/255.0f blue:61.0f/255.0f alpha:1];
        [self addSubview:turntableBackgroundView];
        
        _diagnoseTurntableView = [[DiagnoseTurntableView alloc] initWithPoint:CGPointMake(self.bounds.size.width/2, turntableBackgroundView.frame.origin.y + turntableBackgroundView.frame.size.height/2 - 10)];
        [self addSubview:_diagnoseTurntableView];
        
        UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_middle_line",Res_Image,@"")]];
        lineView.frame = CGRectMake(0, CGRectGetMaxY(_diagnoseTurntableView.frame) - 50, self.bounds.size.width, 1);
        [self addSubview:lineView];
        
        double imageWidth = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_acu_normal",Res_Image,@"")].size.height;
        double btn_width = self.bounds.size.width / 6;
        
        UIImage *image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_acu_normal",Res_Image,@"")];
        NSString *title = NSLocalizedStringFromTable(@"ACU",Res_String,@"");
        double textWidth = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
        _btn_acu = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_acu.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), btn_width, btn_width + 20);
        [_btn_acu setImage:image forState:UIControlStateNormal];
        _btn_acu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_acu.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btn_acu setImageEdgeInsets:UIEdgeInsetsMake(10, (btn_width - imageWidth) / 2, 0, 0)];
        [_btn_acu setTitleEdgeInsets:UIEdgeInsetsMake(imageWidth + 15, (btn_width - textWidth) / 2  -  imageWidth, 0, 0)];
        [_btn_acu addTarget:self action:@selector(acu_btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btn_acu setTitle:title forState:UIControlStateNormal];
        _btn_acu.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn_acu.userInteractionEnabled = NO;
        [self addSubview:_btn_acu];
        
        image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_tpms2_normal",Res_Image,@"")];
        title = NSLocalizedStringFromTable(@"TPMS",Res_String,@"");
        textWidth = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
        _btn_tpms = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_tpms.frame = CGRectMake(btn_width, CGRectGetMaxY(lineView.frame), btn_width, btn_width + 20);
        [_btn_tpms setImage:image forState:UIControlStateNormal];
        _btn_tpms.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_tpms.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btn_tpms setImageEdgeInsets:UIEdgeInsetsMake(10, (btn_width - imageWidth) / 2, 0, 0)];
        [_btn_tpms setTitleEdgeInsets:UIEdgeInsetsMake(imageWidth + 15, (btn_width - textWidth) / 2  -  imageWidth, 0, 0)];
        [_btn_tpms setTitle:title forState:UIControlStateNormal];
        [_btn_tpms addTarget:self action:@selector(tpms_btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn_tpms.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn_tpms.userInteractionEnabled = NO;
        [self addSubview:_btn_tpms];
        
        image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_ems_normal",Res_Image,@"")];
        title = NSLocalizedStringFromTable(@"EMS",Res_String,@"");
        textWidth = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
        _btn_ems = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_ems.frame = CGRectMake(btn_width * 2, CGRectGetMaxY(lineView.frame), btn_width, btn_width + 20);
        [_btn_ems setImage:image forState:UIControlStateNormal];
        _btn_ems.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_ems.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btn_ems setImageEdgeInsets:UIEdgeInsetsMake(10, (btn_width - imageWidth) / 2, 0, 0)];
        [_btn_ems setTitleEdgeInsets:UIEdgeInsetsMake(imageWidth + 15, (btn_width - textWidth) / 2  -  imageWidth, 0, 0)];
        [_btn_ems setTitle:title forState:UIControlStateNormal];
        [_btn_ems addTarget:self action:@selector(ems_btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn_ems.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn_ems.userInteractionEnabled = NO;
        [self addSubview:_btn_ems];
        
        image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_eps_normal",Res_Image,@"")];
        title = NSLocalizedStringFromTable(@"EPS",Res_String,@"");
        textWidth = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
        _btn_eps = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_eps.frame = CGRectMake(btn_width * 3, CGRectGetMaxY(lineView.frame), btn_width, btn_width + 20);
        [_btn_eps setImage:image forState:UIControlStateNormal];
        _btn_eps.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_eps.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btn_eps setImageEdgeInsets:UIEdgeInsetsMake(10, (btn_width - imageWidth) / 2, 0, 0)];
        [_btn_eps setTitleEdgeInsets:UIEdgeInsetsMake(imageWidth + 15, (btn_width - textWidth) / 2  -  imageWidth, 0, 0)];
        [_btn_eps setTitle:title forState:UIControlStateNormal];
        [_btn_eps addTarget:self action:@selector(eps_btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn_eps.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn_eps.userInteractionEnabled = NO;
        [self addSubview:_btn_eps];
        
        image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_esp_normal",Res_Image,@"")];
        title = NSLocalizedStringFromTable(@"ESP",Res_String,@"");
        textWidth = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
        _btn_esp = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_esp.frame = CGRectMake(btn_width * 4, CGRectGetMaxY(lineView.frame), btn_width, btn_width + 20);
        [_btn_esp setImage:image forState:UIControlStateNormal];
        _btn_esp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_esp.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btn_esp setImageEdgeInsets:UIEdgeInsetsMake(10, (btn_width - imageWidth) / 2, 0, 0)];
        [_btn_esp setTitleEdgeInsets:UIEdgeInsetsMake(imageWidth + 15, (btn_width - textWidth) / 2  -  imageWidth, 0, 0)];
        [_btn_esp setTitle:title forState:UIControlStateNormal];
        [_btn_esp addTarget:self action:@selector(esp_btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn_esp.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn_esp.userInteractionEnabled = NO;
        [self addSubview:_btn_esp];
        
        image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_pas_normal",Res_Image,@"")];
        title = NSLocalizedStringFromTable(@"PAS",Res_String,@"");
        textWidth = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
        _btn_pas = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_pas.frame = CGRectMake(btn_width * 5, CGRectGetMaxY(lineView.frame), btn_width, btn_width + 20);
        [_btn_pas setImage:image forState:UIControlStateNormal];
        _btn_pas.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_pas.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btn_pas setImageEdgeInsets:UIEdgeInsetsMake(10, (btn_width - imageWidth) / 2, 0, 0)];
        [_btn_pas setTitleEdgeInsets:UIEdgeInsetsMake(imageWidth + 15, (btn_width - textWidth) / 2  -  imageWidth, 0, 0)];
        [_btn_pas setTitle:title forState:UIControlStateNormal];
        [_btn_pas addTarget:self action:@selector(pas_btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn_pas.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn_pas.userInteractionEnabled = NO;
        [self addSubview:_btn_pas];
        
        image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_peps_normal",Res_Image,@"")];
        title = NSLocalizedStringFromTable(@"PEPS",Res_String,@"");
        textWidth = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
        _btn_peps = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_peps.frame = CGRectMake(0, CGRectGetMaxY(_btn_acu.frame), btn_width, btn_width + 20);
        [_btn_peps setImage:image forState:UIControlStateNormal];
        _btn_peps.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_peps.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btn_peps setImageEdgeInsets:UIEdgeInsetsMake(10, (btn_width - imageWidth) / 2, 0, 0)];
        [_btn_peps setTitleEdgeInsets:UIEdgeInsetsMake(imageWidth + 15, (btn_width - textWidth) / 2  -  imageWidth, 0, 0)];
        [_btn_peps setTitle:title forState:UIControlStateNormal];
        [_btn_peps addTarget:self action:@selector(peps_btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn_peps.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn_peps.userInteractionEnabled = NO;
        [self addSubview:_btn_peps];
        
        image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_acc_normal",Res_Image,@"")];
        title = NSLocalizedStringFromTable(@"ACC",Res_String,@"");
        textWidth = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
        _btn_acc = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_acc.frame = CGRectMake(btn_width, CGRectGetMaxY(_btn_acu.frame), btn_width, btn_width + 20);
        [_btn_acc setImage:image forState:UIControlStateNormal];
        _btn_acc.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_acc.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btn_acc setImageEdgeInsets:UIEdgeInsetsMake(10, (btn_width - imageWidth) / 2, 0, 0)];
        [_btn_acc setTitleEdgeInsets:UIEdgeInsetsMake(imageWidth + 15, (btn_width - textWidth) / 2  -  imageWidth, 0, 0)];
        [_btn_acc setTitle:title forState:UIControlStateNormal];
        [_btn_acc addTarget:self action:@selector(acc_btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn_acc.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn_acc.userInteractionEnabled = NO;
        [self addSubview:_btn_acc];
        
        image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_ldw_normal",Res_Image,@"")];
        title = NSLocalizedStringFromTable(@"LDW",Res_String,@"");
        textWidth = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
        _btn_lde = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_lde.frame = CGRectMake(btn_width * 2, CGRectGetMaxY(_btn_acu.frame), btn_width, btn_width + 20);
        [_btn_lde setImage:image forState:UIControlStateNormal];
        _btn_lde.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_lde.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btn_lde setImageEdgeInsets:UIEdgeInsetsMake(10, (btn_width - imageWidth) / 2, 0, 0)];
        [_btn_lde setTitleEdgeInsets:UIEdgeInsetsMake(imageWidth + 15, (btn_width - textWidth) / 2  -  imageWidth, 0, 0)];
        [_btn_lde setTitle:title forState:UIControlStateNormal];
        [_btn_lde addTarget:self action:@selector(ldw_btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn_lde.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn_lde.userInteractionEnabled = NO;
        [self addSubview:_btn_lde];
        
        image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_tcu_normal",Res_Image,@"")];
        title = NSLocalizedStringFromTable(@"TCU",Res_String,@"");
        textWidth = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
        _btn_tcu = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_tcu.frame = CGRectMake(btn_width * 3, CGRectGetMaxY(_btn_acu.frame), btn_width, btn_width + 20);
        [_btn_tcu setImage:image forState:UIControlStateNormal];
        _btn_tcu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_tcu.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btn_tcu setImageEdgeInsets:UIEdgeInsetsMake(10, (btn_width - imageWidth) / 2, 0, 0)];
        [_btn_tcu setTitleEdgeInsets:UIEdgeInsetsMake(imageWidth + 15, (btn_width - textWidth) / 2  -  imageWidth, 0, 0)];
        [_btn_tcu setTitle:title forState:UIControlStateNormal];
        [_btn_tcu addTarget:self action:@selector(tcu_btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn_tcu.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn_tcu.userInteractionEnabled = NO;
        [self addSubview:_btn_tcu];
        
        image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_bcm_normal",Res_Image,@"")];
        title = NSLocalizedStringFromTable(@"BCM",Res_String,@"");
        textWidth = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
        _btn_bcm_light = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_bcm_light.frame = CGRectMake(btn_width * 4, CGRectGetMaxY(_btn_acu.frame), btn_width, btn_width + 20);
        [_btn_bcm_light setImage:image forState:UIControlStateNormal];
        _btn_bcm_light.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_bcm_light.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btn_bcm_light setImageEdgeInsets:UIEdgeInsetsMake(10, (btn_width - imageWidth) / 2, 0, 0)];
        [_btn_bcm_light setTitleEdgeInsets:UIEdgeInsetsMake(imageWidth + 15, (btn_width - textWidth) / 2  -  imageWidth, 0, 0)];
        [_btn_bcm_light setTitle:title forState:UIControlStateNormal];
        [_btn_bcm_light addTarget:self action:@selector(bcm_btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn_bcm_light.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn_bcm_light.userInteractionEnabled = NO;
        [self addSubview:_btn_bcm_light];
    }
    return self;
}

-(void)startDiagnose
{
    _customTitleBar.userInteractionEnabled = NO;
    [_diagnoseTurntableView startAnimation];
}

- (void)alertMessageWithMessageBoxText:(NSString *)Msg
{
    NSString *Message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"DiagnosisErrorTip",Res_String,@""),Msg];
    BaseCustomMessageBox *baseCustomMessageBox = nil;
    baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:Message forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
    baseCustomMessageBox.animation = YES;
    baseCustomMessageBox.autoCloseTimer = 5.0;
    [[UIApplication sharedApplication].keyWindow addSubview:baseCustomMessageBox];
}

-(void)stopDiagnose
{
    _customTitleBar.userInteractionEnabled = YES;
    if (self.delegate)
    {
        [self.delegate stopDiagnoseDelegate];
    }
}

- (void)acu_btn_OnClick:(UIButton *)acu_btn
{
    [self alertMessageWithMessageBoxText:NSLocalizedStringFromTable(@"ACUERROR",Res_String,@"")];
}

- (void)tpms_btn_OnClick:(UIButton *)tpms_btn
{
    [self alertMessageWithMessageBoxText:NSLocalizedStringFromTable(@"TPMSERROR",Res_String,@"")];
}

- (void)ems_btn_OnClick:(UIButton *)ems_btn
{
    [self alertMessageWithMessageBoxText:NSLocalizedStringFromTable(@"EMSERROR",Res_String,@"")];
}

- (void)eps_btn_OnClick:(UIButton *)eps_btn
{
    [self alertMessageWithMessageBoxText:NSLocalizedStringFromTable(@"EPSERROR",Res_String,@"")];
}

- (void)esp_btn_OnClick:(UIButton *)esp_btn
{
    [self alertMessageWithMessageBoxText:NSLocalizedStringFromTable(@"ESPERROR",Res_String,@"")];
}

- (void)pas_btn_OnClick:(UIButton *)pas_btn
{
    [self alertMessageWithMessageBoxText:NSLocalizedStringFromTable(@"PASERROR",Res_String,@"")];
}

- (void)peps_btn_OnClick:(UIButton *)peps_btn
{
    [self alertMessageWithMessageBoxText:NSLocalizedStringFromTable(@"PEPSERROR",Res_String,@"")];
}

- (void)acc_btn_OnClick:(UIButton *)acc_btn
{
    [self alertMessageWithMessageBoxText:NSLocalizedStringFromTable(@"ACCERROR",Res_String,@"")];
}

- (void)ldw_btn_OnClick:(UIButton *)ldw_btn
{
    [self alertMessageWithMessageBoxText:NSLocalizedStringFromTable(@"LDWERROR",Res_String,@"")];
}

- (void)tcu_btn_OnClick:(UIButton *)tcu_btn
{
    [self alertMessageWithMessageBoxText:NSLocalizedStringFromTable(@"TCUERROR",Res_String,@"")];
}

- (void)bcm_btn_OnClick:(UIButton *)bcm_btn
{
    [self alertMessageWithMessageBoxText:NSLocalizedStringFromTable(@"BCMERROR",Res_String,@"")];
}

-(void)dealloc
{
    _diagnoseTurntableView.delegate = nil;
}

@end
