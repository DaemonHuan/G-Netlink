//
//  UserWelcomeViewController.h
//  G-NetLink
//
//  Created by liuxiaobo on 14-5-5.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseViewController.h"
#import "UserWelcomeView.h"
@interface UserWelcomeViewController : BaseViewController<UIScrollViewDelegate,UserWelcomeViewDelegate>
@property (nonatomic, strong) NSArray *contentList;
@end
