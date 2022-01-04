//
//  VehicleConditionView.m
//  G-NetLink
//
//  Created by jayden on 14-5-4.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleConditionView.h"
#import "CustomMarqueeView.h"
@interface VehicleConditionView()
{
    UIButton *windowItemButton;
    UIButton *doorItemButton;
    UIButton *powerItemButton;
    UILabel *windowStatusLable;
    UILabel *doorStatusLable;
    UILabel *powerStatusLable;
    
    CustomMarqueeView *windowInfoMarqueeView;
    CustomMarqueeView *doorInfoMarqueeView;
    CustomMarqueeView *powerInfoMarqueeView;
    
    UILabel *windowInfoLable;
    UILabel *doorInfoLable;
    UILabel *powerInfoLable;
    UIButton *refreshButton;
}
@end
@implementation VehicleConditionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"VehicleConditionTitle", Res_String, @"");
         _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_home",Res_Image,@"")];

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
        UIImageView *bottomitemImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-image.size.height,self.bounds.size.width , image.size.height)];
        bottomitemImageView.image=image;
        bottomitemImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomitemImageView];
        
        //车窗状况
        UIImage  *navBackimage=[UIImage imageNamed:NSLocalizedStringFromTable(@"history_detail_back",Res_Image,@"")];
        windowItemButton=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2-navBackimage.size.width/2, CGRectGetMaxY(lineView0.frame) +10, navBackimage.size.width, navBackimage.size.height)];
        windowItemButton.tag=1;
        [windowItemButton setBackgroundImage:navBackimage forState:UIControlStateNormal];
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"icon_window_condition",Res_Image,@"")];
        UIImageView *iconView=[[UIImageView alloc]initWithFrame:CGRectMake(10,windowItemButton.frame.size.height/2-image.size.height/2, image.size.width, image.size.height)];
        iconView.image=image;
        [windowItemButton addSubview: iconView];
        
        double iconwidth=image.size.width;
        UIImage *navImage=[UIImage imageNamed:NSLocalizedStringFromTable(@"cell_nav_logo",Res_Image,@"")];
        UILabel *titleLable=[[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.origin.x+iconView.frame.size.width+10, iconView.frame.origin.y+5, windowItemButton.frame.size.width-55-iconwidth-navImage.size.width,18)];
        titleLable.font=[UIFont systemFontOfSize:18];
        titleLable.textColor=[UIColor whiteColor];
        titleLable.text=NSLocalizedStringFromTable(@"WindowsTitle",Res_String,@"");
        titleLable.backgroundColor=[UIColor clearColor];
        [windowItemButton addSubview: titleLable];
        
        windowStatusLable=[[UILabel alloc] initWithFrame:CGRectMake(titleLable.frame.origin.x, titleLable.frame.origin.y+titleLable.frame.size.height +7.5, 50,18)];
        windowStatusLable.font=[UIFont systemFontOfSize:12];
        windowStatusLable.textColor=[UIColor whiteColor];
        windowStatusLable.textAlignment=NSTextAlignmentCenter;
        windowStatusLable.backgroundColor=[UIColor clearColor];
        [windowItemButton addSubview: windowStatusLable];

        windowInfoLable=[[UILabel alloc] init];
        windowInfoLable.font=[UIFont systemFontOfSize:14];
        windowInfoLable.textColor=[UIColor whiteColor];
        CGRect frame= windowInfoLable.frame;
        frame.size.width=[windowInfoLable.text sizeWithFont: windowInfoLable.font].width;
        frame.size.height=14;
        windowInfoLable.frame=frame;
        windowInfoLable.backgroundColor=[UIColor clearColor];
        
        windowInfoMarqueeView=[[CustomMarqueeView alloc] initWithFrame:CGRectMake(windowStatusLable.frame.origin.x, windowStatusLable.frame.origin.y+windowStatusLable.frame.size.height +7.5, titleLable.frame.size.width,14)];
        windowInfoMarqueeView.tag=101;
        windowInfoMarqueeView.backgroundColor=[UIColor clearColor];
        windowInfoMarqueeView.contentViews=@[windowInfoLable];
        
        UIImageView *navView=[[UIImageView alloc] initWithFrame:CGRectMake(titleLable.frame.origin.x+titleLable.frame.size.width+20, windowItemButton.frame.size.height/2-navImage.size.height/2, navImage.size.width, navImage.size.height)];
        navView.image=navImage;
        [windowItemButton addSubview: navView];
        [self addSubview:windowItemButton];
        
        //车门状况
        doorItemButton=[[UIButton alloc]initWithFrame:CGRectMake(windowItemButton.frame.origin.x, windowItemButton.frame.origin.y+windowItemButton.frame.size.height+10, navBackimage.size.width, navBackimage.size.height)];
        doorItemButton.tag=2;
        [doorItemButton setBackgroundImage:navBackimage forState:UIControlStateNormal];
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"icon_door_condition",Res_Image,@"")];
        iconView=[[UIImageView alloc]initWithFrame:CGRectMake(10,doorItemButton.frame.size.height/2-image.size.height/2, image.size.width, image.size.height)];
        iconView.image=image;
        [doorItemButton addSubview: iconView];
        
        iconwidth=image.size.width;
        titleLable=[[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.origin.x+iconView.frame.size.width+10, iconView.frame.origin.y+5, doorItemButton.frame.size.width-55-iconwidth-navImage.size.width,18)];
        titleLable.font=[UIFont systemFontOfSize:18];
        titleLable.textColor=[UIColor whiteColor];
        titleLable.text=NSLocalizedStringFromTable(@"DoorsTitle",Res_String,@"");
        titleLable.backgroundColor=[UIColor clearColor];
        [doorItemButton addSubview: titleLable];
        
        doorStatusLable=[[UILabel alloc] initWithFrame:CGRectMake(titleLable.frame.origin.x, titleLable.frame.origin.y+titleLable.frame.size.height +7.5, 50,18)];
        doorStatusLable.font=[UIFont systemFontOfSize:12];
        doorStatusLable.textColor=[UIColor whiteColor];
        doorStatusLable.textAlignment=NSTextAlignmentCenter;
        doorStatusLable.backgroundColor=[UIColor clearColor];
        [doorItemButton addSubview: doorStatusLable];
        
        
        doorInfoLable=[[UILabel alloc] init];
        doorInfoLable.font=[UIFont systemFontOfSize:14];
        doorInfoLable.textColor=[UIColor whiteColor];
        frame= doorInfoLable.frame;
        frame.size.width=[doorInfoLable.text sizeWithFont: doorInfoLable.font].width;
        frame.size.height=14;
        doorInfoLable.frame=frame;
        doorInfoLable.backgroundColor=[UIColor clearColor];
        doorInfoMarqueeView=[[CustomMarqueeView alloc] initWithFrame:CGRectMake(doorStatusLable.frame.origin.x, doorStatusLable.frame.origin.y+doorStatusLable.frame.size.height +7.5, titleLable.frame.size.width,14)];
        doorInfoMarqueeView.tag=102;
        doorInfoMarqueeView.backgroundColor=[UIColor clearColor];
        doorInfoMarqueeView.contentViews=@[doorInfoLable];
        
        navView=[[UIImageView alloc] initWithFrame:CGRectMake(titleLable.frame.origin.x+titleLable.frame.size.width+20, doorItemButton.frame.size.height/2-navImage.size.height/2, navImage.size.width, navImage.size.height)];
        navView.image=navImage;
        [doorItemButton addSubview: navView];
        [self addSubview:doorItemButton];
        
        //蓄电池状况
        powerItemButton=[[UIButton alloc]initWithFrame:CGRectMake(doorItemButton.frame.origin.x, doorItemButton.frame.origin.y+doorItemButton.frame.size.height+10, navBackimage.size.width, navBackimage.size.height)];
        powerItemButton.tag=3;
        [powerItemButton setBackgroundImage:navBackimage forState:UIControlStateNormal];
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"icon_power_condition",Res_Image,@"")];
        iconView=[[UIImageView alloc]initWithFrame:CGRectMake(10,powerItemButton.frame.size.height/2-image.size.height/2, image.size.width, image.size.height)];
        iconView.image=image;
        [powerItemButton addSubview: iconView];
        
        iconwidth=image.size.width;
        titleLable=[[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.origin.x+iconView.frame.size.width+10, iconView.frame.origin.y+5, powerItemButton.frame.size.width-55-iconwidth-navImage.size.width,18)];
        titleLable.font=[UIFont systemFontOfSize:18];
        titleLable.textColor=[UIColor whiteColor];
        titleLable.text=NSLocalizedStringFromTable(@"PowerTitle",Res_String,@"");
        titleLable.backgroundColor=[UIColor clearColor];
        [powerItemButton addSubview: titleLable];
        
        powerStatusLable=[[UILabel alloc] initWithFrame:CGRectMake(titleLable.frame.origin.x, titleLable.frame.origin.y+titleLable.frame.size.height +7.5, 50,18)];
        powerStatusLable.font=[UIFont systemFontOfSize:12];
        powerStatusLable.textColor=[UIColor whiteColor];
        powerStatusLable.textAlignment=NSTextAlignmentCenter;
        powerStatusLable.backgroundColor=[UIColor clearColor];
        [powerItemButton addSubview: powerStatusLable];
        
        
        powerInfoLable=[[UILabel alloc] init];
        powerInfoLable.font=[UIFont systemFontOfSize:14];
        powerInfoLable.textColor=[UIColor whiteColor];
        frame= powerInfoLable.frame;
        frame.size.width=[powerInfoLable.text sizeWithFont: powerInfoLable.font].width;
        frame.size.height=14;
        powerInfoLable.frame=frame;
        powerInfoLable.backgroundColor=[UIColor clearColor];
        powerInfoMarqueeView=[[CustomMarqueeView alloc] initWithFrame:CGRectMake(powerStatusLable.frame.origin.x, powerStatusLable.frame.origin.y+powerStatusLable.frame.size.height +7.5, titleLable.frame.size.width,14)];
        powerInfoMarqueeView.tag=103;
        powerInfoMarqueeView.backgroundColor=[UIColor clearColor];
        powerInfoMarqueeView.contentViews=@[powerInfoLable];
        
        navView=[[UIImageView alloc] initWithFrame:CGRectMake(titleLable.frame.origin.x+titleLable.frame.size.width+20, powerItemButton.frame.size.height/2-navImage.size.height/2, navImage.size.width, navImage.size.height)];
        navView.image=navImage;
        [powerItemButton addSubview: navView];
        [self addSubview:powerItemButton];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"btn_condition_refresh",Res_Image,@"")];
        refreshButton=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-image.size.width/2, CGRectGetMaxY(powerItemButton.frame) + (CGRectGetMinY(bottomitemImageView.frame) - CGRectGetMaxY(powerItemButton.frame)-image.size.height)/2, image.size.width, image.size.height)];
        [refreshButton setBackgroundImage:image forState:UIControlStateNormal];
        [self addSubview:refreshButton];
        
        
    }
    return self;
}

-(void)setEventObserver:(id<VehicleConditionViewDelegate>)eventObserver
{
    _eventObserver=eventObserver;
    if (eventObserver) {
        [refreshButton addTarget:eventObserver action:@selector(refreshButton_onClick:) forControlEvents:UIControlEventTouchUpInside];
        [windowItemButton addTarget:eventObserver action:@selector(itemButton_onClick:) forControlEvents:UIControlEventTouchUpInside];
        [doorItemButton addTarget:eventObserver action:@selector(itemButton_onClick:) forControlEvents:UIControlEventTouchUpInside];
        [powerItemButton addTarget:eventObserver action:@selector(itemButton_onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setWindowsStatus:(enum StatusEnum)windowsStatus
{
    _windowsStatus=windowsStatus;
    NSString *statusText,*statusInfoText;
    if (windowsStatus) {
        statusText=NSLocalizedStringFromTable(@"WindowsAllClosed",Res_String,@"");
        statusInfoText=NSLocalizedStringFromTable(@"WindowsAllClosedInfo",Res_String,@"");
        windowStatusLable.backgroundColor=[UIColor greenColor];
    }else{
    statusText=NSLocalizedStringFromTable(@"WindowsWithoutClosed",Res_String,@"");
        statusInfoText=NSLocalizedStringFromTable(@"WindowsWithoutClosedInfo",Res_String,@"");
        windowStatusLable.backgroundColor=[UIColor redColor];
    }
    windowStatusLable.text=statusText;
   CGRect frame= windowStatusLable.frame;
    frame.size.width=[statusText sizeWithFont:windowStatusLable.font].width+10;
    windowStatusLable.frame=frame;
    windowInfoLable.text=statusInfoText;
    CGRect infoFrame= windowInfoLable.frame;
    infoFrame.size.width=[windowInfoLable.text sizeWithFont: windowInfoLable.font].width;
    windowInfoLable.frame=infoFrame;
    [windowItemButton addSubview:windowInfoMarqueeView];
}

-(void)setDoorsStatus:(enum StatusEnum)doorsStatus
{
    _doorsStatus=doorsStatus;
     NSString *statusText,*statusInfoText;
    if (doorsStatus) {
        statusText=NSLocalizedStringFromTable(@"DoorsAllClosed",Res_String,@"");
        statusInfoText=NSLocalizedStringFromTable(@"DoorsAllClosedInfo",Res_String,@"");
         doorStatusLable.backgroundColor=[UIColor greenColor];
    }else{
        statusText=NSLocalizedStringFromTable(@"DoorsWithoutClosed",Res_String,@"");
        statusInfoText=NSLocalizedStringFromTable(@"DoorsWithoutClosedInfo",Res_String,@"");
        doorStatusLable.backgroundColor=[UIColor redColor];
    }
    
    doorStatusLable.text=statusText;
    CGRect frame= doorStatusLable.frame;
    frame.size.width=[statusText sizeWithFont:doorStatusLable.font].width+10;
    doorStatusLable.frame=frame;
    
    doorInfoLable.text=statusInfoText;
    
    CGRect infoFrame= doorInfoLable.frame;
    infoFrame.size.width=[doorInfoLable.text sizeWithFont: doorInfoLable.font].width;
    doorInfoLable.frame=infoFrame;
    [doorItemButton addSubview:doorInfoMarqueeView];
}

-(void)setPowerStatus:(enum StatusEnum)powerStatus
{
    _powerStatus=powerStatus;
     NSString *statusText,*statusInfoText;
    if (powerStatus) {
        statusText=NSLocalizedStringFromTable(@"PowerOK",Res_String,@"");
        statusInfoText=NSLocalizedStringFromTable(@"PowerOKInfo",Res_String,@"");
        powerStatusLable.backgroundColor=[UIColor greenColor];

    }else{
        statusText=NSLocalizedStringFromTable(@"PowerLower",Res_String,@"");
        statusInfoText=NSLocalizedStringFromTable(@"PowerLowerInfo",Res_String,@"");
        powerStatusLable.backgroundColor=[UIColor redColor];
    }
    
    powerStatusLable.text=statusText;
    CGRect frame= powerStatusLable.frame;
    frame.size.width=[statusText sizeWithFont:powerStatusLable.font].width+10;
    powerStatusLable.frame=frame;
    
    powerInfoLable.text=statusInfoText;
    
    CGRect infoFrame= powerInfoLable.frame;
    infoFrame.size.width=[powerInfoLable.text sizeWithFont: powerInfoLable.font].width;
    powerInfoLable.frame=infoFrame;
    [powerItemButton addSubview:powerInfoMarqueeView];
}

- (void)shutDownBtnUserInterface
{
    windowItemButton.userInteractionEnabled = NO;
    doorItemButton.userInteractionEnabled = NO;
    powerItemButton.userInteractionEnabled = NO;
}

- (void)openBtnUserInterface
{
    windowItemButton.userInteractionEnabled = YES;
    doorItemButton.userInteractionEnabled = YES;
    powerItemButton.userInteractionEnabled = YES;
}

@end
