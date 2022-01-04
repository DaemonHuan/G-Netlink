//
//  NotationsTableViewCell.h
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotationsTableViewCell : UITableViewCell

- (void) setItemFlagIcon:(BOOL)flag Icon:(NSString *)icon;
- (void) setItemTitle:(NSString *)title Contains:(NSString *)contains;
- (void) setItemTime:(NSString *)time;

@end
