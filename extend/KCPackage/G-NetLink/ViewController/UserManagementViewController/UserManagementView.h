//
//  UserManagementView.h
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-28.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarAndTableView.h"
@protocol  UserManagementViewDelegate<NSObject>
@optional
-(void)sendMessageDelegate:(NSIndexPath*)indexPath;
-(void)userlogout;
@end
@interface UserManagementView : TitleBarView<CustomTitleBar_ButtonDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property(nonatomic,assign)id<UserManagementViewDelegate> delegate;
@end

