//
//  VehicleTableViewCell.h
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleTableViewCell : UITableViewCell

- (void) setItemValue:(NSString *)name Checked:(BOOL)value;
- (void) setItemCode:(NSString *)code;

@end
