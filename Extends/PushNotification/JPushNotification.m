//
//  JPushNotification.m
//  G-NetLink
//
//  Created by jayden on 14-5-7.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "JPushNotification.h"
#import "APService.h"

@implementation JPushNotification
- (void)applyForPushNotification:(NSDictionary *)launchingOption {
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
#endif
    // Required
    [APService setupWithOption:launchingOption];
}

- (void) registerDeviceToken:(NSData*)deviceToken {
     [APService registerDeviceToken:deviceToken];
}

-(void) receivePushNotification:(NSDictionary*)userInfo {
    [super receivePushNotification:userInfo];
    [APService handleRemoteNotification:userInfo];
    NSLog(@"%@",userInfo);
}

- (void) receiveForegroundPushNotification:(NSDictionary *)userInfo {
    [super receiveForegroundPushNotification:userInfo];
    [APService handleRemoteNotification:userInfo];
    NSLog(@"Foreground - %@",userInfo);
}

-(void) registerUserTags:(NSSet *)tags andAlias:(NSString*)alias callbackSelector:(SEL) sel target:(id)observer {
    [APService setTags:tags alias:alias callbackSelector:sel target:observer];
}

- (void) resetJpushApplicationBadgeNumber {
    [APService resetBadge];
}

@end
