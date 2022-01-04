//
//  AppDelegate.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/14/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"
#import "jkGuideViewController.h"
#import "public.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "MobClick.h"
#import "JPushNotification.h"

#import <UIKit/UIDevice.h>

@interface AppDelegate() {
    PushNotification *jpush;
}

@end

// **** **** HTTPS **** ****
@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    return YES;
}
@end
// **** **** END **** ****

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    // 状态栏字体颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // 高德地图API Key
    [MAMapServices sharedServices].apiKey = MAP_BUNDLEIDENTIFIER;
    [AMapSearchServices sharedServices].apiKey = MAP_BUNDLEIDENTIFIER;
    
    // 标记运行
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }

    LoginViewController * view = [[LoginViewController alloc]init];
    UINavigationController * navgation = [[UINavigationController alloc]initWithRootViewController:view];
    [navgation.navigationBar setShadowImage:[[UIImage alloc]init]];
    [navgation.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [navgation.navigationBar setTranslucent: YES];
    [navgation.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.window.rootViewController = navgation;
    [self.window makeKeyAndVisible];
    
    // @TODO：启动友盟统计，实际发布需要替换成正式的APP KEY和渠道名，“”代表APP STORE
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    // 设置为最小间隔发送
    [MobClick startWithAppkey:@"56b195e9e0f55ae8d1000b9f" reportPolicy:SEND_INTERVAL   channelId:nil];
    
    // 注册极光推送 15669244876
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

    // 显示欢迎页面
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [jkGuideViewController show];
    }
    
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"App Info : %@ %@ %@", [infoDictionary objectForKey:@"DTPlatformName"], [infoDictionary objectForKey:@"CFBundleInfoDictionaryVersion"], [infoDictionary objectForKey:@"CFBundleVersion"]);
    
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

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [jpush registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
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
    // Required - 处理收到的通知
//    [JPUSHService handleRemoteNotification:userInfo];
    
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
