//
//  UserAboutView.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserAboutView.h"

@implementation UserAboutView
{
    AttributedLabel * _textLabel;
    AttributedLabel * _bottomLabel;
}
@synthesize textLabel = _textLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"user_more_table_cell_text5", Res_String, @"");
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
        backgroundImageView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"vehicle_control_back",Res_Image,@"")];
        [self insertSubview:backgroundImageView atIndex:0];
        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_back_to_home",Res_Image,@"")];
        UIImage * image_backgroud=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_about_img", Res_Image, @"")];
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-image_backgroud.size.width)/2, _customTitleBar.frame.origin.y+_customTitleBar.frame.size.height+10, image_backgroud.size.width, image_backgroud.size.height)];
        imgView.image=image_backgroud;
        UIImage * logo_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_about_logo", Res_Image, @"")];
        UIImageView * logo=[[UIImageView alloc]initWithFrame:CGRectMake((imgView.frame.size.width-logo_img.size.width)/2, 40, logo_img.size.width, logo_img.size.height)];
        logo.image=logo_img;
        [imgView addSubview:logo];
        _textLabel=[[AttributedLabel alloc]initWithFrame:CGRectMake(self.center.x,imgView.frame.origin.y+imgView.frame.size.height-20-9-12-50, 100, 14)];
        NSString * string1=NSLocalizedStringFromTable(@"user_about_client_number", Res_String, @"");
        NSString * string2=@"V2.0";
        [_textLabel setText:[NSString stringWithFormat:@"%@ %@",string1,string2]];
        [_textLabel setLabelFont:[UIFont systemFontOfSize:12] fromIndex:0 length:_textLabel.text.length];
        [_textLabel setColor:[UIColor colorWithRed:231.0f/255.0f green:206.0f/255.0f blue:140.0f/255.0f alpha:1.0f]fromIndex:5 length:6];
        [_textLabel setColor:[UIColor whiteColor] fromIndex:0 length:5];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment=NSTextAlignmentCenter;
        _bottomLabel =[[AttributedLabel alloc]initWithFrame:CGRectMake(0, _textLabel.frame.origin.y+49, imgView.frame.size.width, 10)];
        [_bottomLabel setText:NSLocalizedStringFromTable(@"user_about_label_text", Res_String, @"")];
        NSString * str = NSLocalizedStringFromTable(@"user_about_label_text", Res_String, @"");
        CGSize constraint = CGSizeMake(CGFLOAT_MAX, 9);
        
        CGSize size = [str sizeWithFont: [UIFont systemFontOfSize:9] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect  frame = _bottomLabel.frame;
        frame.size.width = size.width;
        _bottomLabel.frame = frame;
        _bottomLabel.center = CGPointMake(self.center.x+4, _bottomLabel.center.y);
        
        [_bottomLabel setColor:[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f]fromIndex:0 length:_bottomLabel.text.length];
        _bottomLabel.backgroundColor = [UIColor clearColor];
       _bottomLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomLabel setLabelFont:[UIFont systemFontOfSize:9] fromIndex:0 length:_bottomLabel.text.length];
        [self addSubview:imgView];
        [self addSubview:_textLabel];
        [self addSubview:_bottomLabel];
        
        UIImage *g_NetLinkImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
        UIImageView *bottomitemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - g_NetLinkImage.size.height, self.bounds.size.width, g_NetLinkImage.size.height)];
        bottomitemImageView.image = g_NetLinkImage;
        bottomitemImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomitemImageView];
    }
    return self;
}
-(void)setClientVersion:(NSString*)clientText
{
    NSString * client=NSLocalizedStringFromTable(@"user_about_client_number", Res_String, @"");
    NSString * clientNum=[NSString stringWithFormat:@"%@ v%@",client,clientText];
    [_textLabel setText:clientNum];
    _textLabel.textColor = [UIColor colorWithRed:231.0f/255.0f green:206.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
    [_textLabel setLabelFont:[UIFont systemFontOfSize:12] fromIndex:0 length:_textLabel.text.length];
    [_textLabel setColor:[UIColor whiteColor] fromIndex:0 length:5];
    NSLog(@"%d",_textLabel.text.length);
    [_textLabel setColor:[UIColor colorWithRed:231.0f/255.0f green:206.0f/255.0f blue:140.0f/255.0f alpha:1.0f]fromIndex:5 length:_textLabel.text.length-5];
  
    _textLabel.center = CGPointMake(self.center.x+5, _textLabel.center.y);
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
