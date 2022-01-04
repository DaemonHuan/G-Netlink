//
//  PushNotification.h
//  G-NetLink
//
//  Created by 95190 on 14-5-7.
//  Copyright (c) 2014年 95190. All rights reserved.
//


@protocol PushNotificationDelegate <NSObject>
@optional
//返回YES表示可以接受并处理该消息，返回NO表示目前无法处理该消息需要延时再次发送。
-(BOOL)didReceivePushNotification:(NSDictionary*)userInfo;
-(BOOL)didReceiveForegroundPushNotification:(NSDictionary *)userInfo;
@end

@interface PushNotification : NSObject
{

}
@property(nonatomic) int applicationIconBadgeNumber;
@property(nonatomic,assign)id<PushNotificationDelegate> observer;
+(PushNotification*)sharePushNotification;
//根据不同的第三方推送包进行该方法的重写,重写后不调用父类的该方法。
-(void)applyForPushNotification:(NSDictionary *)launchingOption;
//根据不同的第三方推送包进行该方法的重写,重写后不调用父类的该方法。
-(void)registerDeviceToken:(NSData*)deviceToken;
//根据不同的第三方推送包进行该方法的重写。
-(void)receivePushNotification:(NSDictionary*)userInfo;
-(void)receiveForegroundPushNotification:(NSDictionary *)userInfo;
-(void)resetJpushApplicationBadgeNumber;
@end
