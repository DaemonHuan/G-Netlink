//
//  PushNotification.m
//  G-NetLink
//
//  Created by 95190 on 14-5-7.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "PushNotification.h"

static PushNotification *pushNotification;

@interface PushNotification() 
@end

@implementation PushNotification


- (id) init {
    self = [super init];
    return self;
}

+ (PushNotification *) sharePushNotification {
    if(pushNotification == nil)
        pushNotification = [[self alloc] init];
    return pushNotification;
}

- (void) applyForPushNotification:(NSDictionary *)launchingOption {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

- (void) registerDeviceToken:(NSData *)deviceToken {
    
}

- (void) receivePushNotification:(NSDictionary *)userInfo {
    if(self.observer != nil && [self.observer respondsToSelector:@selector(didReceivePushNotification:)])
    {
        if(![self.observer didReceivePushNotification:userInfo])
            [self performSelector:@selector(receivePushNotification:) withObject:userInfo afterDelay:2];
    }
}

- (void) receiveForegroundPushNotification:(NSDictionary *)userInfo {
    if(self.observer != nil && [self.observer respondsToSelector:@selector(didReceiveForegroundPushNotification:)])
    {
        if(![self.observer didReceiveForegroundPushNotification:userInfo])
            [self performSelector:@selector(receiveForegroundPushNotification:) withObject:userInfo afterDelay:2];
    }
}

- (void) setApplicationIconBadgeNumber:(NSInteger)applicationIconBadgeNumber {
    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:applicationIconBadgeNumber];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (NSInteger) applicationIconBadgeNumber {
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}

- (void)resetJpushApplicationBadgeNumber {
    
}

@end
