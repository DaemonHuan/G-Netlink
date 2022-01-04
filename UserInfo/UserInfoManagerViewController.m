//
//  UserInfoManagerViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/28/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "UserInfoManagerViewController.h"
#import "UserInfoTableViewCellWithMsg.h"
#import "UserInfoTableViewCellDetail.h"
#import "UserInfoLogoffTableViewCell.h"
#import "MaplineTableViewCell.h"
#import "public.h"

#import "AboutViewController.h"
#import "HelpViewController.h"
#import "FixPasswordViewController.h"
#import "FindPasswordViewController.h"
#import "ChangeDefaultVehicleViewController.h"
#import "MessageRequestViewController.h"
#import "SimInfoViewController.h"
#import "MyStoreViewController.h"

@interface UserInfoManagerViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation UserInfoManagerViewController  {
    IBOutlet UIImageView * iv_icon;
    IBOutlet UILabel * la_username;
    IBOutlet UILabel * la_lisence;
    IBOutlet UITableView * m_tableview;
    
    NSArray * m_titles;
    NSArray * m_icons;
    NSArray * m_value;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_bg_dark"]];
    self.navigationItem.title = @"用户管理";

//    m_titles = [[NSArray alloc]initWithObjects:@"用户ID", @"电话", @"修改密码", @"切换车辆", @"使用帮助", @"意见反馈", @"关于", nil];
//    m_icons = [[NSArray alloc]initWithObjects:@"uctl_user", @"uctl_tel", @"uctl_pass", @"uctl_car", @"uctl_help", @"uctl_msg", @"uctl_about", nil];

    if ([self.UserInfo isKCUser]) {
        // KC user Manager , @"经销商信息" , @"uctl_sell"
        m_titles = [[NSArray alloc]initWithObjects:@"用户ID", @"电话", @"修改密码", @"切换车辆", @"经销店信息", @"套餐余量查询", @"续费服务", @"使用帮助", @"意见反馈", @"关于", nil];
        m_icons = [[NSArray alloc]initWithObjects:@"uctl_user", @"uctl_tel", @"uctl_pass", @"uctl_car", @"uctl_sell", @"uctl_sim", @"uctl_cons", @"uctl_help", @"uctl_msg", @"uctl_about", nil];
        
        m_value = [[NSArray alloc]initWithObjects:[self.UserInfo gKCUuid], [self.UserInfo gKCuTel], nil];
    }
    else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博越"]) {
        m_titles = [[NSArray alloc]initWithObjects:@"用户ID", @"电话", @"修改密码", @"切换车辆", @"使用帮助", @"意见反馈", @"关于", nil];
        m_icons = [[NSArray alloc]initWithObjects:@"uctl_user", @"uctl_tel", @"uctl_pass", @"uctl_car", @"uctl_help", @"uctl_msg", @"uctl_about", nil];
        /*
         m_titles = [[NSArray alloc]initWithObjects:@"用户ID", @"电话", @"修改密码", @"切换车辆", @"轨迹开关", @"使用帮助", @"意见反馈", @"关于", nil];
         m_icons = [[NSArray alloc]initWithObjects:@"uctl_user", @"uctl_tel", @"uctl_pass", @"uctl_car", @"uctl_line", @"uctl_help", @"uctl_msg", @"uctl_about", nil];
         */
        
        m_value = [[NSArray alloc]initWithObjects:[self.UserInfo gUserID], [self.UserInfo gTelePhoneNum], nil];
    }
    else {
        m_titles = [[NSArray alloc]initWithObjects:@"用户ID", @"电话", @"修改密码", @"切换车辆", @"使用帮助", @"意见反馈", @"关于", nil];
        m_icons = [[NSArray alloc]initWithObjects:@"uctl_user", @"uctl_tel", @"uctl_pass", @"uctl_car", @"uctl_help", @"uctl_msg", @"uctl_about", nil];
        
        m_value = [[NSArray alloc]initWithObjects:[self.UserInfo gUserID], [self.UserInfo gTelePhoneNum], nil];
    }
    
    // 隐藏多余的分割线
    m_tableview.tableFooterView = [[UIView alloc]init];
    m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //
    [la_username setTextColor: [UIColor colorWithHexString:WORD_COLOR_GLODEN]];
    [la_username setFont:[UIFont fontWithName:FONT_XI size:FONT_S_TITLE1]];
    [la_lisence setTextColor:[UIColor whiteColor]];
    [la_lisence setFont:[UIFont fontWithName:FONT_XI size:FONT_S_TITLE1]];
    
    // 模拟数据 FLAG
    if ([self.UserInfo isRunDemo]) {
        [self.view addSubview: [ExtendStaticView MarkDemoView]];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [la_username setText:[self.UserInfo gUserName]];
    [la_lisence setText:[self.UserInfo gDefaultVehicleLisence]];
    
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// tableview delegate Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    if (sectionIndex == 0) {
        if ([self.UserInfo isKCUser]) return 7;
//        else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博越"]) return 5;
        else return 4;
    }
    if (sectionIndex == 1) return 3;
    if (sectionIndex == 2) return 1;
    else return 0;
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) return 40.0f;
    else return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * sectionHeaderView = [[UIView alloc]init];;
    if (section == 3) {
        sectionHeaderView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 40.0f);;
    }
    else {
        sectionHeaderView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 20.0f);
    }

    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"indexPath.row %ld", indexPath.row);
    NSInteger count = 0;
    if ([self.UserInfo isKCUser]) count = 7;
//    else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博越"]) count = 5;
    else count = 4;
    
    UITableViewCell * res = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            static NSString *cellIdentifier = @"UserInfoTableViewCellWithMsg";
            UserInfoTableViewCellWithMsg * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            }
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            [cell setCellWithTitle:[m_titles objectAtIndex:indexPath.row] Icon:[m_icons objectAtIndex:indexPath.row] Value:[m_value objectAtIndex:indexPath.row]];
            res = cell;
        }
/*        else if (indexPath.row == 4 && [[self.UserInfo gDefaultVehicleType]isEqualToString:@"博越"]) {                  // 行车轨迹开关选项
            static NSString * cellIdentifier = @"MaplineTableViewCell";
            MaplineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            }
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            [cell setCellWithTitle:[m_titles objectAtIndex:indexPath.row] Icon:[m_icons objectAtIndex:indexPath.row]];
            [cell setSwitchFlag: [self.UserInfo isMapFlag]];
            res = cell;
        } */
        else {
            static NSString * cellIdentifier = @"UserInfoTableViewCellDetail";
            UserInfoTableViewCellDetail * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            }
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            [cell setCellWithIcon:[m_icons objectAtIndex:indexPath.row] Title:[m_titles objectAtIndex:indexPath.row]];
            res = cell;
        }
    }
    else if (indexPath.section == 1) {
        static NSString * cellIdentifier = @"UserInfoTableViewCellDetail";
        UserInfoTableViewCellDetail * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        }
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [cell setCellWithIcon:[m_icons objectAtIndex:indexPath.row + count] Title:[m_titles objectAtIndex:indexPath.row + count]];
        res = cell;
    }
    else if (indexPath.section == 2) {
        static NSString * cellIdentifier = @"UserInfoLogoffTableViewCell";
        UserInfoLogoffTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        }
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        res = cell;
    }
    res.selectionStyle = UITableViewCellSelectionStyleNone;
    return res;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 去除选中行的被选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController * view = nil;
    if (indexPath.section == 0 && indexPath.row == 2) {
        if ([self.UserInfo isKCUser]) {
            FindPasswordViewController * tmp = [[FindPasswordViewController alloc]init];
            tmp.userKCFlag = 0;
            tmp.userBrandId = @"KC";
            tmp.userType = 1;
            tmp.telPhone = [self.UserInfo gTelePhoneNum];
            view = (UIViewController *)tmp;
        }
        else {
            view = (UIViewController *)[[FixPasswordViewController alloc]init];
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
        view = (UIViewController *)[[ChangeDefaultVehicleViewController alloc]init];
    }
    else if (indexPath.section == 0 && indexPath.row == 4) {
        /* if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博越"]) {
            NSLog(@"map line is on ..");
            if ([self.UserInfo isMapFlag]) {
                [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyMaplineFlag Value:@"OFF"];
            }
            else {
                [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyMaplineFlag Value:@"ON"];
            }
            [m_tableview reloadData];
            return;
        }
        else {
            view = (UIViewController *)[[MyStoreViewController alloc]init];
        } */
        view = (UIViewController *)[[MyStoreViewController alloc]init];
    }
    else if (indexPath.section == 0 && indexPath.row == 5) {
        view = (UIViewController *)[[SimInfoViewController alloc]init];
    }
    else if (indexPath.section == 0 && indexPath.row == 6) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://wo.zj186.com/netCar/index.do?num_sign=%@", [self.UserInfo gTelePhoneNum]]]];
        return;
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        view = (UIViewController *)[[HelpViewController alloc]init];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        view = (UIViewController *)[[MessageRequestViewController alloc]init];
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        view = (UIViewController *)[[AboutViewController alloc]init];
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        MainNavigationController * navigation = (MainNavigationController *)self.navigationController;
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyRunStatus Value:@"EXITLINE"];
        [navigation doLogoff:self.userfixstr];
    }
    else return;
    
    [self.navigationController pushViewController:view animated:YES];
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
