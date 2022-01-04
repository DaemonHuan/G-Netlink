//
//  UserFeedbackView.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserFeedbackView.h"
#import "StringUtils.h"
@implementation UserFeedbackView
{
    UILabel * _rightLable;
    UITextView *_textView;
    UITextField * _phoneFileld;
}
@synthesize textView = _textView,phoneFileld = _phoneFileld,rightLable = _rightLable;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"user_more_table_cell_text1", Res_String, @"");
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
        backgroundImageView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"vehicle_control_back",Res_Image,@"")];
        [self insertSubview:backgroundImageView atIndex:0];
        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_back_to_home",Res_Image,@"")];
        UIImage * text_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_feedback_text_view_img", Res_Image, @"")];
        UIImageView * text_backgroudn_imgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, _customTitleBar.frame.size.height+_customTitleBar.frame.origin.y+ 27, self.frame.size.width-20, text_img.size.height)];
        text_backgroudn_imgView.image=text_img;
        text_backgroudn_imgView.userInteractionEnabled=YES;
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, text_backgroudn_imgView.frame.size.width-20, text_backgroudn_imgView.frame.size.height-20)];
        _textView.delegate=self;
        _textView.backgroundColor=[UIColor clearColor];
        _textView.text=NSLocalizedStringFromTable(@"user_feedback_textView_text", Res_String, @"");
        _textView.font=[UIFont systemFontOfSize:15];
        _textView.textColor=[UIColor colorWithRed:143.0f/255.0f green:152.0f/255.0f blue:167.0f/255.0f alpha:1.0f];
        [text_backgroudn_imgView addSubview:_textView];
        [self addSubview:text_backgroudn_imgView];
        UILabel * leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10+_customTitleBar.frame.origin.y+_customTitleBar.frame.size.height, 100, 12)];
        leftLabel.text=NSLocalizedStringFromTable(@"user_feedback_left_label", Res_String, @"");
        _rightLable=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-115, 10+_customTitleBar.frame.origin.y+_customTitleBar.frame.size.height, 100, 15)];
        _rightLable.text=NSLocalizedStringFromTable(@"user_feedback_right_label", Res_String, @"'");
        _rightLable.textAlignment=NSTextAlignmentRight;
        leftLabel.font=[UIFont systemFontOfSize:12];
        leftLabel.textColor=[UIColor whiteColor];
        leftLabel.backgroundColor = [UIColor clearColor];
        _rightLable.font=[UIFont systemFontOfSize:15];
        _rightLable.textColor=[UIColor colorWithRed:143.0f/255.0f green:152.0f/255.0f blue:167.0f/255.0f alpha:1.0f];
        _rightLable.backgroundColor = [UIColor clearColor];
        [self addSubview:leftLabel];
        [self addSubview:_rightLable];
        UILabel * phone_label=[[UILabel alloc]initWithFrame:CGRectMake(15, text_backgroudn_imgView.frame.origin.y+text_backgroudn_imgView.frame.size.height+10, text_backgroudn_imgView.frame.size.width, 12)];
        phone_label.text=NSLocalizedStringFromTable(@"user_feedback_phone_label_text", Res_String, @"");
        phone_label.textColor=[UIColor whiteColor];
        phone_label.font=[UIFont systemFontOfSize:12];
        phone_label.backgroundColor = [UIColor clearColor];
        [self addSubview:phone_label];
        UIImage *phone_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_phone_modification", Res_Image, @"")];
        UIImageView * phone_imgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, text_backgroudn_imgView.frame.origin.y+text_backgroudn_imgView.frame.size.height+10+17, self.frame.size.width-20, phone_img.size.height)];
        phone_imgView.image=phone_img;
        _phoneFileld=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, phone_imgView.frame.size.width-20,phone_imgView.frame.size.height-20 )];
        phone_imgView.userInteractionEnabled=YES;
        _phoneFileld.placeholder=NSLocalizedStringFromTable(@"user_feedback_phone_textField_text", Res_String, @"");
        _phoneFileld.delegate = self;
        _phoneFileld.font=[UIFont systemFontOfSize:15];
        _phoneFileld.textColor=[UIColor colorWithRed:143.0f/255.0f green:152.0f/255.0f blue:167.0f/255.0f alpha:1.0f];
        _phoneFileld.delegate=self;
        [phone_imgView addSubview:_phoneFileld];
        [self addSubview:phone_imgView];
        UIImage * bottom_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_cancle_btn_backgroud_img",Res_Image, @"")];
        UIButton * bottomBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, phone_imgView.frame.origin.y+phone_imgView.frame.size.height+15, phone_imgView.frame.size.width, bottom_img.size.height)];
        [bottomBtn setBackgroundImage:bottom_img forState:UIControlStateNormal];
        [bottomBtn setTitle:NSLocalizedStringFromTable(@"user_feedback_btn_text", Res_String, @"") forState:UIControlStateNormal];
        bottomBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        bottomBtn.titleLabel.textColor=[UIColor whiteColor];
        [bottomBtn addTarget:self action:@selector(bottomonclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bottomBtn];
        
        UIImage *g_NetLinkImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
        UIImageView *bottomitemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - g_NetLinkImage.size.height, self.bounds.size.width, g_NetLinkImage.size.height)];
        bottomitemImageView.image = g_NetLinkImage;
        bottomitemImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomitemImageView];
     }
    return self;
}
//提交按钮
-(void)bottomonclick:(id)sender{
    if ([self.feedDelegate  respondsToSelector:@selector(submitDelegate)]) {
        [self.feedDelegate submitDelegate];
    }
}
//
//    if ([_phoneFileld.text isValidateEmail]) {
//                NSLog(@"Email");
//              [self FeedBackMethod];
//    }else if([_phoneFileld.text isValidateMobile]){
//          NSLog(@"phone");
//          [self FeedBackMethod];
//        }else if (_phoneFileld.text.length >= 5&& _phoneFileld.text.length<=10   ){
//            NSLog(@"qq");
//        [self FeedBackMethod];
//    }else{
//        NSString * message=@"您的联系方式为空，请填写！";
//        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
//}
//-(void)FeedBackMethod{
//    if (_textView.text.length>10) {
//    NSString * message=@"您提交的内容长度已经超过500，请您删除一些，以保证提交成功";
//    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:message  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//    [alert show];
//}else{
//    [self.feedDelegate delegateCommitFeed:_textView.text withContract:_phoneFileld.text];
//}
//}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_phoneFileld resignFirstResponder];
    [self endEditing:YES];
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    return YES;
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (textField.text.length > 0) {
//        [self.feedDelegate textFieldDidEndEditingSave:textField.text];
//    }
//}
//-(void)textViewDidEndEditing:(UITextView *)textView
//{
//    if (textView.text.length > 0) {
//        [self.feedDelegate textViewDidEndEditingSave:textView.text];
//    }
//}
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    _textView.text = @"";
////    textField.text=@"";
//    textField.placeholder = @"";
//    textField.textColor=[UIColor colorWithRed:44.0f/255.0f green:50.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
//}
//- (void)textViewDidBeginEditing:(UITextView *)textView{
//    _phoneFileld.text = @"";
//    _phoneFileld.placeholder = @"";
////    textView.text=@"";
//    textView.textColor=[UIColor colorWithRed:44.0f/255.0f green:50.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
//}
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([textView.text length] - range.length + [text length] > 500)
//    {
//        return NO;
//    }
//    return YES;
//}
//- (void)textViewDidChange:(UITextView *)textView{
//    if (textView.text.length>=500) {
//        NSString * message=@"您输入的内容过多，请你删掉一些，以保证提交成功";
//        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }else{
//        int num=textView.text.length;
//        _rightLable.text=[NSString stringWithFormat:@"%@%d%@",@"剩余",500-num,@"字"];
//    }
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
