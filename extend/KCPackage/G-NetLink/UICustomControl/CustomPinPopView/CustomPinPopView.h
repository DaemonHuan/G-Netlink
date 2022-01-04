//
//  CustomPINPopView.h
//  G-NetLink
//
//  Created by 罗眯眯 on 14-10-12.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "TextFiledReturnEditingDelegate.h"

@protocol CustomPinPopDelegate <NSObject>

@optional
-(IBAction)cancelBtn_onClick:(id)sender;
-(IBAction)sendCommandBtn_onClick:(id)sender;
-(IBAction)getVerifyCodeBtn_onClick:(id)sender;
-(void)textFieldReturn:(id)sender;


@end

@interface CustomPinPopView : UIView
{
    @private
    __weak id _eventObserver;
}

@property(nonatomic,weak) id<CustomPinPopDelegate> eventObserver;
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UILabel *titleInfoLabel;
@property (nonatomic,strong) NSString *controlContent;
@property (nonatomic,strong) CustomTextField *pinCodeTextField;
@property (nonatomic,strong) CustomTextField *verifyCodeTextField;
@property (nonatomic,strong) UIButton *getVerifyCodeBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *sendCommandBtn;

@end
