//
//  MaplineTableViewCell.h
//  G-NetLink-v2.0
//
//  Created by jk on 3/29/17.
//  Copyright © 2017 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaplineTableViewCell : UITableViewCell

- (void) setCellWithTitle:(NSString *) title Icon:(NSString *)icon;
- (void) setSwitchFlag:(BOOL) flag;

@end
