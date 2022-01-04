//
//  AppDelegate.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/8/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#import "LoginViewController.h"
#import "jkGuideViewController.h"
#import "JPushNotification.h"
#import "MobClick.h"

#import <MAMapKit/MAMapKit.h>
#import "public.h"

@interface AppDelegate() {
    PushNotification *jpush;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    //    [self.window setBackgroundColor: [UIColor clearColor]];
    [self.window makeKeyAndVisible];

    // 标记运行
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }

    // 状态栏 文字颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    LoginViewController * loginview = [[LoginViewController alloc] init];
    UINavigationController * hiddenNavigation = [[UINavigationController alloc] initWithRootViewController:loginview];
    [hiddenNavigation.navigationBar setShadowImage:[[UIImage alloc]init]];
    [hiddenNavigation.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [hiddenNavigation.navigationBar setTranslucent: YES];

    [self.window setRootViewController: hiddenNavigation];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [jkGuideViewController show];
    }

    // @TODO：启动友盟统计，实际发布需要替换成正式的APP KEY和渠道名，“”代表APP STORE
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    // 设置为最小间隔发送
    [MobClick startWithAppkey:@"56b195e9e0f55ae8d1000b9f" reportPolicy:SEND_INTERVAL   channelId:nil];
    
    [MAMapServices sharedServices].apiKey = MAP_BUNDLEIDENTIFIER;
    
    //注册极光推送
    jpush=[JPushNotification sharePushNotification];
    [jpush applyForPushNotification:launchOptions];
    
    if ([jpush applicationIconBadgeNumber] > 0) {
        [jpush setApplicationIconBadgeNumber:1];
        [jpush setApplicationIconBadgeNumber:0];
    }
    
    if (launchOptions != nil) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [jpush receivePushNotification:userInfo];
    }

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if ([jpush applicationIconBadgeNumber] > 0) {
        [jpush resetJpushApplicationBadgeNumber];
        [jpush setApplicationIconBadgeNumber:1];
        [jpush setApplicationIconBadgeNumber:0];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_WillEnterForeground" object:nil userInfo:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([jpush applicationIconBadgeNumber] > 0) {
        [jpush setApplicationIconBadgeNumber:1];
        [jpush setApplicationIconBadgeNumber:0];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [jpush registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if(application.applicationState == UIApplicationStateInactive) {
        [jpush resetJpushApplicationBadgeNumber];
        [jpush setApplicationIconBadgeNumber:1];
        [jpush setApplicationIconBadgeNumber:0];
        [jpush receivePushNotification:userInfo];
    } else if (application.applicationState == UIApplicationStateActive) {
        [jpush receiveForegroundPushNotification:userInfo];
    }
}

#ifdef __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateInactive) {
        [jpush resetJpushApplicationBadgeNumber];
        [jpush setApplicationIconBadgeNumber:1];
        [jpush setApplicationIconBadgeNumber:0];
        [jpush receivePushNotification:userInfo];
    } else if (application.applicationState == UIApplicationStateActive) {
        [jpush resetJpushApplicationBadgeNumber];
        [jpush setApplicationIconBadgeNumber:1];
        [jpush setApplicationIconBadgeNumber:0];
        [jpush receiveForegroundPushNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNoData);
}
#endif

@end


@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
