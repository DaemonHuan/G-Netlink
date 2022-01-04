//
//  UserPhoneModificationView.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserPhoneModificationView.h"
#import "CustomArticleAlertView.h"
@implementation UserPhoneModificationView
{
    
    UILabel * _new_phoneNumber_label;
    UITextField * _phoneNumber_field;
    UIButton * _btn_cancel;
    UIButton * _btn_confirm;
    
}
@synthesize old_phoneNumber_label=_old_phoneNumber_label;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    _customTitleBar.titleText=NSLocalizedStringFromTable(@"userManagement_phone_modification_title", Res_String, @"");
       
        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_back_to_home",Res_Image,@"")];        
        UIImage * old_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_cancle_btn_backgroud_img",Res_Image,@"")];
        UIImageView * oldNumberView=[[UIImageView alloc]initWithFrame:CGRectMake(10, _customTitleBar.frame.origin.y+_customTitleBar.frame.size.height+10, old_img.size.width, old_img.size.height)];
        oldNumberView.image=old_img;
        _old_phoneNumber_label=[[UILabel alloc]initWithFrame:CGRectMake(10, (oldNumberView.frame.size.height-15)/2, 200, 15)];
        NSString * oldText =NSLocalizedStringFromTable(@"phone_modification_old_label", Res_String, @"");
        _old_phoneNumber_label.text=[NSString stringWithFormat:@"%@%@", oldText, self.string];
        [oldNumberView addSubview:_old_phoneNumber_label];
        UIImage * new_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_phone_modification",Res_Image,@"")];
        UIImageView * newNumberView=[[UIImageView alloc]initWithFrame:CGRectMake(10, oldNumberView.frame.origin.y+oldNumberView.frame.size.height+5, new_img.size.width, new_img.size.height)];
        newNumberView.image=new_img;
        newNumberView.userInteractionEnabled=YES;
        _new_phoneNumber_label=[[UILabel alloc]initWithFrame:CGRectMake(10, (oldNumberView.frame.size.height-15)/2, 15*5, 15)];
        _new_phoneNumber_label.text=NSLocalizedStringFromTable(@"phone_modification_new_label", Res_String, @"");
        _phoneNumber_field=[[UITextField alloc]initWithFrame:CGRectMake(_new_phoneNumber_label.frame.origin.x+_new_phoneNumber_label.frame.size.width, (oldNumberView.frame.size.height-15)/2, 188, 15)];
        _phoneNumber_field.userInteractionEnabled=YES;
        _phoneNumber_field.borderStyle = UITextBorderStyleNone;
        _phoneNumber_field.font=[UIFont systemFontOfSize:15];
        _phoneNumber_field.clearButtonMode = UITextFieldViewModeNever;
        _phoneNumber_field.autocorrectionType = UITextAutocorrectionTypeNo;
        _phoneNumber_field.textAlignment = UITextAlignmentLeft;
        _phoneNumber_field.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumber_field.returnKeyType =UIReturnKeyDone;
        _phoneNumber_field.clearButtonMode=UITextFieldViewModeAlways;
        _phoneNumber_field.delegate=self;
        _phoneNumber_field.textColor= [UIColor colorWithRed:44.0f/255.0f green:50.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
        [newNumberView addSubview:_new_phoneNumber_label];
        [newNumberView addSubview:_phoneNumber_field];
        [self addSubview:newNumberView];
        [self addSubview:oldNumberView];
          UIImage * _img_cancel=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_btn_cancel",Res_Image,@"")];
        _btn_cancel=[[UIButton alloc]initWithFrame:CGRectMake(oldNumberView.frame.origin.x, newNumberView.frame.origin.y+newNumberView.frame.size.height+15, _img_cancel.size.width, _img_cancel.size.height)];
        [_btn_cancel setTitle:NSLocalizedStringFromTable(@"btn_cancel", Res_String, @"") forState:UIControlStateNormal];
        _btn_cancel.titleLabel.font=[UIFont systemFontOfSize:15];
        [_btn_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_cancel setBackgroundImage:_img_cancel forState:UIControlStateNormal];
          UIImage * _img_confirm=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_btn_confirm",Res_Image,@"")];
        _btn_confirm=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-10-_img_confirm.size.width, newNumberView.frame.origin.y+newNumberView.frame.size.height+15, _img_confirm.size.width, _img_confirm.size.height)];
        [_btn_confirm setTitle:NSLocalizedStringFromTable(@"btn_confirm", Res_String, @"") forState:UIControlStateNormal];
        _btn_confirm.titleLabel.font=[UIFont systemFontOfSize:15];
        [_btn_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_confirm setBackgroundImage:_img_confirm forState:UIControlStateNormal];
        [_btn_cancel addTarget:self action:@selector(buttonCancelTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_btn_confirm  addTarget:self action:@selector(buttonConfirmTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];        
        [self addSubview:_btn_cancel];
        [self addSubview:_btn_confirm];
          
   }
    return self;
}
-(void)buttonCancelTouchUpInside:(id)sender{
     [_phoneNumber_field resignFirstResponder];
}
-(void)buttonConfirmTouchUpInside:(id)sender{
    if(_phoneNumber_field.text.length==0){
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"您输入电话号码有误" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"", nil];
        [alert show];
        return;
    }else{
    [self.delegate updateMobilePhones:_phoneNumber_field.text];
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

@end
