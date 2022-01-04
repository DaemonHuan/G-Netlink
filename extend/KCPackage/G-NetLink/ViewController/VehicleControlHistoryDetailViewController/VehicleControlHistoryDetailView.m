//
//  VehicleControlHistoryDetailView.m
//  G-NetLink
//
//  Created by jayden on 14-4-25.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleControlHistoryDetailView.h"
@interface VehicleControlHistoryDetailView()
{
    UIImageView *statusImageView;
    UILabel *titleLable;
    UILabel *contentLable;
    UILabel *statusLable;
    UILabel *timeLable;
}
@end
@implementation VehicleControlHistoryDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"VehicleControlHistoryTitle", Res_String, @"");
        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_home",Res_Image,@"")];
        
        UIImage *image = [UIImage imageNamed:NSLocalizedStringFromTable(@"vehicle_control_back",Res_Image,@"")];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(5,5,image.size.height-10,image.size.width-10)]];
        backgroundImageView.contentMode    = UIViewContentModeScaleToFill;
        backgroundImageView.userInteractionEnabled = YES;
        CGRect backgroundImageViewFrame = backgroundImageView.frame;
        backgroundImageViewFrame.size.width = self.bounds.size.width;
        backgroundImageViewFrame.size.height = self.bounds.size.height;
        backgroundImageView.frame = backgroundImageViewFrame;
        [self insertSubview:backgroundImageView atIndex:0];
        
        // jk
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
        UIImageView *bottomImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-image.size.height, self.bounds.size.width, image.size.height)];
        bottomImageView.image=image;
        bottomImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomImageView];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"history_detail_back",Res_Image,@"")];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-image.size.width/2, _customTitleBar.frame.origin.y+_customTitleBar.frame.size.height+10, image.size.width, image.size.height+18)];
        imageView.image=image;
        
        titleLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, image.size.width-20, 18)];
        titleLable.font=[UIFont systemFontOfSize:18];
        titleLable.textColor=[UIColor whiteColor];
        titleLable.backgroundColor=[UIColor clearColor];
        [imageView addSubview:titleLable];
        
        contentLable=[[UILabel alloc]initWithFrame:CGRectMake(10, titleLable.frame.origin.y+titleLable.frame.size.height+10, image.size.width-20, 32)];
        contentLable.font=[UIFont systemFontOfSize:12];
        contentLable.numberOfLines = 0;
        contentLable.textColor=[UIColor whiteColor];
        contentLable.backgroundColor=[UIColor clearColor];
        [imageView addSubview:contentLable];
        
        image=[UIImage imageNamed:NSLocalizedStringFromTable(@"history_status_ok_back",Res_Image,@"")];
       statusImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, imageView.frame.size.height-image.size.height, image.size.width, image.size.height)];
        statusImageView.image=image;
        
        statusLable= [[UILabel alloc]initWithFrame:CGRectMake(10, image.size.height/2-6, 40, 12)];
        statusLable.font=[UIFont systemFontOfSize:12];
        statusLable.textColor=[UIColor whiteColor];
        statusLable.backgroundColor=[UIColor clearColor];
         [statusImageView addSubview:statusLable];
        
        timeLable= [[UILabel alloc]initWithFrame:CGRectMake(statusLable.frame.origin.x+statusLable.frame.size.width,statusLable.frame.origin.y,image.size.width-(statusLable.frame.origin.x+statusLable.frame.size.width)-10, 12)];
        timeLable.font=[UIFont systemFontOfSize:12];
        timeLable.textColor=[UIColor whiteColor];
        timeLable.textAlignment=NSTextAlignmentRight;
        timeLable.backgroundColor=[UIColor clearColor];
        [statusImageView addSubview:timeLable];
        
        [imageView addSubview:statusImageView];
        [self addSubview:imageView];
        
        UIImage *g_NetLinkImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
        UIImageView *bottomitemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - g_NetLinkImage.size.height, self.bounds.size.width, g_NetLinkImage.size.height)];
        bottomitemImageView.image = g_NetLinkImage;
        bottomitemImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomitemImageView];
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    _title=title;
    titleLable.text=title;
}

-(void)setContent:(NSString *)content
{
    _content=content;
    contentLable.text=content;
}

-(void)setStatus:(int)status
{
    _status=status;
    if (_status == 1) {
        statusLable.text=NSLocalizedStringFromTable(@"history_status_ok",Res_String,@"");
        statusImageView.image=[UIImage imageNamed:NSLocalizedStringFromTable(@"history_status_ok_back",Res_Image,@"")];
    } else if (_status == 0) {
        statusLable.text=NSLocalizedStringFromTable(@"history_status_error",Res_String,@"");
        statusImageView.image=[UIImage imageNamed:NSLocalizedStringFromTable(@"history_status_error_back",Res_Image,@"")];
    }
}

-(void)setTime:(NSString *)time
{
    _time=time;
    timeLable.text=time;
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
