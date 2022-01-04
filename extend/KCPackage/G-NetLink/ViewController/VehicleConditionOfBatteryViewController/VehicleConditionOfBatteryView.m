//
//  VehicleConditionOfBatteryView.m
//  G-NetLink
//
//  Created by jayden on 14-5-6.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleConditionOfBatteryView.h"

@interface VehicleConditionOfBatteryView()
{
    UILabel *infoLable;
    UIImageView *statusImageView;
}
@end

@implementation VehicleConditionOfBatteryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"VehicleConditionTitle", Res_String, @"");
        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
//        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_home",Res_Image,@"")];
         _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"btn_refresh",Res_Image,@"")];
        
        _customTitleBar.backgroundImage = nil;
        _lbl_recordTime = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_customTitleBar.frame) - 5, self.frame.size.width, 20)];
        _lbl_recordTime.textAlignment = NSTextAlignmentCenter;
        _lbl_recordTime.font = [UIFont systemFontOfSize:12];
        _lbl_recordTime.textColor = [UIColor whiteColor];
        _lbl_recordTime.backgroundColor = [UIColor clearColor];
        [self addSubview:_lbl_recordTime];
        
        UIImageView *lineView0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnosis_middle_line",Res_Image,@"")]];
        lineView0.frame = CGRectMake(0, _customTitleBar.frame.size.height + 20, self.bounds.size.width, 1);
        [self addSubview:lineView0];
        
        UIImage *image = [UIImage imageNamed:NSLocalizedStringFromTable(@"vehicle_control_back",Res_Image,@"")];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(5,5,image.size.height-10,image.size.width-10)]];
        backgroundImageView.contentMode    = UIViewContentModeScaleToFill;
        backgroundImageView.userInteractionEnabled = YES;
        CGRect backgroundImageViewFrame = backgroundImageView.frame;
        backgroundImageViewFrame.size.width = self.bounds.size.width;
        backgroundImageViewFrame.size.height = self.bounds.size.height;
        backgroundImageView.frame = backgroundImageViewFrame;
        [self insertSubview:backgroundImageView atIndex:0];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
//        UIImageView *bottomitemImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-image.size.height,image.size.width , image.size.height)];
        UIImageView *bottomitemImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-image.size.height, self.bounds.size.width, image.size.height)];
        bottomitemImageView.image=image;
        bottomitemImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomitemImageView];
        
        UIView *centerView=[[UIView alloc] initWithFrame:CGRectMake(0, _customTitleBar.frame.origin.y+_customTitleBar.frame.size.height, self.frame.size.width, self.frame.size.height-_customTitleBar.frame.size.height-bottomitemImageView.frame.size.height)];
         [self addSubview:centerView];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"conditon_battery_lower",Res_Image,@"")];
        statusImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, centerView.frame.size.height/2-image.size.height/2,self.bounds.size.width , image.size.height)];
        statusImageView.image=image;
        [centerView addSubview:statusImageView];
        
       infoLable=[[UILabel alloc] initWithFrame:CGRectMake(5, centerView.frame.size.height-82.5,self.bounds.size.width-10, 50)];
        infoLable.backgroundColor=[UIColor clearColor];
        infoLable.numberOfLines = 0;
        infoLable.font=[UIFont systemFontOfSize:20];
        infoLable.textColor=[UIColor whiteColor];
        infoLable.textAlignment=NSTextAlignmentCenter;
        
         [centerView addSubview:infoLable];

    }
    return self;
}

-(void)setBatteryStatus:(enum BatteryStatusEnum)batteryStatus
{
    _batteryStatus=batteryStatus;
    UIImage *image;
    if (batteryStatus) {
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"conditon_battery_ok",Res_Image,@"")];
        infoLable.text=NSLocalizedStringFromTable(@"BatteryInfoNormal",Res_String,@"") ;
    }else{
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"conditon_battery_lower",Res_Image,@"")];
         infoLable.text=NSLocalizedStringFromTable(@"BatteryInfoLower",Res_String,@"") ;
    }
    statusImageView.image=image;
}

-(void)setBatteryValue:(double)batteryValue
{
    _batteryValue=batteryValue;
    infoLable.text=[NSString stringWithFormat:infoLable.text ,batteryValue];
    NSLog(@"%@",infoLable.text);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
