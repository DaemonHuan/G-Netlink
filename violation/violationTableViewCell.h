//
//  violationTableViewCell.h
//  G-Netlink-beta0.2
//
//  Created by jk on 11/19/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface violationTableViewCell : UITableViewCell

- (void) setCellDetail: (NSString *)title Detail:(NSString *)detail;
- (void) setCellValue:(NSString *)time Value:(NSString *)value Pay:(NSString *)money;

@end
