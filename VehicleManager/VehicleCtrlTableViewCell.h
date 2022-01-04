//
//  VehicleCtrlTableViewCell.h
//  G-NetLink-v2.0
//
//  Created by jk on 5/19/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleCtrlTableViewCell : UITableViewCell

- (void) setItemValue:(NSString *)time Title:(NSString *)title;
- (void) setItemStatus:(BOOL) flag;

@end
