//
//  PhoneNumberViewController.h
//  G-NetLink
//
//  Created by liuxiaobo on 15/1/21.
//  Copyright (c) 2015年 95190. All rights reserved.
//

#import "BaseViewController.h"
#import "PhoneNumberTabelViewCellTableViewCell.h"
@interface PhoneNumberViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,DataModuleDelegate,CustomTitleBar_ButtonDelegate,PhoneNumberTabelViewCellTableViewCellDelegate>

@end
