//
//  ProgressUIHelper.h
//  G-Netlink-beta0.2
//
//  Created by Walker Liu on 11/4/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface ProgressUIHelper : NSObject

+ (void)showToast:(NSString*)text view:(UIView*)v seconds:(NSInteger)sec;

@end
