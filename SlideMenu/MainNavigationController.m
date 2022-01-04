//
//  MainNavigationController.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/15/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "MainNavigationController.h"
#import "public.h"

#import "SlideMenuViewController.h"
#import "JPushNotification.h"

@interface MainNavigationController () <PostSessionDataDelegate>

@end

@implementation MainNavigationController {
    GetPostSessionData * postSession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setShadowImage:[[UIImage alloc]init]];
    [self.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent: YES];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    // [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    // 修改navigationBar Title 颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)openDrawer:(id)sender {
    [self.drawer open];
}

- (void) doLogoff:(NSString *) userinfo {
    NSString * url = [NSString stringWithFormat:@"%@/api/logout", HTTP_GET_POST_ADDRESS];
    [postSession SendPostSessionRequest:url Body:userinfo];
    
    [((JPushNotification*)[PushNotification sharePushNotification]) registerUserTags:nil andAlias:@"" callbackSelector:@selector(jPushLogoff:) target:self];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction) jPushLogoff:(id)sender {
    NSLog(@"** user is logoff ..");
}

- (void) didPostSessionRequest:(NSString *)request {
    if ([request isEqualToString:@"NSURLErrorNetworkConnectionLost"]) {
        return;
    }
}

- (void) doSwitchViewController {
    SlideMenuViewController * view = (SlideMenuViewController *)self.drawer.leftViewController;
    [view doSwitchViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
