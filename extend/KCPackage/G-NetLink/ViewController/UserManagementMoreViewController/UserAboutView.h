//
//  UserAboutView.h
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarAndScrollerView.h"
#import "AttributedLabel.h"
@interface UserAboutView : TitleBarAndScrollerView
@property (nonatomic)AttributedLabel * textLabel;
-(void)setClientVersion:(NSString*)clientText;
@end
