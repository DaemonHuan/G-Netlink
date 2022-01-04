//
//  UserFeedbackView.h
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarAndScrollerView.h"
@protocol  UserFeedbackViewDelegate<NSObject>
@optional
-(void)delegateCommitFeed:(NSString  *)feed withContract:(NSString  *)contact;
-(void)textFieldDidEndEditingSave:(NSString*)saveStrng;
-(void)textViewDidEndEditingSave:(NSString*)saveStrng;
-(void)submitDelegate;
@end
@interface UserFeedbackView : TitleBarAndScrollerView<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,assign)id<UserFeedbackViewDelegate>feedDelegate;
@property (nonatomic)UITextView * textView;
@property (nonatomic) UITextField * phoneFileld;
@property (nonatomic)UILabel *  rightLable;
@end
