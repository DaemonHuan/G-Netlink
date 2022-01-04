//
//  UserManagerViewController.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/14/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "UserManagerViewController.h"
#import "MainNavigationController.h"
#import "UserTableViewCell.h"
#import "UserLocationInfoViewController.h"
#import "AboutViewController.h"
#import "PasswordReset2ViewController.h"
#import "HelpViewController.h"

#import "public.h"
#import "GNLUserInfo.h"
#import "jkAlertController.h"

@interface UserManagerViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@end

@implementation UserManagerViewController {
    IBOutlet UILabel * la_username;
    IBOutlet UILabel * la_carlisense;
    IBOutlet UITableView * m_tableview;
    
    NSArray * m_tableviewlist;
    NSArray * m_tableviewicon;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    
    self.navigationItem.title = @"用户管理";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_menuicon"] style: UIBarButtonItemStylePlain target:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 向右滑动显示菜单
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    recognizer.delegate = self;
    [[self view] addGestureRecognizer:recognizer];
    
    // init title
    [la_username setText: [GNLUserInfo userName]];
    [la_carlisense setText: [GNLUserInfo defaultCarLisence]];
    
    m_tableviewlist = [[NSArray alloc] initWithObjects:@"用户信息", @"修改密码", @"使用帮助", @"关于", nil];
    m_tableviewicon = [[NSArray alloc] initWithObjects:@"uctl_user", @"uctl_pass", @"uctl_update", @"uctl_help", @"uctl_about", nil];
    
    // 隐藏多余的分割线
    m_tableview.tableFooterView = [[UIView alloc]init];
    
    //
    if ([GNLUserInfo isDemo]) {
        [self.view addSubview: [ServicesPro loadMarkDemoView]];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    // init title
    [la_username setText: [GNLUserInfo userName]];
    [la_carlisense setText: [GNLUserInfo defaultCarLisence]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// init tableview function
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [m_tableviewlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UserTableViewCell";
    //    static BOOL nibsRegistered = NO;
    UserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"UserTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setCellValue:[m_tableviewicon objectAtIndex:indexPath.row] TitleName:[m_tableviewlist objectAtIndex:indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [m_tableview deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"user Manager %ld %ld", indexPath.section, indexPath.row);
    if (indexPath.section == 0 && indexPath.row == 0) {
        UserLocationInfoViewController * view = [[UserLocationInfoViewController alloc]init];
        [view loadViewForHome];
        [self.navigationController pushViewController:view animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        PasswordReset2ViewController * view = [[PasswordReset2ViewController alloc] init];
        [self.navigationController pushViewController: view animated:YES];
    }
    /*
    else if (indexPath.section == 0 && indexPath.row == 2) {
//        jkAlertController * alert = [[jkAlertController alloc] initWithTitle:@"" CenterLabel: @"已检测到新版本\n是否马上升级？" Enter: @"确 定" Cancle: @"取 消"];
//        [alert show];
//        alert.okBlock = ^() {
//            //
//        };
        jkAlertController * alert = [[jkAlertController alloc] initWithOKButton:@"当前已是最新版本,\n感谢使用!"];
        [alert show];
        
    }
     */
    else if (indexPath.section == 0 && indexPath.row == 2) {
        HelpViewController * view = [[HelpViewController alloc]init];
        [self.navigationController pushViewController:view animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
        AboutViewController * view = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:view animated:YES];
    }
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
