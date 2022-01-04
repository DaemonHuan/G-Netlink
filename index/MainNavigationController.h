//
//  MainNavigationController.h
//  G-NetLink-v1.0
//
//  Created by jk on 12/7/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNavigationController : UINavigationController

- (void) leftItemClicked;
- (void) doSwitchView:(NSString *)code;
- (void) setMainViewController:(UIViewController *)view;
- (void) turntoLoginForOut;

- (void) setTtilelisence;

@end
