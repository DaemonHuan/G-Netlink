//
//  HallView.h
//  G-NetLink
//
//  Created by jayden on 14-4-24.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarAndScrollerView.h"
@protocol HallViewDelegate <NSObject>
@optional
-(void)inquiryBtn_onClick_delegate;//车况查询
-(void)helpBtn_onClick_delegate;//一键救援
-(void)locationBtn_onClick_delegate;//车辆位置
-(void)navigationBtn_onClick_delegate;//一键导航
@end
@interface HallView : TitleBarAndScrollerView<HallViewDelegate,CustomTitleBar_ButtonDelegate>
@property(nonatomic,assign)id<HallViewDelegate> delegate;
@property (nonatomic,assign)int   number;
@property(nonatomic)UILabel * nav_right_btn_number_label;
@property (nonatomic)UIImageView *nav_right_btn_number;
-(void)rightLabelNumber;
@end
