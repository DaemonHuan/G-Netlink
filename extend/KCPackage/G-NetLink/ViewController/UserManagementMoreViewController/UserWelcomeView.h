//
//  UserWelcomeView.h
//  G-NetLink
//
//  Created by liuxiaobo on 14-5-5.
//  Copyright (c) 2014年 95190. All rights reserved.
//
@protocol UserWelcomeViewDelegate <NSObject>
-(void)userWelcomeViewDelegateGoHome;

@end
#import "TitleBarAndScrollerView.h"

@interface UserWelcomeView : TitleBarAndScrollerView<UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>
@property (nonatomic,assign)id<UserWelcomeViewDelegate>delegate;
@end
