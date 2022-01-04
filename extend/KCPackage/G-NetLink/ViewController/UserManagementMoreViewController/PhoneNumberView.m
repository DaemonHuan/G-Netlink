//
//  PhoneNumberView.m
//  G-NetLink
//
//  Created by liuxiaobo on 15/1/21.
//  Copyright (c) 2015年 95190. All rights reserved.
//

#import "PhoneNumberView.h"

@implementation PhoneNumberView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"userManagement_table_cell_text1", Res_String, @"");


        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
         _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_back_to_home",Res_Image,@"")];
        UIImage *g_NetLinkImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
        UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.frame.size.height - g_NetLinkImage.size.height -20- 45, self.frame.size.width-30, 45)];
        textLabel.font = [UIFont systemFontOfSize:12];
        textLabel.text = @"说明: 绑定的手机号码用于“一键救援” 和 “一键导航”功能，请您及时绑定，以便服务中心为您提供最贴心的服务。";
        textLabel.textColor = [UIColor whiteColor];
        textLabel.numberOfLines = 0;
        [self addSubview:textLabel];

        UIImageView *bottomitemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - g_NetLinkImage.size.height,self.bounds.size.width , g_NetLinkImage.size.height)];
        bottomitemImageView.image = g_NetLinkImage;
        bottomitemImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomitemImageView];
    }
        return self;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
