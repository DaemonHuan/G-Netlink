//
//  MainNavigationController.h
//  G-NetLink-v2.0
//
//  Created by jk on 3/15/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"

@interface MainNavigationController : UINavigationController <ICSDrawerControllerChild, ICSDrawerControllerPresenting> {
}

@property(nonatomic, weak) ICSDrawerController *drawer;

- (void) openDrawer:(id)sender;
- (void) doLogoff:(NSString *) userinfo;

- (void) doSwitchViewController;

@end
