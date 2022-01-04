//
//  PhoneNumberTabelViewCellTableViewCell.m
//  G-NetLink
//
//  Created by liuxiaobo on 15/1/21.
//  Copyright (c) 2015年 95190. All rights reserved.
//

#import "PhoneNumberTabelViewCellTableViewCell.h"
#import "ResDefine.h"
@implementation PhoneNumberTabelViewCellTableViewCell
{
    UIButton * _button;
    NSString * _mobile_phone;
    UILabel * label_phone_number;
    UITextField * textField;
    BOOL  _exist;
}
- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
       
    }
    return self;
}
-(void)loadCellView:(BOOL)isExist    andPhoneTitle:(NSString*)title  PhoneNumber:(NSString *)phoneNumber
{
    _exist = isExist;
    
    UIImage * cell_background_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_cell_background", Res_Image, @"")];
    UIImage * buttonImg =[UIImage imageNamed:NSLocalizedStringFromTable(@"binding_phone", Res_Image, @"")];
    UIButton * button;
   
    if (_exist)
    {
        buttonImg =[UIImage imageNamed:NSLocalizedStringFromTable(@"remove_phone", Res_Image, @"")];
        textField = nil;
        
        UILabel * label_title = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 100, self.frame.size.height - 14)];
//        label_title.text =[NSString stringWithFormat:@"已绑定号码%d:",indexPath.row+1];
        label_title.text = title;
        label_title.textColor = [UIColor whiteColor];
        label_title.textAlignment = NSTextAlignmentCenter;
        label_title.font = [UIFont systemFontOfSize:13];
        //        label_title.backgroundColor = [UIColor yellowColor];
        [self addSubview:label_title];
        
        label_phone_number= [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label_title.frame), 8, 100, self.frame.size.height - 14)];
        label_phone_number.text = phoneNumber;
        label_phone_number.textColor = [UIColor brownColor];
        label_phone_number.font = [UIFont systemFontOfSize:13];
        label_phone_number.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label_phone_number];
    }
    else
    {
        textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 10, cell_background_img.size.width -110, self.frame.size.height-20)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = @"单击添加手机号码";
        textField.font = [UIFont systemFontOfSize:13];
        textField.backgroundColor = [UIColor whiteColor];
        [self addSubview:textField];
    }
    
    button =[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-45-buttonImg.size.width, (self.frame.size.height- buttonImg.size.height)/2, buttonImg.size.width, buttonImg.size.height)];
    [button setBackgroundImage:buttonImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];

}

-(void)buttonOnClick
{
    if (_exist)
    {
        _mobile_phone = label_phone_number.text;
    }else
        _mobile_phone = textField.text;
        
    [self.delegate buttonOnClickDelegate:_mobile_phone andOperate:_exist];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
