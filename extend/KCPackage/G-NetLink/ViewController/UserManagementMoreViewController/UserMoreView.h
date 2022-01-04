//
//  UserMoreView.h
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarAndBeforeIos7StyleOfTableView.h"
#import "CustomUISwitch.h"
#import "Message.h"
@protocol  UserMoreViewDelegate<NSObject>
@optional
-(void)sendMessageDelegate:(NSIndexPath*)indexPath;

-(void)clientVersionAutoUpdate:(BOOL)autoUpdate;
@end
@interface UserMoreView : TitleBarAndBeforeIos7StyleOfTableView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)id<UserMoreViewDelegate> delegate;
@property (nonatomic,assign)BOOL autoUpdateFlag;
@end
