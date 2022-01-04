//
//  UserLocationInfoViewController.m
//  G-NetLink-v1.0
//
//  Created by jk on 1/5/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "UserLocationInfoViewController.h"
#import "MainNavigationController.h"
#import "UserInfoTableViewCell.h"
#import "CarInfoTableViewCell.h"
#import "VehicleInfoViewController.h"
#import "public.h"

#import "GetPostSessionData.h"
#import "GNLUserInfo.h"
#import "jkAlertController.h"
#import "DJRefresh.h"

@interface UserLocationInfoViewController () <UITableViewDelegate, UITableViewDataSource, PostSessionDataDelegate, DJRefreshDelegate, UIGestureRecognizerDelegate>

@end

@implementation UserLocationInfoViewController {
    IBOutlet UITableView * m_tableview;
    NSArray * m_arrTitle;
    NSArray * m_arrSectionText;
    
    NSMutableArray * m_arrTitleValue;
    NSMutableArray * m_arrVehicles;
    GetPostSessionData * PostSession;
    DJRefresh * m_refrese;
    
    UISwipeGestureRecognizer *recognizer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    
    // 向右滑动显示菜单
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    recognizer.delegate = self;
    self.navigationItem.title = @"用户信息";
    
    m_arrTitle = [[NSArray alloc] initWithObjects:@"用户ID", @"姓名", @"电话", nil];
    m_arrSectionText = [[NSArray alloc]initWithObjects:@"用户信息", @"车辆信息", nil];
    m_arrTitleValue = [[NSMutableArray alloc] init];
    m_arrVehicles = [[NSMutableArray alloc] init];
    
    // 隐藏多余的分割线
    m_tableview.tableFooterView = [[UIView alloc]init];
    
    // PostSession init
    PostSession = [[GetPostSessionData alloc]init];
    PostSession.delegate = self;
    
    m_refrese = [DJRefresh refreshWithScrollView: m_tableview];
    m_refrese.delegate=self;
    m_refrese.topEnabled=YES;
    m_refrese.autoRefreshTop=YES;
    
    
    if ([GNLUserInfo isDemo]) {
        [self.view addSubview: [ServicesPro loadMarkDemoView]];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
    
    NSArray * list = self.navigationController.viewControllers;
    if ([list count] == 1) {
        [[self view] addGestureRecognizer:recognizer];
    }
    else {
        [[self view] removeGestureRecognizer:recognizer];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getPostUserInfo];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getPostUserInfo {
    // user information
    NSString * url = [NSString stringWithFormat:@"%@/api/getUserInfo", HTTP_GET_POST_ADDRESS];
    NSString *param = [NSString stringWithFormat:@"accessToken=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo isDemo] ? @"true" : @"false"];
    [PostSession SendPostSessionRequest:url Body:param];
}

- (void) getPostVehicleInfo {
    NSString * url = [NSString stringWithFormat:@"%@/api/getVehiclesOfUser", HTTP_GET_POST_ADDRESS];
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
    
    
    NSDictionary * dic = [PostSession getDictionaryFromRequest];
    if ([[[dic objectForKey:@"status"] objectForKey:@"code"] isEqualToString: @"402"]) {
        MainNavigationController * ctl = (MainNavigationController *) self.navigationController;
        [ctl turntoLoginForOut];
        return;
    }
    
    if (![[[dic objectForKey:@"status"] objectForKey:@"description"] isEqualToString: @"Success"] || request == nil) {
        jkAlertController * view = [[jkAlertController alloc] initWithOKButton:DATA_ERROR];
        [view show];
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
        return;
    }
    
    if ([[dic allKeys] containsObject:@"customerName"] && [[dic allKeys] containsObject:@"idNumber"]) {
        NSLog(@"%@ %@ %@", [dic objectForKey:@"customerName"], [dic objectForKey:@"idNumber"], [dic objectForKey:@"phoneNumber"]);
        [m_arrTitleValue removeAllObjects];
        [m_arrTitleValue addObject:[dic objectForKey:@"idNumber"]];
        [m_arrTitleValue addObject:[dic objectForKey:@"customerName"]];
        [m_arrTitleValue addObject:[dic objectForKey:@"phoneNumber"]];
        [self getPostVehicleInfo];
    }
    if ([[dic allKeys] containsObject:@"vehicleInfo"]) {
        [m_arrVehicles removeAllObjects];
        [m_arrVehicles addObjectsFromArray:[dic objectForKey:@"vehicleInfo"]];
        NSLog(@"%@ - %ld", m_arrVehicles, [m_arrVehicles count]);
        [m_tableview reloadData];
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
    }
    
}

- (void) loadViewForMenu {
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_menuicon"] style: UIBarButtonItemStylePlain target:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void) loadViewForHome {
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    NSInteger res = 0;
    if (sectionIndex == 0) {
        res = 3;
    }
    else if (sectionIndex == 1) {
        res = [m_arrVehicles count];
    }
    return res;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 2.0f;
    if (section == 1) return 42.0f;
    else return 2.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * sectionHeaderView;
    if (section == 0) {
        sectionHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f)];
        UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_seperateline02"]];
        headerImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f);
        [sectionHeaderView addSubview:headerImage];
    }
    else if (section == 1) {
        sectionHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 42.0f)];
        [sectionHeaderView setBackgroundColor:[UIColor colorWithHexString:@"2C3642"]];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 8.0f, 100.0f, 24.0f)];
        [sectionHeaderView addSubview: label];
        [label setFont: [UIFont fontWithName:FONT_XI size:17.0f]];
        [label setTextColor: [UIColor whiteColor]];
        [label setText: [m_arrSectionText objectAtIndex: section]];
        
        UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_seperateline02"]];
        headerImage.frame = CGRectMake(0.0f, 40.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f);
        [sectionHeaderView addSubview:headerImage];
    }

    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentifier = @"UserInfoTableViewCell";
    NSString * tmpSTR = @"数据加载中 ..";
    UITableViewCell * resCell = nil;
    
//    UserInfoTableViewCell *cell = (UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"UserInfoTableViewCell";
        UserInfoTableViewCell *cell = (UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UserInfoTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        if ([m_arrTitleValue count] == 0) {
            [cell setItemValue:[m_arrTitle objectAtIndex:indexPath.row] Value:tmpSTR];
        }
        else {
            [cell setItemValue:[m_arrTitle objectAtIndex:indexPath.row] Value: [m_arrTitleValue objectAtIndex:indexPath.row]];
        }
        
        resCell = cell;
    }
    else if (indexPath.section == 1 && [m_arrTitleValue count] != 0) {
        static NSString *cellIdentifier = @"CarInfoTableViewCell";
        CarInfoTableViewCell *cell = (CarInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CarInfoTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        NSDictionary * tmpDIC = [m_arrVehicles objectAtIndex:indexPath.row];
        [cell setItemValue:[NSString stringWithFormat:@"车辆%ld",(indexPath.row + 1)] Value:[tmpDIC objectForKey:@"vehicleLisence"]];
        
        if ([[GNLUserInfo defaultCarVin] isEqualToString:[tmpDIC objectForKey:@"vin"]]) {
            [cell setItemIconHidden:NO IntoIcon:NO];
        }
        else {
            [cell setItemIconHidden:YES IntoIcon:NO];
        }
        resCell = cell;
    }
    
    [resCell setSelectionStyle: UITableViewCellSelectionStyleNone];
    return resCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSDictionary * tmpDIC = [m_arrVehicles objectAtIndex:indexPath.row];
        VehicleInfoViewController * view = [[VehicleInfoViewController alloc] init];
        view.ttType = [tmpDIC objectForKey:@"vehicleType"];
        view.ttCode = [tmpDIC objectForKey:@"vehicleLisence"];
        view.ttColor = [tmpDIC objectForKey:@"vehicleColor"];
        view.ttVin = [tmpDIC objectForKey:@"vin"];
        [self.navigationController pushViewController: view animated:YES];
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
