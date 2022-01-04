//
//  DateSelectorView.h
//  G-Netlink-beta0.2
//
//  Created by jk on 11/4/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateSelectorView : UIView {
    UITextField * tfStartTime;
    UITextField * tfEndTime;
    UIDatePicker * DateSelector;
}

- (void) createView;

- (NSString *) getStartTime;
- (NSString *) getEndTime;

@end