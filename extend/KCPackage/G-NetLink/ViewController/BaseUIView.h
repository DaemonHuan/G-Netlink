//
//  BaseUIView.h
//  ZhiJiaX
//
//  Created by 95190 on 13-5-14.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResDefine.h"

@interface BaseUIView : UIView
{
}
@property(nonatomic,assign)UIView *activeKeyboardControl;//同activeKeyboardControlOfScrollView配对使用，针对于被键盘遮挡的情况进行的处理。
@property(nonatomic,assign)UIScrollView *activeKeyboardControlOfScrollView;
-(void)keepOutViewWillShown:(UIView*)view;
-(void)keepOutViewWasHidden;
@end
