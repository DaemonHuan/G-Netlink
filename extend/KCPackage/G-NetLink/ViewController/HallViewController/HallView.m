//
//  HallView.m
//  G-NetLink
//
//  Created by jayden on 14-4-24.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "HallView.h"

@implementation HallView
{
    UIButton * _inquiryBtn;
    UIButton * _helpBtn;
    UIButton * _locationBtn;
    UIButton * _navigationBtn;
    UIImageView * _tabbarView;
}
@synthesize nav_right_btn_number_label,nav_right_btn_number;
//车况查询
-(void)inquiryBtn_onClick:(BOOL)isSelect{
    [self.delegate inquiryBtn_onClick_delegate];
}
//车辆位置
-(void)locationBtn_onClick:(id)sender{
    [self.delegate locationBtn_onClick_delegate];
}
//一键救援
-(void)helpBtn_onClick:(BOOL)isSelect{
    [self.delegate helpBtn_onClick_delegate];
}
//一键导航
-(void)navigationBtn_onClick:(id)sender{
    [self.delegate navigationBtn_onClick_delegate];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"hall_nav_right", Res_Image, @"")];
        UIImage* nav_right_btn_img = [UIImage imageNamed:NSLocalizedStringFromTable(@"hall_nav_right", Res_Image, @"")];
        UIImage *nav_right_btn_number_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"hall_nav_right_number", Res_Image, @"")];
//      导航栏右边显示未读  
        UIImageView * nav_right_btn=[[UIImageView alloc]initWithImage:nav_right_btn_img];
        nav_right_btn_number=[[UIImageView alloc]initWithImage:nav_right_btn_number_img];
        nav_right_btn_number.frame=CGRectMake(nav_right_btn.frame.size.height-nav_right_btn_number_img.size.width, 3, nav_right_btn_number_img.size.width, nav_right_btn_number_img.size.height);
        nav_right_btn_number.alpha=0;
        [nav_right_btn addSubview:nav_right_btn_number];
        nav_right_btn_number_label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, nav_right_btn_number.frame.size.width, nav_right_btn_number.frame.size.height)];
//        int btn_num=self.number;
//        if (btn_num==0) {
//            _nav_right_btn_number.alpha=0;
//        }else{
//            if(btn_num<9){
//            nav_right_btn_number_label.text=[NSString stringWithFormat:@"%d",btn_num];
//                nav_right_btn_number_label.textAlignment=NSTextAlignmentCenter;
//            }
//            else
//              nav_right_btn_number_label.text=@"9+";
//             nav_right_btn_number_label.font=[UIFont systemFontOfSize:13];
//            nav_right_btn_number_label.textAlignment=NSTextAlignmentCenter;
//        }
        [nav_right_btn_number_label setTextColor:[UIColor whiteColor]];
        nav_right_btn_number_label.alpha=0;
        
        [nav_right_btn_number addSubview:nav_right_btn_number_label];
      
        [_customTitleBar.rightButton addSubview:nav_right_btn];
//    中间的背景图片
        UIImageView * logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"hall_center_logo", Res_Image, @"")]];
        logoView.center = self.center;
        [self addSubview:logoView];

// 车况查询
        CGRect frame;
        frame = self.frame;
        _inquiryBtn = [[UIButton alloc]init];
        _inquiryBtn.tag=1001;
        UIImage * img_inquiry=[UIImage imageNamed:NSLocalizedStringFromTable(@"hall_inquiry_new", Res_Image, @"")];
//        UIImage * img_inquiry_onClick=[UIImage imageNamed:NSLocalizedStringFromTable(@"hall_inquiry_on_click", Res_Image, @"")];
        _inquiryBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_inquiryBtn setFrame:CGRectMake(80/2-4, frame.origin.y+128/2+_customTitleBar.frame.size.height, img_inquiry.size.width+8 ,img_inquiry.size.height+25)];
        [_inquiryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_inquiryBtn setTitleColor:[UIColor colorWithRed:231.0f/255.0f green:206.0f/255.0f blue:140.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        _inquiryBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];         //设置button显示字体的大小
        [_inquiryBtn setImage:img_inquiry forState:UIControlStateNormal];
//        [_inquiryBtn setImage:img_inquiry_onClick forState:UIControlStateHighlighted];
        [_inquiryBtn titleRectForContentRect:CGRectMake(0, _inquiryBtn.frame.size.height-5, 10, 5)];
        _inquiryBtn.imageEdgeInsets = UIEdgeInsetsMake(0,4,25,4);
        _inquiryBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _inquiryBtn.titleEdgeInsets=UIEdgeInsetsMake(60,-55,15,0);
           [_inquiryBtn addTarget:self action:@selector(inquiryBtn_onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_inquiryBtn];
        
//     一键救援
        UIImage * img_help=[UIImage imageNamed:NSLocalizedStringFromTable(@"hall_onekeyhelp", Res_Image, @"")];
//        UIImage * img_help_onClick=[UIImage imageNamed:NSLocalizedStringFromTable(@"hall_help_on_click", Res_Image, @"")];
        _helpBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpBtn setFrame:CGRectMake(80/2-4, frame.size.height-148/2-_tabbarView.frame.size.height-(img_help.size.height+25), img_inquiry.size.width+8 ,img_help.size.height+25)];
        [_helpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_helpBtn setTitleColor:[UIColor colorWithRed:231.0f/255.0f green:206.0f/255.0f blue:140.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        _helpBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];         //设置button显示字体的大小
        [_helpBtn setImage:img_help forState:UIControlStateNormal];
//        [_helpBtn setImage:img_help_onClick forState:UIControlStateHighlighted];
        [_helpBtn titleRectForContentRect:CGRectMake(0, _helpBtn.frame.size.height-5, 10, 5)];
        _helpBtn.imageEdgeInsets = UIEdgeInsetsMake(0,4,25,4);
        _helpBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _helpBtn.titleEdgeInsets=UIEdgeInsetsMake(60,-55,15,0);
        [_helpBtn addTarget:self action:@selector(helpBtn_onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_helpBtn];
        
//       车辆位置
        UIImage * img_control=[UIImage imageNamed:NSLocalizedStringFromTable(@"hall_location", Res_Image, @"")];
//        UIImage * img_control_onClick=[UIImage imageNamed:NSLocalizedStringFromTable(@"hall_control_on_click", Res_Image, @"")];
        _locationBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationBtn setFrame:CGRectMake( frame.size.width-(img_control.size.width+8+80/2-4), frame.origin.y+128/2+_customTitleBar.frame.size.height , img_inquiry.size.width+8 ,img_help.size.height+25)];
        [_locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_locationBtn setTitleColor:[UIColor colorWithRed:231.0f/255.0f green:206.0f/255.0f blue:140.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        _locationBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];         //设置button显示字体的大小
        [_locationBtn setImage:img_control forState:UIControlStateNormal];
//        [_locationBtn setImage:img_control_onClick forState:UIControlStateHighlighted];
        [_locationBtn titleRectForContentRect:CGRectMake(0, _locationBtn.frame.size.height-5, 10, 5)];
        _locationBtn.imageEdgeInsets = UIEdgeInsetsMake(0,4,25,4);
        _locationBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _locationBtn.titleEdgeInsets=UIEdgeInsetsMake(60,-55,15,0);
        [_locationBtn addTarget:self action:@selector(locationBtn_onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_locationBtn];
        
//  一键导航
        UIImage * img_user=[UIImage imageNamed:NSLocalizedStringFromTable(@"hall_onekeynavigation", Res_Image, @"")];
//        UIImage * img_user_onClick=[UIImage imageNamed:NSLocalizedStringFromTable(@"hall_user_on_click", Res_Image, @"")];
        _navigationBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_navigationBtn setFrame:CGRectMake(frame.size.width-(img_control.size.width+8+80/2-4), frame.size.height-148/2-_tabbarView.frame.size.height-(img_help.size.height+25), img_inquiry.size.width+8 ,img_help.size.height+25)];
        [_navigationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_navigationBtn setTitleColor:[UIColor colorWithRed:231.0f/255.0f green:206.0f/255.0f blue:140.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        _navigationBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];         //设置button显示字体的大小
        [_navigationBtn setImage:img_user forState:UIControlStateNormal];
//        [_userBtn setImage:img_user_onClick forState:UIControlStateHighlighted];
        [_navigationBtn titleRectForContentRect:CGRectMake(0, _navigationBtn.frame.size.height-5, 10, 5)];
        _navigationBtn.imageEdgeInsets = UIEdgeInsetsMake(0,4,25,4);
        _navigationBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _navigationBtn.titleEdgeInsets=UIEdgeInsetsMake(60,-55,15,0);
        [_navigationBtn addTarget:self action:@selector(navigationBtn_onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_navigationBtn];
    }
    return self;
}
-(void)rightLabelNumber{
    nav_right_btn_number_label.alpha=1;

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
