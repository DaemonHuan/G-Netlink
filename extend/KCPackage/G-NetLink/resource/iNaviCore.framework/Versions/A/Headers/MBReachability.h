//
//  MBReachability.h
//  iNaviCore
//
//  Created by fanyl on 14-6-19.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#if !__has_feature(objc_arc)
//#error "This source file must be compiled with ARC enabled!"
#endif

typedef enum : NSInteger {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN
} NetworkStatus;

extern NSString *kMBReachabilityChangedNotification;

@interface MBReachability : NSObject

+(MBReachability *)reachabilityForInternetConnection;

-(BOOL)isReachable;

/*!
 * Start listening for reachability notifications on the current run loop. Return Yes if listening success.
 */
- (BOOL)startNotifier;
- (void)stopNotifier;
- (NetworkStatus)currentReachabilityStatus;
@end
