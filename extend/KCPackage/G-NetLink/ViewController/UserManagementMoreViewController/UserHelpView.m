//
//  UserHelpView.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserHelpView.h"

@implementation UserHelpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"user_more_table_cell_text0", Res_String, @"");
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
        backgroundImageView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"vehicle_control_back",Res_Image,@"")];
        [self insertSubview:backgroundImageView atIndex:0];
        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_back_to_home",Res_Image,@"")];
        
        UIImage *g_NetLinkImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
        UIImageView *bottomitemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - g_NetLinkImage.size.height, self.bounds.size.width, g_NetLinkImage.size.height)];
        bottomitemImageView.image = g_NetLinkImage;
        bottomitemImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomitemImageView];
        
//        ScrollView里面的文字
        _scrollerView.contentSize=CGSizeMake(self.frame.size.width, 1300 + g_NetLinkImage.size.height);
    UIImage * label_background_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_help_label_img", Res_Image, @"")];
        UIImageView* _img1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 88)];
        _img1.image=label_background_img;
        [_scrollerView addSubview:_img1];
        
        UILabel * title1=[self getSize:NSLocalizedStringFromTable(@"help_title1", Res_String, @"")  font:[UIFont systemFontOfSize:19] frame:CGRectMake(15, _img1.frame.origin.y+15, self.frame.size.width-30, 15)];
        [_scrollerView addSubview:title1];

        UILabel * title1_label1=[self getSize:NSLocalizedStringFromTable(@"help_title1_label1", Res_String, @"") font:[UIFont systemFontOfSize:16] frame:CGRectMake(15, title1.frame.origin.y+title1.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:title1_label1];
        
        UILabel *help_title1_label1_text =[self getSize:NSLocalizedStringFromTable(@"help_title1_label1_text", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, title1_label1.frame.origin.y+title1_label1.frame.size.height+15, self.frame.size.width-30, 12) ];
        [_scrollerView addSubview:help_title1_label1_text];
        
        NSString   *string_help_title1_label1_text=NSLocalizedStringFromTable(@"help_title1_label1_text1", Res_String, @"");
        CGSize  labelHeight1= [string_help_title1_label1_text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.frame.size.width-30, MAXFLOAT)  lineBreakMode:NSLineBreakByWordWrapping];
        UILabel *help_title1_label1_text1 =[self getSize:NSLocalizedStringFromTable(@"help_title1_label1_text1", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title1_label1_text.frame.origin.y+help_title1_label1_text.frame.size.height+15, self.frame.size.width-30,labelHeight1.height)];
        [_scrollerView addSubview:help_title1_label1_text1];
        
        UILabel * title1_label2=[self getSize:NSLocalizedStringFromTable(@"help_title1_label2", Res_String, @"") font:[UIFont systemFontOfSize:16] frame:CGRectMake(15, help_title1_label1_text1.frame.origin.y+help_title1_label1_text1.frame.size.height+15, self.frame.size.width-30, 12)];
           [_scrollerView addSubview:title1_label2];
        

        UILabel *help_title1_label2_text =[self getSize:NSLocalizedStringFromTable(@"help_title1_label2_text", Res_String, @"")  font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, title1_label2.frame.origin.y+title1_label2.frame.size.height+15, self.frame.size.width-30,12)];
        [_scrollerView addSubview:help_title1_label2_text];
        
        UILabel * title1_label3=[self getSize:NSLocalizedStringFromTable(@"help_title1_label3", Res_String, @"") font:[UIFont systemFontOfSize:16] frame:CGRectMake(15, help_title1_label2_text.frame.origin.y+help_title1_label2_text.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:title1_label3];
        
        UILabel *help_title1_label3_text =[self getSize:NSLocalizedStringFromTable(@"help_title1_label3_text", Res_String, @"")  font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, title1_label3.frame.origin.y+title1_label3.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title1_label3_text];
    _img1.frame=CGRectMake(10, _img1.frame.origin.y, self.frame.size.width-20, help_title1_label3_text.frame.origin.y+help_title1_label3_text.frame.size.height+10);
        

        
        UIImageView* _img2=[[UIImageView alloc]initWithFrame:CGRectMake(10, _img1.frame.origin.y+_img1.frame.size.height+10, self.frame.size.width-20, 30)];
        _img2.image=label_background_img;
        [_scrollerView addSubview:_img2];
        
        UILabel * title2=[self getSize:NSLocalizedStringFromTable(@"help_title2", Res_String, @"") font:[UIFont systemFontOfSize:19] frame:CGRectMake(15, _img2.frame.origin.y+15, self.frame.size.width-30, 15)];
        [_scrollerView addSubview:title2];
        
        UILabel * help_title2_label1=[self getSize:NSLocalizedStringFromTable(@"help_title2_label1", Res_String, @"") font:[UIFont systemFontOfSize:16] frame:CGRectMake(15, title2.frame.origin.y+title2.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label1];
        

        UILabel *help_title2_label1_text =[self getSize:NSLocalizedStringFromTable(@"help_title2_label1_text", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label1.frame.origin.y+help_title2_label1.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label1_text];
        
        UILabel * help_title2_label2=[self getSize:NSLocalizedStringFromTable(@"help_title2_label1", Res_String, @"") font:[UIFont systemFontOfSize:16] frame:CGRectMake(15, help_title2_label1_text.frame.origin.y+help_title2_label1_text.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label2];
        
        UILabel *help_title2_label2_text1 =[self getSize:NSLocalizedStringFromTable(@"help_title2_label2_text1", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label2.frame.origin.y+help_title2_label2.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label2_text1];
        
  
        UILabel *help_title2_label2_text2 =[self getSize:NSLocalizedStringFromTable(@"help_title2_label2_text2", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label2_text1.frame.origin.y+help_title2_label2_text1.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label2_text2];
        
   
        UILabel *help_title2_label2_text3 =[self getSize:NSLocalizedStringFromTable(@"help_title2_label2_text3", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label2_text2.frame.origin.y+help_title2_label2_text2.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label2_text3];
        
        
        UILabel *help_title2_label3=[self getSize:NSLocalizedStringFromTable(@"help_title2_label2", Res_String, @"") font:[UIFont systemFontOfSize:16] frame:CGRectMake(15, help_title2_label2_text3.frame.origin.y+help_title2_label2_text3.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label3];
        
        UILabel *help_title2_label3_text=[self getSize:NSLocalizedStringFromTable(@"help_title2_label3_text", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label3.frame.origin.y+help_title2_label3.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label3_text];
        
        UILabel *help_title2_label3_title1=[self getSize:NSLocalizedStringFromTable(@"help_title2_label3_title1", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label3_text.frame.origin.y+help_title2_label3_text.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label3_title1];
        
        UILabel *help_title2_label3_title2=[self getSize:NSLocalizedStringFromTable(@"help_title2_label3_title2", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label3_title1.frame.origin.y+help_title2_label3_title1.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label3_title2];
        
        UILabel *help_title2_label3_title3=[self getSize:NSLocalizedStringFromTable(@"help_title2_label3_title3", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label3_title2.frame.origin.y+help_title2_label3_title2.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label3_title3];
        UILabel *help_title2_label3_title4=[self getSize:NSLocalizedStringFromTable(@"help_title2_label3_title4", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label3_title3.frame.origin.y+help_title2_label3_title3.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label3_title4];
        UILabel *help_title2_label3_title5=[self getSize:NSLocalizedStringFromTable(@"help_title2_label3_title5", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label3_title4.frame.origin.y+help_title2_label3_title4.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label3_title5];
        UILabel *help_title2_label3_title6=[self getSize:NSLocalizedStringFromTable(@"help_title2_label3_title6", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label3_title5.frame.origin.y+help_title2_label3_title5.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label3_title6];
        UILabel *help_title2_label3_title7=[self getSize:NSLocalizedStringFromTable(@"help_title2_label3_title7", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label3_title6.frame.origin.y+help_title2_label3_title6.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label3_title7];
        UILabel *help_title2_label3_title8=[self getSize:NSLocalizedStringFromTable(@"help_title2_label3_title8", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label3_title7.frame.origin.y+help_title2_label3_title7.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label3_title8];
        UILabel *help_title2_label3_title9=[self getSize:NSLocalizedStringFromTable(@"help_title2_label3_title9", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label3_title8.frame.origin.y+help_title2_label3_title8.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label3_title9];
        UILabel *help_title2_label3_title10=[self getSize:NSLocalizedStringFromTable(@"help_title2_label3_title10", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label3_title9.frame.origin.y+help_title2_label3_title9.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label3_title10];
        UILabel *help_title2_label4=[self getSize:NSLocalizedStringFromTable(@"help_title2_label4", Res_String, @"") font:[UIFont systemFontOfSize:16] frame:CGRectMake(15, help_title2_label3_title10.frame.origin.y+help_title2_label3_title10.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label4];
        UILabel *help_title2_label4_text=[self getSize:NSLocalizedStringFromTable(@"help_title2_label4_text", Res_String, @"") font:[UIFont systemFontOfSize:12] frame:CGRectMake(15, help_title2_label4.frame.origin.y+help_title2_label4.frame.size.height+15, self.frame.size.width-30, 12)];
        [_scrollerView addSubview:help_title2_label4_text];
          _img2.frame=CGRectMake(10, _img2.frame.origin.y, self.frame.size.width-20, 905);
        
    }
    return self;
}
-(UILabel *)getSize:(NSString*)string  font:(UIFont*)font  frame:(CGRect)frame{
    CGSize  size= [string sizeWithFont:font constrainedToSize:CGSizeMake(self.frame.size.width-30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width-30, size.height)];
    label.textColor=[UIColor whiteColor];
    label.font=font;
    label.text=string;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

//-(UILabel *)setframe:(CGRect)frame onText:(NSString*)text onFont:(UIFont*)font onColor:(UIColor*)color{
//    UILabel * label=[[UILabel alloc]initWithFrame:frame];
//    label.font=font;
//    label.textColor=color;
//    label.text=text;
//    return label;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
