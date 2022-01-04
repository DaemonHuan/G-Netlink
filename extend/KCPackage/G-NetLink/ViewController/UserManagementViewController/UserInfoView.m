//
//  UserInfoView.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-28.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserInfoView.h"

@implementation UserInfoView

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//_customTitleBar.titleText=NSLocalizedStringFromTable(@"userManagement_table_cell_text1", Res_String, @"");
//        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
//        backgroundImageView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"vehicle_control_back",Res_Image,@"")];
//        [self insertSubview:backgroundImageView atIndex:0];
//        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
//        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_back_to_home",Res_Image,@"")];
//
//
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame tableViewStyle:(UITableViewStyle)style{
    self = [super initWithFrame:frame tableViewStyle:style];
    if (self) {
        // Initialization code
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"userManagement_user_info_title", Res_String, @"");
        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_back_to_home",Res_Image,@"")];

        UIImage *g_NetLinkImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
        UIImageView *bottomitemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - g_NetLinkImage.size.height, self.bounds.size.width, g_NetLinkImage.size.height)];
        bottomitemImageView.image = g_NetLinkImage;
        bottomitemImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomitemImageView];

    }
    return self;
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
