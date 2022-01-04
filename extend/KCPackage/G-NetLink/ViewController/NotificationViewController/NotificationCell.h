//
//  NotificationCell.h
//  G-NetLink
//
//  Created by liuxiaobo on 14-5-6.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotificationCell;
@protocol NotificationCell_ButtonDelegate <NSObject>
-(void)selectButton_onClick:(NotificationCell*)cell;
@end

@interface NotificationCell : UITableViewCell
{
@protected
    BOOL _editStatus;
    BOOL _selectStatus;
    BOOL _readStatus;
}
@property ( nonatomic, weak) NSString * titleString;
@property (nonatomic, weak) NSString * textString;
@property(nonatomic)BOOL editStatus;
@property(nonatomic)BOOL selectStatus;
@property(nonatomic)BOOL readStatus;
@property(nonatomic,assign)id<NotificationCell_ButtonDelegate> observer;
+(double)calculateCellHeight;
-(void)setEditStatus:(BOOL)editStatus isRead:(BOOL)readStatus;
@end
