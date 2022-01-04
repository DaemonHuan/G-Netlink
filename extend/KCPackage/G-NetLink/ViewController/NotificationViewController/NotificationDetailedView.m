//
//  NotificationDetailedView.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-5-8.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "NotificationDetailedView.h"

@implementation NotificationDetailedView
@synthesize titleLabel,textView,dateLabel,nameLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImage *img_tabbar=[UIImage imageNamed:NSLocalizedStringFromTable(@"notification_bottom_img", Res_Image, @"")];
        UIImageView * imgView = [[UIImageView alloc]initWithImage:img_tabbar];
        CGRect frame = self.frame;
        frame.origin.y = _customTitleBar.frame.size.height;
        frame.size.height = frame.size.height - _customTitleBar.frame.size.height;
        imgView.frame = frame;
        [self addSubview:imgView];

        self.backgroundColor=[UIColor blackColor];
        _customTitleBar.titleText = NSLocalizedStringFromTable(@"notification_title", Res_String, @"");
        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return", Res_Image, @"")];
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_back_to_home", Res_Image, @"")];
        UIImage* background_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"notification_text_background", Res_Image, @"")];
        UIImageView * backgroundView=[[UIImageView alloc]initWithFrame:CGRectMake(0, _customTitleBar.frame.origin.y+_customTitleBar.frame.size.height+10, self.bounds.size.width, background_img.size.height)];
        backgroundView.center=CGPointMake(self.center.x, backgroundView.center.y);
        backgroundView.image=background_img;
        [self addSubview:backgroundView];
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, backgroundView.frame.origin.y+20, 200, 15)];
        titleLabel.center=CGPointMake(self.center.x, titleLabel.center.y);
        titleLabel.font=[UIFont systemFontOfSize:15];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.textColor=[UIColor colorWithRed:44.0f/255.0f green:50.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
        titleLabel.text=@"G-NetLink服务通知";
        [self addSubview:titleLabel];
        dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(backgroundView.frame.origin.x+backgroundView.frame.size.width-180, backgroundView.frame.origin.y+backgroundView.frame.size.height-20, 150, 12)];
        dateLabel.font=[UIFont systemFontOfSize:12];
        dateLabel.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1.0f];
        dateLabel.text=@"2013年11月22日";
        dateLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:dateLabel];
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(backgroundView.frame.origin.x+backgroundView.frame.size.width-180, backgroundView.frame.origin.y+backgroundView.frame.size.height-20-7.5-12, 150, 12)];
        nameLabel.font=[UIFont systemFontOfSize:12];
        nameLabel.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1.0f];
        nameLabel.text=@"G-NetLink客服服务中心";
          nameLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:nameLabel];
        textView=[[UITextView alloc]initWithFrame:CGRectMake(35,titleLabel.frame.origin.y+titleLabel.frame.size.height+10, backgroundView.frame.size.width-50, 125)];
        textView.font=[UIFont systemFontOfSize:15];
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor=[UIColor colorWithRed:44.0f/255.0f green:50.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
        textView.text=@"尊敬的G-NetLink会员，为感谢您长期以来对本公司服务的厚爱，欢迎咨询！我们期待你的加入!";
//        textView.lineBreakMode = UILineBreakModeTailTruncation;
//        textView.numberOfLines = 0;
//        textLabel.textAlignment=NSTextAlignmentNatural;
        [self addSubview:textView];
        
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
