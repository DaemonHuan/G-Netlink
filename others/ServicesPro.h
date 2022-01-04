//
//  ServicesPro.h
//  G-NetLink-v1.0
//
//  Created by jk on 12/14/15.
//  Copyright © 2015 jk. All rights reserved.
//

// **** **** **** **** **** **** ****
// public Functions to Class     ****
// **** **** **** **** **** **** ****

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ServicesPro : NSObject

+ (void) doCallForHelp;
+ (NSString *) stringReplaceWithStar:(NSString *)str;
+ (NSDate *) toLocalTime:(NSString *) stime;
+ (UIView *) loadMarkDemoView;

+ (NSString *) getWebErrorMessage:(NSString *)code;
+ (NSString *) getServerErrorMessage:(NSString *)code;
+ (NSString *) getViolationMessage:(NSString *)code;

+ (UIImage *) imageScaleToSize:(UIImage *)img size:(CGSize)size;
@end
