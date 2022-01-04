//
//  WarningTableViewCell.h
//  G-NetLink-v1.0
//
//  Created by jk on 12/15/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WARNING_ERROR @"warn_error"
#define WARNING_OK @"warn_ok"

@interface WarningTableViewCell : UITableViewCell

- (void) setItemIconWithTitle:(NSString *)image Title:(NSString *)title;
- (void) setItemStatus:(NSString *)status;

@end
