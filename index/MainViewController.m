//
//  MainViewController.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/7/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "MainViewController.h"
#import "MainNavigationController.h"
#import "HomePageTableViewCell.h"
#import "OneKeyTableViewCell.h"

#import "jkAlertController.h"
#import "GetPostSessionData.h"
#import "DJRefresh.h"
#import "public.h"
#import "GNLUserInfo.h"

#import "VehicleManagerViewController.h"
#import "DashBoardViewController.h"
#import "WarningViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, DJRefreshDelegate, PostSessionDataDelegate, UIGestureRecognizerDelegate>

@end

@implementation MainViewController {
    NSArray * arrayItem;
    NSArray * arrayIcon;

    CGFloat tableviewHeight;
    GetPostSessionData * postSession;
    DJRefresh * m_refrese;
    IBOutlet UILabel * lb_carnum;
    IBOutlet UIImageView * titileImageView;
    IBOutlet UITableView * m_tableview;
    
    NSMutableDictionary * m_listData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_menuicon"] style: UIBarButtonItemStylePlain target:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];

    tableviewHeight = [UIScreen mainScreen].bounds.size.height - CGRectGetHeight(titileImageView.bounds);
    
    // data init
    postSession = [[GetPostSessionData alloc] init];
    postSession.delegate = self;
    
    [lb_carnum setTextAlignment: NSTextAlignmentCenter];
    [lb_carnum setTextColor:[UIColor whiteColor]];
    [lb_carnum setFont: [UIFont fontWithName:FONT_MM size:24.0f]];
    
    arrayItem = [[NSArray alloc]initWithObjects:@"车门车窗和车锁", @"可续航里程", @"告警", @"一键服务", nil];
    arrayIcon = [[NSArray alloc]initWithObjects:@"home_lock", @"home_howfar", @"home_alert", @"home_onekey", nil];
    
    // tableview HeaderView 
    UIView * tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f)];
    UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_seperateline02"]];
    headerImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f);
    [tableHeaderView addSubview: headerImage];
    m_tableview.tableHeaderView = tableHeaderView;
    //
    m_listData = [[NSMutableDictionary alloc]init];
    [m_listData setObject:@"数据加载中 .." forKey:@"VSTATUS"];
    [m_listData setObject:@"数据加载中 .." forKey:@"VRANGE"];
    [m_listData setObject:@"数据加载中 .." forKey:@"VWARNING"];
    
    // tableview refrese
    m_refrese = [DJRefresh refreshWithScrollView: m_tableview];
    m_refrese.delegate=self;
    m_refrese.topEnabled=YES;
    m_refrese.autoRefreshTop=YES;
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
    //
    if ([GNLUserInfo isDemo]) {
        [self.view addSubview: [ServicesPro loadMarkDemoView]];
    }
    
//    jkAlertController * alert = [[jkAlertController alloc] initWithTitle:@"" CenterLabel: @"尊敬的用户，本版本为内测版，如遇数据无法正常获取情况，敬请谅解！" Enter: @"我知道了" Cancle: nil];
//    [alert show];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    // navigationController.navigationBar
    [lb_carnum setText:[GNLUserInfo defaultCarLisence]];
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) viewDidDisappear:(BOOL)animated {
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // init data
        [m_listData setObject:@"数据加载中 .." forKey:@"VSTATUS"];
        [m_listData setObject:@"数据加载中 .." forKey:@"VRANGE"];
        [m_listData setObject:@"数据加载中 .." forKey:@"VWARNING"];
        [m_tableview reloadData];
        [self getPostSessionBaiscData];
        [self docheckVehicleStatus];
    });
}

- (void) getPostSessionBaiscData {
    // 可续航公里  && 告警信息
    NSString * url = [NSString stringWithFormat:@"%@/api/searchVhlStatus", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&username=%@&vin=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo userID], [GNLUserInfo defaultCarVin], [GNLUserInfo isDemo] ? @"true" : @"false"];
    //    NSLog(@"%@ %@", url, body );
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
//    NSLog(@"Index - %@", request);
    if ([request isEqualToString:@"jk-error .."]) {
        jkAlertController * alerttopost = [[jkAlertController alloc] initWithOKButton:NETWORK_ERROR ];
        [alerttopost show];
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
        return;
    }
    if ([request isEqualToString:@"jk-timeout .."]) {
        jkAlertController * alerttopost = [[jkAlertController alloc] initWithOKButton:NETWORK_TIMEOUT ];
        [alerttopost show];
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
        [m_tableview reloadData];
        return;
    }

    NSDictionary * dic = [postSession getDictionaryFromRequest];
    NSString * code = [[dic objectForKey:@"status"] objectForKey:@"code"];

    if ([code isEqualToString: @"402"]) {
        MainNavigationController * ctl = (MainNavigationController *) self.navigationController;
        [ctl turntoLoginForOut];
        return;
    }
    
    if (![code isEqualToString: @"200"]) {
        jkAlertController * view = [[jkAlertController alloc]initWithOKButton:DATA_ERROR];
        [view show];
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
        return;
    }

    [lb_carnum setText:[GNLUserInfo defaultCarLisence]];
    [m_listData setObject:@"数据加载中 .." forKey:@"VSTATUS"];

    // 续航公里
    [m_listData setObject:[NSString stringWithFormat:@"%@ 公里", [dic objectForKey:@"range"]] forKey:@"VRANGE"];
    // 警告信息
    NSArray * tmpArray = [dic objectForKey:@"alertList"];
    if ([tmpArray count] == 0) {
        [m_listData setObject:@"一切正常" forKey:@"VWARNING"];
    }
    else {
        [m_listData setObject:@"车辆发现故障" forKey:@"VWARNING"];
    }

    // 刷新列表
    [m_tableview reloadData];
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

///////////////
- (void) docheckVehicleStatus {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger status = [self sendPostSessionForStatusRequest];
        if (status != 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_listData setObject:@"加载失败 .." forKey:@"VSTATUS"];
                [m_tableview reloadData];
            });
            return;
        }
        
        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow:90.0f];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
        NSDictionary * dicstatus;
        while (sp > 0.0f) {
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            // 暂停 2s
            [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
            
            dicstatus = [self sendPostSessionForStatus];
            
            NSString * res = [[dicstatus objectForKey:@"status"]objectForKey:@"code"];
            NSLog(@"** get vehicle status - %f %@", sp, res);
            if ([res isEqualToString:@"200"]) {
                NSLog(@"Request: %@", dicstatus);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dosetVehicleStatus:dicstatus];
                });
                break;
            }
        }
        
        if (sp < 0.0f) {
            NSLog( @"time out ..");
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_listData setObject:@"加载失败 .." forKey:@"VSTATUS"];
                [m_tableview reloadData];
//                jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:NETWORK_TIMEOUT];
//                [alert show];
            });
            return;
        }
    });
}

// 车辆状态查询请求
- (NSInteger) sendPostSessionForStatusRequest {
    // 同步 POST 请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/sendVhlCtlStatusRequest", HTTP_GET_POST_ADDRESS]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
    //设置请求方式为POST
    [request setHTTPMethod:@"POST"];
    // 设置参数
    NSString * body = [NSString stringWithFormat:@"vin=%@&accessToken=%@&username=%@&isdemo=%@", [GNLUserInfo defaultCarVin], [GNLUserInfo accessToken], [GNLUserInfo userID], [GNLUserInfo isDemo] ? @"true" : @"false"];
    NSLog(@"***** body - %@", body);
    NSData * data = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: nil];
    if (dic == nil) return 0;
    NSLog(@"Request: %@", dic);
    
    NSString * code = [[dic objectForKey:@"status"]objectForKey:@"code"];
    if ([code isEqualToString:@""] || code == nil) {
        return 0;
    }
    else {
        return [code integerValue];
    }
}

// 车辆状态查询
- (NSDictionary *) sendPostSessionForStatus {
    // 同步 POST 请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/getVhlCtlStatus", HTTP_GET_POST_ADDRESS]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
    //设置请求方式为POST
    [request setHTTPMethod:@"POST"];
    // 设置参数
    NSString * body = [NSString stringWithFormat:@"vin=%@&accessToken=%@&username=%@&isdemo=%@", [GNLUserInfo defaultCarVin], [GNLUserInfo accessToken], [GNLUserInfo userID], [GNLUserInfo isDemo] ? @"true" : @"false"];
    NSData * data = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: nil];
    
    return dic;
}

- (void) dosetVehicleStatus: (NSDictionary *)dic {
    // 车辆状况优先级: 车门 ->车窗 ->后背厢 ->天窗 ->车锁
    NSArray * keys = [dic allKeys];
    NSInteger errorcount = 0;
    if ([keys containsObject:@"doorLockState"]
        && [keys containsObject:@"dormerStatus"]
        && [keys containsObject:@"trunkStatus"])
    {
        if ([[dic objectForKey:@"doorLockState"] isEqualToString:@"1"]) {
            [m_listData setObject:@"车锁开启" forKey:@"VSTATUS"];
            errorcount += 1;
        }
        
        if ([[dic objectForKey:@"dormerStatus"] isEqualToString:@"1"]) {
            [m_listData setObject:@"天窗开启" forKey:@"VSTATUS"];
            errorcount += 1;
        }
        
        if ([[dic objectForKey:@"trunkStatus"] isEqualToString:@"1"]) {
            [m_listData setObject:@"后备箱开启" forKey:@"VSTATUS"];
            errorcount += 1;
        }
        
        NSInteger num = [[NSString stringWithString:[dic objectForKey:@"no1WindowStatus"]]intValue]
        + [[NSString stringWithString:[dic objectForKey:@"no2WindowStatus"]]intValue]
        + [[NSString stringWithString:[dic objectForKey:@"no3WindowStatus"]]intValue]
        + [[NSString stringWithString:[dic objectForKey:@"no4WindowStatus"]]intValue];
        
        if (num > 0) {
            [m_listData setObject:@"车窗开启" forKey:@"VSTATUS"];
            errorcount += 1;
        }
        
        num = [[NSString stringWithString:[dic objectForKey:@"leftFrontDoorStatus"]]intValue]
        + [[NSString stringWithString:[dic objectForKey:@"rightFrontDoorStatus"]]intValue]
        + [[NSString stringWithString:[dic objectForKey:@"leftRearDoorStatus"]]intValue]
        + [[NSString stringWithString:[dic objectForKey:@"rightRearDoorStatus"]]intValue];
        
        if (num > 0) {
            [m_listData setObject:@"车门开启" forKey:@"VSTATUS"];
        }
    }
    
    if (errorcount == 0) {
        [m_listData setObject:@"车辆正常" forKey:@"VSTATUS"];
    }
    [m_tableview reloadData];
}
///////////////

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// tableview delegate Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [arrayItem count];
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeiht = tableviewHeight/4.0f;
    if ([GNLUserInfo isDemo]) {
        cellHeiht = (tableviewHeight - 30.0f) / 4.0f;
    }
    return cellHeiht;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"indexPath.row %ld", indexPath.row);
    NSString * tmp = @"数据加载中 ..";
    
    UITableViewCell * res = nil;
    
    if (indexPath.row != ([arrayItem count]-1)) {
        static NSString *cellIdentifier = @"HomePageTableCell";
        HomePageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:@"HomePageTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        }
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        [cell setLabelIcon:[arrayIcon objectAtIndex:indexPath.row]];
        [cell setLabelText: [arrayItem objectAtIndex:indexPath.row] value: tmp];

        if (indexPath.row == 0) {
            [cell setLabelText:[arrayItem objectAtIndex:indexPath.row] value:[m_listData objectForKey:@"VSTATUS"]];
        }
        
        if (indexPath.row == 1) {
            [cell setLabelText:[arrayItem objectAtIndex:indexPath.row] value:[m_listData objectForKey:@"VRANGE"]];
        }
        
        if (indexPath.row == 2) {
            [cell setLabelText:[arrayItem objectAtIndex:indexPath.row] value:[m_listData objectForKey:@"VWARNING"]];
        }
        res = cell;
    }
    else if (indexPath.row == ([arrayItem count]-1)) {
        static NSString *cellIdentifier = @"OneKeyTableViewCell";
        OneKeyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:@"OneKeyTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        }
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        [cell setSingleCell:[arrayIcon objectAtIndex:indexPath.row] Value:@"一键服务"];
        res = cell;
    }
    res.selectionStyle = UITableViewCellSelectionStyleNone;
    return res;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 去除选中行的被选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        MainNavigationController * ctl = (MainNavigationController *)self.navigationController;
        [ctl doSwitchView:@"02"];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        MainNavigationController * ctl = (MainNavigationController *)self.navigationController;
        [ctl doSwitchView:@"06"];
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        MainNavigationController * ctl = (MainNavigationController *)self.navigationController;
        [ctl doSwitchView:@"07"];
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
        // 一键服务
        jkAlertController * alert = [[jkAlertController alloc]initWithTitle:@"" CenterLabel:@"确认拨打救援电话\n4000176801" Enter:@"确认" Cancle:@"取消"];
        alert.okBlock = ^() {
            [ServicesPro doCallForHelp];
        };
        [alert show];
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
