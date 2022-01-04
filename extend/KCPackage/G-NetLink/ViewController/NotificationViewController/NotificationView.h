//
//  NotificationView.h
//  G-NetLink
//
//  Created by liuxiaobo on 14-5-5.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarAndScrollerView.h"
#import "TitleBarAndPullRefreshTableView.h"
@protocol NotificationNewsView_ButtonDelegate <NSObject>
-(void)tableViewDelete;
-(void)tableViewSelect;
-(void)tableViewCancel;
-(void)tableViewEdit;


@end
@interface NotificationView : TitleBarAndPullRefreshTableView
@property(nonatomic)BOOL editing;
@property(nonatomic,readonly)UIButton * editBtn;
@property(nonatomic,readonly)UIImageView * backgroundImgView;
@property(nonatomic,assign)id<NotificationNewsView_ButtonDelegate,UITableViewDelegate> delegate;

-(void)setEditStatus:(BOOL)status;


@end
