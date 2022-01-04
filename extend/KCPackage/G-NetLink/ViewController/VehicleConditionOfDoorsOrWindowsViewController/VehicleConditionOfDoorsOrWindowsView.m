//
//  VehicleConditionOfDoorsOrWindowsView.m
//  G-NetLink
//
//  Created by jayden on 14-5-5.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleConditionOfDoorsOrWindowsView.h"
#import "StripCustomMessageBox.h"

@interface VehicleConditionOfDoorsOrWindowsView()
{
    UIImageView *carImageView;
    UIImageView *carLightImageView;
    UIButton *commandButton;
    StripCustomMessageBox *stripCustomMessageBox;
}

-(IBAction)commandButtonOnClick:(id)sender;
@end
@implementation VehicleConditionOfDoorsOrWindowsView

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
        // jk
//        UIImageView *bottomitemImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-image.size.height,image.size.width , image.size.height)];
        UIImageView *bottomitemImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-image.size.height, self.bounds.size.width, image.size.height)];
        bottomitemImageView.image=image;
        bottomitemImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomitemImageView];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"condition_detail_park_light",Res_Image,@"")];
        UIImageView *lightView=[[UIImageView alloc] initWithFrame:CGRectMake(0, _customTitleBar.frame.origin.y+_customTitleBar.frame.size.height+30, self.bounds.size.width, image.size.height)];
        lightView.image=image;
        [self addSubview:lightView];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"condition_detail_light_back",Res_Image,@"")];
       UIImageView *backLightView=[[UIImageView alloc] initWithFrame:CGRectMake(0, lightView.frame.origin.y-30,self.bounds.size.width , image.size.height)];
        backLightView.image=image;
        [self addSubview:backLightView];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"condition_detail_park",Res_Image,@"")];
        lightView=[[UIImageView alloc] initWithFrame:CGRectMake(0, lightView.frame.origin.y+lightView.frame.size.height/2, self.bounds.size.width, image.size.height)];
        lightView.image=image;
        [self addSubview:lightView];

        // jk
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"car_normal",Res_Image,@"")];
        carImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, lightView.frame.origin.y - 20, self.bounds.size.width, image.size.height)];
        carImageView.image=image;
         [self addSubview:carImageView];
        
        carLightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, lightView.frame.origin.y-20, self.bounds.size.width, image.size.height)];
        [self addSubview:carLightImageView];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"btn_command_normal",Res_Image,@"")];
        commandButton=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-image.size.width/2, bottomitemImageView.frame.origin.y-image.size.height-20, image.size.width, image.size.height)];
        [commandButton setImage:image forState:UIControlStateNormal];
        [commandButton addTarget:self action:@selector(commandButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commandButton];
        
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

-(void)setCarImageName:(NSString *)carImageName
{
    _carImageName=carImageName;
    UIImage *image=[UIImage imageNamed:NSLocalizedStringFromTable(carImageName,Res_Image,@"")];
    carImageView.image=image;
}

-(void)setLightImageName:(NSString *)lightImageName
{
    _lightImageName=lightImageName;
    UIImage *image=[UIImage imageNamed:NSLocalizedStringFromTable(lightImageName,Res_Image,@"")];
    carLightImageView.image=image;
    carLightImageView.alpha=0.0;
    [UIView animateWithDuration:0.8 delay:0.5 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseInOut animations:^{
        carLightImageView.alpha=1.0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setCommandButtonImageName:(NSString *)commandButtonImageName
{
    _commandButtonImageName=commandButtonImageName;
    
    if ([commandButtonImageName isEqualToString:@"btn_command_normal"]) {
        commandButton.userInteractionEnabled = NO;
    } else {
        commandButton.userInteractionEnabled = YES;
    }
    
    UIImage *image=[UIImage imageNamed:NSLocalizedStringFromTable(commandButtonImageName,Res_Image,@"")];
    [commandButton setImage:image forState:UIControlStateNormal];
}

-(IBAction)commandButtonOnClick:(id)sender
{
    [_eventObserver performSelector:@selector(commandButton_onClick:) withObject:sender];
}

-(void)setIsSuccess:(BOOL)isSuccess
{
    _isSuccess=isSuccess;
    if (isSuccess) {
        NSString *sentText;
        if (_currentType) {
            sentText=NSLocalizedStringFromTable(@"LockDoorsSent",Res_String,@"");
        }else{
            sentText=NSLocalizedStringFromTable(@"CloseWindowsSent",Res_String,@"");
        }
        sentText = NSLocalizedStringFromTable(@"DirectivesIssuedSuccess",Res_String,@"");
        stripCustomMessageBox.text=sentText;
         stripCustomMessageBox.autoCloseTimer=5;
        [self setCarImageName:@"car_normal"];
        [carLightImageView.layer removeAllAnimations];
        [self setLightImageName:@""];
        [self setCommandButtonImageName:@"btn_command_normal"];
        commandButton.userInteractionEnabled=NO;
    }
}

/*""
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
