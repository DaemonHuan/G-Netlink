//
//  MainNavigationController.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/7/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "MainNavigationController.h"
#import "SlideMenuView.h"

#import "public.h"
#import "jkAlertController.h"
#import "GNLUserInfo.h"

// import package for views
#import "MainViewController.h"
#import "UserManagerViewController.h"
#import "TravelLogViewController.h"
#import "GetPostSessionData.h"
#import "CarLocationViewController.h"
#import "VehicleManagerViewController.h"
#import "SendDestinationViewController.h"
#import "UserLocationInfoViewController.h"
#import "VehicleManagerViewController.h"
#import "DashBoardViewController.h"
#import "WarningViewController.h"
#import "ViolationInQuiryViewController.h"

@interface MainNavigationController () <SlideMenuActionDelegate, PostSessionDataDelegate>

@end

@implementation MainNavigationController {
    SlideMenuView * menu;
    GetPostSessionData * PostSession;
    
    MainViewController * m_mainview;
    TravelLogViewController * m_travellogview;
    CarLocationViewController * m_carlocationview;
    SendDestinationViewController * m_destinationview;
    VehicleManagerViewController * m_vehiclemanagerview;
    UserManagerViewController * m_usermanagerview;
    UserLocationInfoViewController * m_userinfoview; // 切换默认车辆
    DashBoardViewController * m_dashboardview;
    WarningViewController * m_warningview;
    ViolationInQuiryViewController * m_violationview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setShadowImage:[[UIImage alloc]init]];
    [self.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent: YES];
    
    menu = [[SlideMenuView alloc] initWithContainView];
    menu.delegate = self;
    
    // PostSession init
    PostSession = [[GetPostSessionData alloc]init];
    PostSession.delegate = self;
    
    [self sendPostSession];
}

- (void) setMainViewController:(UIViewController *)view {
    m_mainview = (MainViewController *)view;
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"main navigation controller ..");
}

- (void) setTtilelisence {
    [menu setMessageForTitle:[GNLUserInfo userName] carlisence: [GNLUserInfo defaultCarLisence]];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setNavigationBarStyle:(NSInteger) code {
    if (code == 0) {
        [self.navigationBar setShadowImage:[[UIImage alloc]init]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"public_alpha"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setTranslucent: YES];
    }
    else {
//        [self.navigationBar setTranslucent: NO];
        [self.navigationBar setShadowImage:[[UIImage alloc]init]];
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"public_bar"] forBarMetrics:UIBarMetricsCompact];
    }
}

// Post Sessions
- (void) sendPostSession {
    NSString * url = [NSString stringWithFormat:@"%@/api/getUserInfo", HTTP_GET_POST_ADDRESS];
    NSString *param = [NSString stringWithFormat:@"accessToken=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo isDemo] ? @"true" : @"false"];
    [PostSession SendPostSessionRequest:url Body:param];
}

- (void) didPostSessionRequest:(NSString *)request {
    NSLog(@"Request - %@", request);
    if (request == nil) return;
    if ([request isEqualToString:@"jk-error .."]) {
        jkAlertController * alerttopost = [[jkAlertController alloc] initWithOKButton:NETWORK_ERROR ];
        [alerttopost show];
        return;
    }
    if ([request isEqualToString:@"jk-timeout .."]) {
        jkAlertController * alerttopost = [[jkAlertController alloc] initWithOKButton:NETWORK_TIMEOUT ];
        [alerttopost show];
        return;
    }

//    NSArray * arrayVehicle = [[PostSession getDictionaryFromRequest] objectForKey:@"vehicleInfo"];
    NSDictionary * dic = [PostSession getDictionaryFromRequest];
    if ([[[dic objectForKey:@"status"] objectForKey:@"code"] isEqualToString: @"402"]) {
        MainNavigationController * ctl = (MainNavigationController *) self.navigationController;
        [ctl turntoLoginForOut];
        return;
    }
    
    if ([[dic allKeys] containsObject:@"customerName"] && [[dic allKeys] containsObject:@"idNumber"]) {
        NSLog(@"%@ %@ %@", [dic objectForKey:@"customerName"], [dic objectForKey:@"idNumber"], [dic objectForKey:@"phoneNumber"]);
        [GNLUserInfo setUserName:[dic objectForKey:@"customerName"]];
//        [m_arrTitleValue removeAllObjects];
//        [m_arrTitleValue addObject:[dic objectForKey:@"idNumber"]];
//        [m_arrTitleValue addObject:[dic objectForKey:@"customerName"]];
//        [m_arrTitleValue addObject:[dic objectForKey:@"phoneNumber"]];
        
        [menu setMessageForTitle:[dic objectForKey:@"customerName"] carlisence: [GNLUserInfo defaultCarLisence]];
    }
}

- (void) leftItemClicked {
    NSLog(@"Left Menu ..");
    [menu show];
}

// delegate function from slidemenu
- (void) doSlideMenuActions:(NSString *)code {
    NSLog(@"do slidemenu Actions -- %@", code);
    if ([code isEqualToString:@"exit&logoff"]) {
        [GNLUserInfo selflogout];
        [GNLUserInfo setGoOut:NO];
        
        NSString * url = [NSString stringWithFormat:@"%@/api/logout", HTTP_GET_POST_ADDRESS];
        NSString *param = [NSString stringWithFormat:@"accessToken=%@&username=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo userID], [GNLUserInfo isDemo] ? @"true" : @"false"];
        [PostSession SendPostSessionRequest:url Body:param];
        
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    else if ([code isEqualToString:@"00"]) {
        if (m_usermanagerview == nil) m_usermanagerview = [[UserManagerViewController alloc] init];
        self.viewControllers = @[m_usermanagerview];
    }
    else if ([code isEqualToString:@"01"]) {
        if (m_mainview == nil) m_mainview = [[MainViewController alloc] init];
        self.viewControllers = @[m_mainview];
    }
    else if ([code isEqualToString:@"02"]) {
        if (m_vehiclemanagerview == nil) m_vehiclemanagerview = [[VehicleManagerViewController alloc] init];
        //        [self popToRootViewControllerAnimated:YES];
        self.viewControllers = @[m_vehiclemanagerview];
    }
    else if ([code isEqualToString:@"03"]) {
        if (m_carlocationview == nil) m_carlocationview = [[CarLocationViewController alloc] init];
        self.viewControllers = @[m_carlocationview];
    }
    else if ([code isEqualToString:@"04"]) {
        if (m_destinationview == nil) m_destinationview = [[SendDestinationViewController alloc] init];
        self.viewControllers = @[m_destinationview];
    }
    else if ([code isEqualToString:@"05"]) {
        if (m_travellogview == nil) m_travellogview = [[TravelLogViewController alloc] init];
        self.viewControllers = @[m_travellogview];
    }
    else if ([code isEqualToString:@"06"]) {
        if (m_dashboardview == nil) m_dashboardview = [[DashBoardViewController alloc] init];
        self.viewControllers = @[m_dashboardview];
    }
    else if ([code isEqualToString:@"07"]) {
        if (m_warningview == nil) m_warningview = [[WarningViewController alloc] init];
//        [self setNavigationBarStyle: 1];
        self.viewControllers = @[m_warningview];
    }
    else if ([code isEqualToString:@"08"]) {
        jkAlertController * alert = [[jkAlertController alloc]initWithTitle:@"" CenterLabel:@"确认拨打救援电话\n4000176801" Enter:@"确认" Cancle:@"取消"];
        alert.okBlock = ^() {
            [ServicesPro doCallForHelp];
        };
        [alert show];
    }
    else if ([code isEqualToString:@"09"]) {
        if (m_violationview == nil) m_violationview = [[ViolationInQuiryViewController alloc] init];
        self.viewControllers = @[m_violationview];
    }
    else if ([code isEqualToString:@"10"]) {
        if (m_userinfoview == nil) {
            m_userinfoview = [[UserLocationInfoViewController alloc] init];
            [m_userinfoview loadViewForMenu];
        }
        self.viewControllers = @[m_userinfoview];
    }
}

- (void) doSwitchView:(NSString *)code {
    if ([code isEqualToString:@"02"]) {
        if (m_vehiclemanagerview == nil) m_vehiclemanagerview = [[VehicleManagerViewController alloc] init];
        self.viewControllers = @[m_vehiclemanagerview];
    }
    else if ([code isEqualToString:@"06"]) {
        if (m_dashboardview == nil) m_dashboardview = [[DashBoardViewController alloc] init];
        self.viewControllers = @[m_dashboardview];
    }
    else if ([code isEqualToString:@"07"]) {
        if (m_warningview == nil) m_warningview = [[WarningViewController alloc] init];
        self.viewControllers = @[m_warningview];
    }
}

- (void) turntoLoginForOut {
    [GNLUserInfo selflogout];
    [GNLUserInfo setTokenPass:YES];
    
   
    [self dismissViewControllerAnimated:YES completion:^{}];
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
