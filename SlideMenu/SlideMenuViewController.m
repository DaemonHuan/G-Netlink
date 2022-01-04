//
//  SlideMenuViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/15/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "SlideMenuTableViewCell.h"
#import "IndexViewController.h"

#import "VehicleLocationViewController.h"
#import "UserInfoManagerViewController.h"
#import "DestinationViewController.h"
#import "DashBoardViewController.h"
#import "WarningViewController.h"
#import "NotationsViewController.h"
#import "TravelLogViewController.h"
#import "VehicleManagerViewController.h"

#import "public.h"

@interface SlideMenuViewController () <UITableViewDataSource, UITableViewDelegate, PostSessionDataDelegate>

@end

@implementation SlideMenuViewController {
    IBOutlet UIView * vi_title;
    IBOutlet UILabel * la_username;
    IBOutlet UILabel * la_carcode;
    IBOutlet UITableView * menutableview;
    
    NSArray * m_menulist;
    NSArray * m_menuicon;
    
    NSInteger m_currentviewcode;
    NSInteger m_lastIndexRow;
    
    GetPostSessionData * postSession;
    IndexViewController * m_indexview;
}

- (id) init {
    if (self = [super init]) {
        m_lastIndexRow = 0;
        postSession = [[GetPostSessionData alloc]init];
        postSession.delegate = self;
        
        if ([self.UserInfo isKCUser]) {
            m_menulist = [[NSArray alloc] initWithObjects:@"首页", @"车辆控制", @"车辆位置", @"仪表盘", @"告警", @"一键导航", @"一键救援", @"消息推送", nil];
            m_menuicon = [[NSArray alloc]initWithObjects:@"menu_home", @"menu_carcontrol", @"menu_location", @"menu_panel", @"menu_alert", @"menu_goto", @"menu_help", @"menu_msg", nil];
        }
        else {
            m_menulist = [[NSArray alloc] initWithObjects:@"首页", @"车辆控制", @"车辆位置",@"发送目的地", @"行车日志", @"仪表盘", @"告警", @"一键服务", @"消息通知", nil];
            m_menuicon = [[NSArray alloc]initWithObjects:@"menu_home", @"menu_carcontrol", @"menu_location", @"menu_destination", @"menu_travellog", @"menu_panel", @"menu_alert", @"menu_onekey", @"menu_msg", nil];

            [self sendPostSessionForUserInfo];
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    la_username.text = @"Default User";
    la_username.textColor = [UIColor colorWithHexString: WORD_COLOR_GLODEN];
    [la_username setFont: [UIFont fontWithName: FONT_MM size: FONT_S_TITLE1]];
    
    la_carcode.text = @"...";
    la_carcode.textColor = [UIColor whiteColor];
    [la_carcode setFont: [UIFont fontWithName:FONT_XI size: FONT_S_TITLE1]];
    
    // 单击手势
    UITapGestureRecognizer * singleTouchUp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doShowUserManager:)];
    [vi_title addGestureRecognizer:singleTouchUp];
    
//    bt_logoff.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//    [bt_logoff setTintColor: [UIColor colorWithHexString: WORD_COLOR_GLODEN]];
//    [bt_logoff setTitleColor:[UIColor colorWithHexString: WORD_COLOR_GLODEN] forState:UIControlStateNormal];
//    [bt_logoff.titleLabel setFont: [UIFont fontWithName:FONT_MM size: FONT_S_TITLE1]];

    //
    menutableview.opaque = NO;
    menutableview.sectionHeaderHeight = 0.0f;
    menutableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    menutableview.rowHeight = 60.0f;
    m_currentviewcode = 0;
    
    UIImageView * imageSS = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"public_seperateline01"]];
    [imageSS setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.8f - 2.0f, 0.0f, 2.0f, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:imageSS];
}

- (void) viewDidAppear:(BOOL)animated {
    [la_username setText:[self.UserInfo gUserName]];
    [la_carcode setText:[self.UserInfo gDefaultVehicleLisence]];
}

- (void) sendPostSessionForUserInfo {
    NSString * url = [NSString stringWithFormat:@"%@/api/getUserInfo", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"%@", self.userfixstr];
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    if ([request isEqualToString:@"NSURLErrorNetworkConnectionLost"]) {
        return;
    }
    
    if ([request isEqualToString:@"jk-Error"]) {
        return;
    }
    
    NSDictionary * mdic = [postSession getDictionaryFromRequest];
    if ([[mdic allKeys] containsObject:@"customerName"] && [[mdic allKeys] containsObject:@"phoneNumber"]) {
        if ([[[mdic objectForKey:@"status"]objectForKey:@"code"] isEqualToString:@"200"]) {
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyUserName Value:[mdic objectForKey:@"customerName"]];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyUserID Value:[mdic objectForKey:@"idNumber"]];
            la_carcode.text = [mdic objectForKey:@"customerName"];
        }
    }
}

- (void) doSwitchViewController {
    m_lastIndexRow = -2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Actions
- (IBAction) doShowUserManager:(id)sender {
    [self.drawer close];
    m_lastIndexRow = -1;
    
    UserInfoManagerViewController * view = [[UserInfoManagerViewController alloc]init];
    
    typeof(self) __weak weakSelf = self;
    [self.drawer reloadCenterViewControllerUsingBlock:^(){
        weakSelf.drawer.centerViewController.viewControllers = @[view];
    }];
}

#pragma mark -
#pragma mark UITableView Datasource
// tableview delegate functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [m_menulist count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (m_lastIndexRow == indexPath.row) {
        [self.drawer close];
        return;
    }
    
    UIViewController * view = nil;
    if ([self.UserInfo isKCUser]){
        if (indexPath.row == 0) {
            view = (UIViewController *)[[IndexViewController alloc]init];
        }
        else if (indexPath.row == 1) {
            view = (UIViewController *)[[VehicleManagerViewController alloc]init];
        }
        else if (indexPath.row == 2) {
            view = (UIViewController *)[[VehicleLocationViewController alloc]init];
        }
        else if (indexPath.row == 3) {
            view = (UIViewController *)[[DashBoardViewController alloc]init];
        }
        else if (indexPath.row == 4) {
            view = (UIViewController *)[[WarningViewController alloc]init];
        }
        else if (indexPath.row == 5) {
            AlertBoxView * alert = [[AlertBoxView alloc]initWithTitle:@"确认拨打导航电话\n0571-28815911" Enter:@"确认" Cancle:@"取消"];
            alert.okBlock = ^() {
                [ExtendStaticFunctions doCallForHelp:@"0571-28815911"];
            };
            [alert show];
            [self.drawer close];
            return;
        }
        else if (indexPath.row == 6) {
            AlertBoxView * alert = [[AlertBoxView alloc]initWithTitle:@"确认拨打救援电话\n0571-28815913" Enter:@"确认" Cancle:@"取消"];
            alert.okBlock = ^() {
                [ExtendStaticFunctions doCallForHelp: @"0571-28815913"];
            };
            [alert show];
            [self.drawer close];
            return;
        }
        else if (indexPath.row == 7) {
            view = (UIViewController *)[[NotationsViewController alloc]init];
        }
        else {
            [self.drawer close];
            return;
        }
    } 
    else {
        if (indexPath.row == 0) {
            view = (UIViewController *)[[IndexViewController alloc]init];
        }
        else if (indexPath.row == 1) {
            view = (UIViewController *)[[VehicleManagerViewController alloc]init];
        }
        else if (indexPath.row == 2) {
            view = (UIViewController *)[[VehicleLocationViewController alloc]init];
        }
        else if (indexPath.row == 3) {
            view = (UIViewController *)[[DestinationViewController alloc]init];
        }
        else if (indexPath.row == 4) {
            view = (UIViewController *)[[TravelLogViewController alloc]init];
        }
        else if (indexPath.row == 5) {
            view = (UIViewController *)[[DashBoardViewController alloc]init];
        }
        else if (indexPath.row == 6) {
            view = (UIViewController *)[[WarningViewController alloc]init];
        }
        else if (indexPath.row == 7) {
            AlertBoxView * alert = [[AlertBoxView alloc]initWithTitle:@"确认拨打服务电话\n4000176801" Enter:@"确认" Cancle:@"取消"];
            alert.okBlock = ^() {
                [ExtendStaticFunctions doCallForHelp:@"4000176801"];
            };
            [alert show];
            [self.drawer close];
            return;
        }
        else if (indexPath.row == 8) {
            view = (UIViewController *)[[NotationsViewController alloc]init];
        }
        else {
            [self.drawer close];
            return;
        }
    }

    typeof(self) __weak weakSelf = self;
    [self.drawer reloadCenterViewControllerUsingBlock:^(){
        weakSelf.drawer.centerViewController.viewControllers = @[view];
    }];
    m_lastIndexRow = indexPath.row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"TableviewCellIdentifier";
    
    SlideMenuTableViewCell *cell = (SlideMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"SlideMenuTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    }
    cell = (SlideMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [cell setitem:[m_menuicon objectAtIndex:indexPath.row] LabelText:[m_menulist objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
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
