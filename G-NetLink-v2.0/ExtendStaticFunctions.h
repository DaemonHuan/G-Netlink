//
//  ExtendStaticFunctions.h
//  G-NetLink-v2.0
//
//  Created by jk on 3/18/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExtendStaticFunctions : NSObject

+ (void) doCallForHelp:(NSString *) code;
+ (void) doCallForKCHelp;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (NSString *) stringReplaceWithStar:(NSString *)str;
+ (NSDate *) toLocalTime:(NSString *) stime;

+ (NSString *) getWebErrorMessage:(NSString *)code;
+ (NSString *) getServerErrorMessage:(NSString *)code;
+ (NSString *) getViolationMessage:(NSString *)code;

+ (void) doSetUserDefaults: (NSString *)str withKey:(NSString *)key;
+ (NSString *) getUserDefaultsWithKey:(NSString *)key;
+ (void) doRemoveDefaultsWithKey: (NSString *)key;

@end
