//
//  NotificationViewController.h
//  G-NetLink
//
//  Created by liuxiaobo on 14-5-5.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseViewController.h"
#import "PullRefreshTableViewDelegate.h"
#import "NotificationView.h"
@interface NotificationViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,NotificationNewsView_ButtonDelegate>

@end
