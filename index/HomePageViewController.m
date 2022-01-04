//
//  HomePageViewController.m
//  G-Netlink-beta0.2
//
//  Created by jk on 10/29/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomeNavigationController.h"
#import "HomePageTableViewCell.h"

#import "TravelLogViewController.h"

#import "JKAlertDialog.h"
#import "SeekServiceView.h"

#import "UserManager.h"
#import "ProgressUIHelper.h"
#import "public.h"
#import "UIColor+Hex.h"

//#import "MBProgressHUD.h"
#import "MarkIsDemoVIew.h"

#import "MJRefresh.h"

#import "GetPostSessionData.h"
//#import "SSARefreshControl.h"
#import "jkAlertController.h"

@interface HomePageViewController () <UITableViewDataSource, UITableViewDelegate, PostSessionDataDelegate, UINavigationControllerDelegate> {
    NSArray * arrayItem;
    NSArray * arrayIcon;
    NSMutableDictionary * dicValue;
//    BOOL isLoading;
    
    CGFloat tableviewHeight;
    GetPostSessionData * postSession;
    IBOutlet UILabel * mlb_carnum;
//    SSARefreshControl * m_refreshController;
}

@end

@implementation HomePageViewController
{
    BOOL userLoaded;
    BOOL vehicleLoaded;
    BOOL userSuccess;
    BOOL vehicleSuccess;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat hh = CGRectGetHeight(self.titileImageView.bounds);
    tableviewHeight = [UIScreen mainScreen].bounds.size.height - hh;
    // set background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];

    self.homeTableView.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
    
    UIBarButtonItem * menuItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:(HomeNavigationController *)self.navigationController action:@selector(showMenu)];
    [menuItem setImage:[UIImage imageNamed:@"home_menuicon"]];
    [menuItem setTintColor: [UIColor darkGrayColor]];
    self.navigationItem.leftBarButtonItem = menuItem;
    
    arrayItem = [[NSArray alloc]initWithObjects:@"车门车窗和车锁", @"可续航里程", @"告警", @"一键服务", nil];
    arrayIcon = [[NSArray alloc]initWithObjects:@"home_lock", @"home_howfar", @"home_alert", @"home_onekey", nil];
    dicValue = [[NSMutableDictionary alloc]init];
    
    postSession = [[GetPostSessionData alloc] init];
    postSession.delegate = self;
   
    if ([UserManager isDemo]) {
        MarkIsDemoVIew * view = [[MarkIsDemoVIew alloc]init];
        [view loadSelfViewWithPresentView:self.view];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"public_alpha"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar.layer setBorderWidth:0.0f];
    [self.navigationController.navigationBar.layer setBorderColor: [UIColor clearColor].CGColor];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    __unsafe_unretained UITableView *tableView = self.homeTableView;
    MJRefreshGifHeader* header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreseData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    NSMutableArray *idleImages = [[NSMutableArray alloc] init];
    for (int i = 1; i<=4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%02d", i]];
        [idleImages addObject:image];
    }
    [header setImages:@[idleImages[0]] forState:MJRefreshStateIdle];
    [header setImages:@[idleImages[0]] forState:MJRefreshStatePulling];
    [header setImages:idleImages duration:0.5 forState:MJRefreshStateRefreshing];
    tableView.mj_header = header;
    [self.homeTableView.mj_header beginRefreshing];
    
    UILongPressGestureRecognizer * recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cancelOperations)];
    [recognizer setMinimumPressDuration: 0.5f];
    [self.view addGestureRecognizer: recognizer];
    
}

- (void) cancelOperations {
    NSLog(@"cancle this operation ..");
}

- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:80/255.0 green:196/255.0 blue:211/255.0 alpha:0.0f];
        self.navigationController.navigationBar.alpha = 0.1f;
    }
    else {
        self.navigationController.navigationBar.alpha = 1.0f;
    }
}

- (void) viewDidAppear:(BOOL)animated {
    userLoaded = NO;
    vehicleLoaded = NO;
    userSuccess = NO;
    vehicleSuccess = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [arrayItem count];
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeiht = tableviewHeight/4.0f;
    if ([UserManager isDemo]) {
        cellHeiht = (tableviewHeight - 30.0f) / 4.0f;
    }
    return cellHeiht;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"indexPath.row %ld", indexPath.row);
    static NSString *cellIdentifier = @"HomePageTableCell";
    
//    static BOOL nibsRegistered = NO;
    HomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"HomePageTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    }
    
    NSString * tmp = @"数据加载中 ..";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (indexPath.row != ([arrayItem count]-1)) {
        [cell setLabelIcon:[arrayIcon objectAtIndex:indexPath.row]];
        
        if (indexPath.row == 0) {
            if ([dicValue objectForKey:@"doorlock"] != nil) {
                [cell setLabelText:[arrayItem objectAtIndex:indexPath.row] value:[dicValue objectForKey:@"doorlock"]];
            }
            else {
                [cell setLabelText:[arrayItem objectAtIndex:indexPath.row] value: tmp];
            }
//            NSLog(@"cell %@", [dicValue objectForKey:@"doorlock"]);
        }
        
        if (indexPath.row == 1) {
            if ([dicValue objectForKey:@"range"] != nil) {
                [cell setLabelText:[arrayItem objectAtIndex:indexPath.row] value: [dicValue objectForKey:@"range"]];
//                NSLog(@"cell %@", [dicValue objectForKey:@"range"]);
            }
            else {
                [cell setLabelText:[arrayItem objectAtIndex:indexPath.row] value: tmp];
            }
            
        }
        
        if (indexPath.row == 2) {
            if ([dicValue objectForKey:@"alertName"] != nil) {
                [cell setLabelText:[arrayItem objectAtIndex:indexPath.row] value:@"警告异常"];
            }
            else {
                [cell setLabelText:[arrayItem objectAtIndex:indexPath.row] value: tmp];
            }
//            NSLog(@"cell %@", [dicValue objectForKey:@"alertName"]);
        }
    }
    else if (indexPath.row == ([arrayItem count]-1)) {
        [cell setLabelIcon:[arrayIcon objectAtIndex:indexPath.row]];
        [cell setLabelText:@"一键服务" value:@""];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIStoryboard *s = [UIStoryboard storyboardWithName:@"VehicleManagement" bundle:nil];
        UIViewController* vc = [s instantiateViewControllerWithIdentifier:@"main"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        UIStoryboard *s = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        UIViewController* vc = [s instantiateViewControllerWithIdentifier:@"main"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        UIStoryboard *s = [UIStoryboard storyboardWithName:@"WarningPage" bundle:nil];
        UIViewController* vc = [s instantiateViewControllerWithIdentifier:@"main"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
        // 一键服务
        jkAlertController * alert = [[jkAlertController alloc]initWithTitle:@"" CenterLabel:@"确认拨打救援电话\n022-55555555" Enter:@"确认" Cancle:@"取消"];
        alert.okBlock = ^() {
            [SeekServiceView doService: @"022-55555555"];
        };
        [alert show];
    }
}

//- (void) doOperationForRefreshing {
//    [self refreseData];
//}

- (void) refreseData {
    [dicValue removeAllObjects];
    [self sendPostSession];
//    [self.homeTableView reloadData];

//    isLoading = NO;
}

- (void) sendPostSession {
    // 可续航公里  && 告警信息
    NSString * url = [NSString stringWithFormat:@"%@/api/searchVhlStatus", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&vin=%@&isdemo=%@", [UserManager accessToken], [UserManager vin], [UserManager isDemo] ? @"true" : @"false"];
//    NSLog(@"%@ %@", url, body );
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) sendPostSessionForRequest {
    // 车辆状况
    NSString * url = [NSString stringWithFormat:@"%@/api/sendVhlCtlStatusRequest", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"vin=%@&isdemo=%@", [UserManager vin], [UserManager isDemo] ? @"true" : @"false"];
    //    NSLog(@"%@ %@", url, body );
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) sendPostSessionForStatus {
    NSString * url = [NSString stringWithFormat:@"%@/api/getVhlCtlStatus", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&vin=%@&isdemo=%@", [UserManager accessToken], [UserManager vin], [UserManager isDemo] ? @"true" : @"false"];
    NSLog(@"%@ %@", url, body );
    [postSession SendPostSessionThreadRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    NSLog(@"HomePage -- %@", request);
    NSDictionary * dicdata = [postSession getDictionaryFromRequest];
    NSArray * arrayKeys = [dicdata allKeys];

    if ([arrayKeys containsObject:@"status"] && [arrayKeys count] == 1) {
        [dicValue setObject: [[dicdata objectForKey:@"status"] objectForKey:@"description"] forKey:@"requestStatus"];
        
    }
    else if ([arrayKeys containsObject:@"alertList"]) {
        NSArray * tmpArray = [dicdata objectForKey:@"alertList"];
        [dicValue setObject:[[tmpArray objectAtIndex:0] objectForKey:@"alertName"] forKey:@"alertName"];
        [dicValue setObject: [dicdata objectForKey:@"range"] forKey:@"range"];
        [self sendPostSessionForRequest];
    }
    else if ([arrayKeys containsObject:@"doorLockState"]) {
        [dicValue setObject: @"jk" forKey:@"flag"];
        // 忽略项等级 －－ 车锁－>车窗－>车门
        NSString * msg = nil;
        if ([[dicdata objectForKey:@"doorLockState"] isEqual: @"1"]) {
            msg = @"车未锁";
        }
        
        for (NSString * id in arrayKeys) {
            if ([id containsString:@"WindowStatus"] &&
                [[dicdata objectForKey:id]isEqualToString:@"1"]) {
                msg = @"车窗开启";
            }
        }
        
        for (NSString * id in arrayKeys) {
            if ([id containsString:@"DoorStatus"] &&
                [[dicdata objectForKey:id]isEqualToString:@"1"]) {
                msg = @"车门开启";
            }
        }
        
        if (msg != nil) {
            [dicValue setObject: msg forKey:@"doorlock"];
        }
        else {
            [self.homeTableView reloadData];
            
//            [self.homeTableView.mj_header endRefreshing];
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }
    
    if ([[dicValue objectForKey:@"requestStatus"] isEqualToString:@"Success"] &&[dicValue objectForKey:@"flag"] == nil) {
        [self sendPostSessionForStatus];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }

    NSLog(@"HomePage -- %@", dicValue);
    if ([dicValue count] == 5) {
        [self.homeTableView reloadData];
//        [m_refreshController endRefreshing];
        [self.homeTableView.mj_header endRefreshing];
        [mlb_carnum setText: [UserManager vehicleLisence]];
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
