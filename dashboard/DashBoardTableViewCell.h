//
//  DashBoardTableViewCell.h
//  G-NetLink-v1.0
//
//  Created by jk on 12/14/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardTableViewCell : UITableViewCell

- (void) setItemIcon: (NSString *)name;
- (void) setItemTitle:(NSString *)text;
- (void) setItemValue:(NSString *)value;

@end
