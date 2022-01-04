//
//  UserPhoneModificationView.h
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarAndScrollerView.h"
@protocol  UserPhoneModificationDelegate<NSObject>
@optional
-(void)updateMobilePhones:(NSString*)string;
@end
@interface UserPhoneModificationView : TitleBarAndScrollerView<UITextFieldDelegate>
@property (nonatomic,weak)NSString * string;
@property (nonatomic)UILabel * old_phoneNumber_label;
@property(nonatomic,assign)id<UserPhoneModificationDelegate> delegate;
@end
