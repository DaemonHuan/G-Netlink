//
//  CustomPINPopView.m
//  G-NetLink
//
//  Created by 罗眯眯 on 14-10-12.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "CustomPinPopView.h"
#import "ResDefine.h"

@interface CustomPinPopView()
{
    int timeNum;
    NSTimer * timer;
    UIView *verifyCodeView;
}

@end

@implementation CustomPinPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        timeNum = 60;
        
        CGRect backgroundFrame = frame;
        backgroundFrame.origin.x = 0;
        backgroundFrame.origin.y = 0;
        _backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundFrame];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        UIImage *image = [UIImage imageNamed:NSLocalizedStringFromTable(@"vehicle_popmenu_background",Res_Image,@"")];
        _backgroundImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(3,3,3,3)];
        _backgroundImageView.userInteractionEnabled = YES;
        _backgroundImageView.layer.cornerRadius = 2;
        _backgroundImageView.layer.masksToBounds = YES;
        _backgroundImageView.hidden = NO;
        [self addSubview:_backgroundImageView];
        
        UIImage *textLineImage =[UIImage imageNamed:NSLocalizedStringFromTable(@"pin_pop_txt_line",Res_Image,@"")];
        
        //提示文字
        _titleInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-textLineImage.size.width/2, 15, 230, 30)];
        _titleInfoLabel.numberOfLines = 0;
        _titleInfoLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleInfoLabel.textColor = [UIColor whiteColor];
        _titleInfoLabel.textAlignment = NSTextAlignmentLeft;
        _titleInfoLabel.backgroundColor = [UIColor clearColor];
        [_backgroundImageView addSubview:_titleInfoLabel];
        
        CGFloat titleMaxY = CGRectGetMaxY(_titleInfoLabel.frame);
        
    
        //PIN码输入框View
        UIImageView *iconImageView=[[UIImageView alloc] initWithImage:textLineImage];
        UIView *pinCodeView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-textLineImage.size.width/2+5, titleMaxY, iconImageView.bounds.size.width, 40)];
        CGRect iconImageViewFrame = iconImageView.frame;
        iconImageViewFrame=iconImageView.frame;
        iconImageViewFrame.origin.y=pinCodeView.bounds.size.height-iconImageView.bounds.size.height;
        iconImageView.frame=iconImageViewFrame;
        [pinCodeView addSubview:iconImageView];
        
        _pinCodeTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 10, iconImageView.frame.size.width, 30)];
        _pinCodeTextField.font = [UIFont systemFontOfSize:14];
        _pinCodeTextField.textColor = [UIColor whiteColor];
        _pinCodeTextField.contentPlaceholder = NSLocalizedStringFromTable(@"PINCode_verify",Res_String,@"");
        _pinCodeTextField.placeholderColor = [UIColor colorWithRed:145/255.0 green:149/255.0 blue:157/255.0 alpha:1];
        [pinCodeView addSubview:_pinCodeTextField];
        [_backgroundImageView addSubview:pinCodeView];
        
        CGFloat pinCodeViewMaxY = CGRectGetMaxY(pinCodeView.frame);
        
        //短信效验码输入框View
        iconImageView =[[UIImageView alloc] initWithImage:textLineImage];
        verifyCodeView = [[UIView alloc] initWithFrame:CGRectMake(pinCodeView.frame.origin.x, pinCodeViewMaxY, pinCodeView.bounds.size.width, 40)];
        iconImageViewFrame=iconImageView.frame;
        iconImageViewFrame.origin.y=pinCodeView.bounds.size.height-iconImageView.bounds.size.height;
        iconImageView.frame=iconImageViewFrame;
        [verifyCodeView addSubview:iconImageView];
        
        _verifyCodeTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 10, _pinCodeTextField.bounds.size.width-80, 30)];
        _verifyCodeTextField.font = [UIFont systemFontOfSize:14];
        _verifyCodeTextField.textColor = [UIColor whiteColor];
        _verifyCodeTextField.contentPlaceholder = NSLocalizedStringFromTable(@"verify_Code",Res_String,@"");
        _verifyCodeTextField.placeholderColor = [UIColor colorWithRed:145/255.0 green:149/255.0 blue:157/255.0 alpha:1];
        [verifyCodeView addSubview:_verifyCodeTextField];
        
        //获取短信验证码按钮
        _getVerifyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getVerifyCodeBtn.backgroundColor = [UIColor colorWithRed:84/255.0 green:112/255.0 blue:177/255.0 alpha:1];
        _getVerifyCodeBtn.layer.masksToBounds = YES;
        _getVerifyCodeBtn.layer.cornerRadius = 5;
        [_getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getVerifyCodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _getVerifyCodeBtn.frame = CGRectMake(verifyCodeView.bounds.size.width - 106, 6, 100, 30);
        _getVerifyCodeBtn.contentEdgeInsets = UIEdgeInsetsMake(7, 5, 5, 5);
        _getVerifyCodeBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_getVerifyCodeBtn addTarget:self action:@selector(getVerifyCodeBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [verifyCodeView addSubview:_getVerifyCodeBtn];
        [_backgroundImageView addSubview:verifyCodeView];
        

        //取消和确认按钮
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        CGFloat btnH = 45;
        CGFloat btnW = self.bounds.size.width * 0.5;
        _cancelBtn.frame = CGRectMake(0, self.bounds.size.height - btnH, btnW, btnH);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_backgroundImageView addSubview:_cancelBtn];
        
        CGFloat cancelBtnMaxX = CGRectGetMaxX(_cancelBtn.frame);
        
        iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"pop_divider_line",Res_Image,@"")]];
        iconImageView.frame = CGRectMake(cancelBtnMaxX, _cancelBtn.frame.origin.y+12, iconImageView.bounds.size.width, iconImageView.bounds.size.height);
        
        [_backgroundImageView addSubview:iconImageView];

        _sendCommandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendCommandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendCommandBtn.frame = CGRectMake(cancelBtnMaxX, _cancelBtn.frame.origin.y, btnW, btnH);
        [_sendCommandBtn setTitle:@"确认发送" forState:UIControlStateNormal];
        _sendCommandBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_backgroundImageView addSubview:_sendCommandBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _cancelBtn.frame.origin.y, self.bounds.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:71/255.0 green:81/255.0 blue:97/255.0 alpha:1];
        [_backgroundImageView addSubview:line];
        
    }
    
    return self;
}

- (void)setEventObserver:(id<CustomPinPopDelegate,TextFiledReturnEditingDelegate>)eventObserver
{
    _eventObserver = eventObserver;
    [_cancelBtn addTarget:eventObserver action:@selector(cancelBtn_onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sendCommandBtn addTarget:eventObserver action:@selector(sendCommandBtn_onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_pinCodeTextField addTarget:eventObserver action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_verifyCodeTextField addTarget:eventObserver action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _pinCodeTextField.observer = _eventObserver;
    _verifyCodeTextField.observer = _eventObserver;
}

- (void)getVerifyCodeBtnOnClick:(UIButton *)getVeryCodeBtn
{
    if ([self.eventObserver respondsToSelector:@selector(getVerifyCodeBtn_onClick:)]) {
        [self.eventObserver getVerifyCodeBtn_onClick:getVeryCodeBtn];
    }
    timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(btnGetVerifyCodeOnClick) userInfo:nil repeats:YES];
    [timer fire];
    _getVerifyCodeBtn.userInteractionEnabled=NO;
}

- (void)btnGetVerifyCodeOnClick
{
    _getVerifyCodeBtn.frame = CGRectMake(verifyCodeView.bounds.size.width - 96, 6, 90, 30);
    NSString * stirng= [NSString stringWithFormat:@"%@ %d",@"获取中",--timeNum];
    [_getVerifyCodeBtn setTitle:stirng forState:UIControlStateNormal];
    if (timeNum == 0) {
        [_getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getVerifyCodeBtn.frame = CGRectMake(verifyCodeView.bounds.size.width - 106, 6, 100, 30);
        _getVerifyCodeBtn.userInteractionEnabled=YES;
        timeNum = 60;
        [timer invalidate];
        timer = nil;
    }
}

- (void)setControlContent:(NSString *)controlContent
{
    _controlContent = controlContent;
    _titleInfoLabel.text = [NSString stringWithFormat:@"您正在发送%@控制指令，请您输入以下信息:",controlContent];
    CGSize textSize = [_titleInfoLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(_titleInfoLabel.bounds.size.width+38, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    _titleInfoLabel.frame = CGRectMake(15, 8, self.bounds.size.width - 30, textSize.height);
}

@end
