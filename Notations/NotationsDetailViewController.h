//
//  NotationsDetailViewController.h
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotationsDetailViewController : UIViewController

@property (nonatomic, retain) NSString * itemTime;
@property (nonatomic, retain) NSString * itemSource;
@property (nonatomic, retain) NSString * itemTitle;

- (void) setItemValue:(NSString *)time From:(NSString *)source Title:(NSString *)title;
- (void) setItemDetail:(NSString *)value;

@end
