//
//  VehicleControlView.m
//  G-NetLink
//
//  Created by jayden on 14-4-24.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleControlView.h"
#import "StripCustomMessageBox.h"
@interface VehicleControlView()
{
    UILabel *tipLable;
    UIButton *closeTipBtn;
    UIImageView *lightImageView;
    UIImageView *keyLightImageView;
    UIButton *btn_key;
    StripCustomMessageBox *stripCustomMessageBox;
    UIButton *vehicleLightBtn;
}
-(IBAction)keyButtonClick:(id)sender;
-(IBAction)keyButtonLongPressGesture:(UILongPressGestureRecognizer *)sender;
@end
@implementation VehicleControlView
@synthesize tipLable = tipLable,closeTipBtn = closeTipBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        tipLable = [[UILabel alloc] init];
        tipLable.text = NSLocalizedStringFromTable(@"Tip_txt",Res_String,@"");
        tipLable.textAlignment = NSTextAlignmentCenter;
        tipLable.font = [UIFont systemFontOfSize:15];
        tipLable.textColor = [UIColor whiteColor];
        tipLable.numberOfLines = 0;
        tipLable.backgroundColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
        tipLable.frame = CGRectMake(0, 60, 280, 40);
        tipLable.alpha = 0.0;
        [self addSubview:tipLable];
        
        CGFloat tipLabelMaxX = CGRectGetMaxX(tipLable.frame);
        //close_tip_btn
        closeTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeTipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        closeTipBtn.contentMode = UIViewContentModeScaleToFill;
        [closeTipBtn setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"close_tip_btn",Res_Image,@"")] forState:UIControlStateNormal];
        [closeTipBtn setBackgroundColor:[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1]];
        closeTipBtn.frame = CGRectMake(tipLabelMaxX, tipLable.frame.origin.y, self.bounds.size.width - tipLabelMaxX, tipLable.frame.size.height);
        closeTipBtn.alpha = 0.0;
        [closeTipBtn addTarget:self action:@selector(closeVehicleTip_onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeTipBtn];
        
        
        [UIView animateWithDuration:1.0 animations:^{
            closeTipBtn.alpha = 1.0;
            tipLable.alpha = 1.0;
        }];
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"VehicleControlTitle", Res_String, @"");
        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"",Res_Image,@"")];
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_history",Res_Image,@"")];
        
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
        
        UIImage *image = [UIImage imageNamed:NSLocalizedStringFromTable(@"vehicle_control_back",Res_Image,@"")];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"car",Res_Image,@"")];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-image.size.width/2-20, self.frame.size.height/2-image.size.height/2,image.size.width , image.size.height)];
        imageView.image=image;
        [self addSubview:imageView];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"light_all_sucess",Res_Image,@"")];
        lightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-image.size.width/2-20, self.frame.size.height/2-image.size.height/2,image.size.width , image.size.height)];
        lightImageView.image=image;
        lightImageView.alpha=0.0;
        [self addSubview:lightImageView];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"btn_key_back_select_success",Res_Image,@"")];
        keyLightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-image.size.width+13, imageView.frame.origin.y+15,image.size.width , image.size.height)];
        keyLightImageView.image=image;
        keyLightImageView.alpha=0.0;
        [self addSubview:keyLightImageView];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"btn_key_back_normal",Res_Image,@"")];
        btn_key=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-image.size.width+13, imageView.frame.origin.y+15,image.size.width , image.size.height)];
        [btn_key setImage:image forState:UIControlStateNormal];
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"btn_key_back_select",Res_Image,@"")];
        [btn_key setImage:image forState:UIControlStateHighlighted];
         [btn_key addTarget:self action:@selector(keyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(keyButtonLongPressGesture:)];
        longPressGesture.minimumPressDuration=2;
        [btn_key addGestureRecognizer:longPressGesture];
        [self addSubview:btn_key];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"vehicleLight_normal",Res_Image,@"")];
        vehicleLightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [vehicleLightBtn setBackgroundImage:image forState:UIControlStateNormal];
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"vehicleLight_highlight",Res_Image,@"")];
        [vehicleLightBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        vehicleLightBtn.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        vehicleLightBtn.center = CGPointMake((self.bounds.size.width * 0.5), self.bounds.size.height - 50);
        [vehicleLightBtn setTitleColor:[UIColor colorWithRed:252/255.0 green:243/255.0 blue:131/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        vehicleLightBtn.contentHorizontalAlignment = UIViewContentModeScaleAspectFit;
        [vehicleLightBtn addTarget:self action:@selector(lightButton_onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:vehicleLightBtn];
        
        
        CGRect backPlaneRect = [UIScreen mainScreen].bounds;
        _backPlance = [[UIView alloc] init];
        _backPlance.backgroundColor = [UIColor blackColor];
        _backPlance.alpha = 0.4;
        _backPlance.frame = backPlaneRect;
        _backPlance.hidden = YES;
        [self addSubview:_backPlance];

    }
    return self;
}

- (void)closeTip
{
//    [tipLable removeFromSuperview];
//    [closeTipBtn removeFromSuperview];
    [self.eventObserver closeTipDelegate];
}

- (void)closeVehicleTip_onClick:(id)sender
{
    [self closeTip];
}

-(void)keyButtonClick:(id)sender
{
    [self closeTip];
    _currentType = CurrentType_Doors;
    [_eventObserver performSelector:@selector(keyButton_onClick:) withObject:nil];
    btn_key.userInteractionEnabled = NO;
    [self  performSelector:@selector(btn_keyTouch) withObject:self afterDelay:2.7];
}
-(void)btn_keyTouch
{
    btn_key.userInteractionEnabled = YES;
}
-(IBAction)keyButtonLongPressGesture:(UILongPressGestureRecognizer *)sender
{
    [self closeTip];
    if (sender.state == UIGestureRecognizerStateBegan) {
        _currentType = CurrentType_Windows;
        [_eventObserver performSelector:@selector(keyButton_longPressGesture:) withObject:nil];
    }
}

- (void)lightButton_onClick:(UIButton *)sender
{
    _currentType = CurrentType_LightHorn;
    if ([_eventObserver respondsToSelector:@selector(lightButtonOnClick:)]) {
        [_eventObserver performSelector:@selector(lightButtonOnClick:) withObject:nil];
    }
}

-(void)setIsSuccess:(BOOL)isSuccess
{
    _isSuccess=isSuccess;
    if (isSuccess) {
        [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseInOut animations:^{
            [UIView setAnimationRepeatCount:2.5];
            lightImageView.alpha=1.0;
            keyLightImageView.alpha=1.0;
        } completion:^(BOOL finished) {
            lightImageView.alpha = 0.0;
            keyLightImageView.alpha = 0.0;
        }];
    }
}

@end
