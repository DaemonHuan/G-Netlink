//
//  CarInfoTableViewCell.h
//  G-NetLink-v1.0
//
//  Created by jk on 2/24/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarInfoTableViewCell : UITableViewCell

- (void) setItemValue:(NSString *)title Value:(NSString *)value;
- (void) setItemIconHidden:(BOOL)car IntoIcon:(BOOL)into;

@end
