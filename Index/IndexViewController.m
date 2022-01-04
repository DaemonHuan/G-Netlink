//
//  IndexViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/15/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "IndexViewController.h"
#import "MainNavigationController.h"
#import "public.h"

#import "HomePageTableViewCell.h"
#import "OneKeyTableViewCell.h"

#import "VehicleManagerViewController.h"
#import "DashBoardViewController.h"
#import "WarningViewController.h"


@interface IndexViewController () <UITableViewDataSource, UITableViewDelegate, PostSessionDataDelegate, DJRefreshDelegate>

@end

@implementation IndexViewController {
    IBOutlet UILabel * la_code;
    IBOutlet UITableView * m_tableview;
    
    NSArray * arrayItem;
    NSArray * arrayIcon;
    NSMutableDictionary * m_listData;
    CGFloat tableviewHeight;
    
    BOOL thisFlag;
    NSString * lastTime;

    DJRefresh * m_refrese;
    GetPostSessionData * postSession;
    BOOL flagForSessionStatus;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [la_code setFont:[UIFont fontWithName: FONT_MM size: 22.0f]];
    [la_code setTextColor:[UIColor whiteColor]];
    [la_code setTextAlignment:NSTextAlignmentCenter];
    arrayItem = [[NSArray alloc]initWithObjects:@"车门车窗和车锁", @"可续航里程", @"告警", @"一键服务", nil];
    arrayIcon = [[NSArray alloc]initWithObjects:@"home_lock", @"home_howfar", @"home_alert", @"home_onekey", nil];
    tableviewHeight = [UIScreen mainScreen].bounds.size.height * 0.7f;
    
    m_listData = [[NSMutableDictionary alloc]init];
    [m_listData setObject:@"数据加载中 ..." forKey:@"VSTATUS"];
    [m_listData setObject:@"数据加载中 ..." forKey:@"VRANGE"];
    [m_listData setObject:@"数据加载中 ..." forKey:@"VWARNING"];
    
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
    
    // tableview HeaderView
    UIView * tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f)];
    UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_seperateline02"]];
    headerImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f);
    [tableHeaderView addSubview: headerImage];
    m_tableview.tableHeaderView = tableHeaderView;
    m_tableview.tableFooterView = [[UIView alloc]init];     // 隐藏多余的分割线
    
    if ([self.UserInfo isRunDemo]) {
        [self.view addSubview: [ExtendStaticView MarkDemoView]];
    }
    
    // tableview refrese
    m_refrese = [DJRefresh refreshWithScrollView: m_tableview];
    m_refrese.delegate = self;
    m_refrese.topEnabled = YES;
    m_refrese.autoRefreshTop = YES;
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
    flagForSessionStatus = YES;
    
    //
    thisFlag = YES;
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doClickedHomeToBackground:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doReturnToThis:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) doClickedHomeToBackground:(NSNotification *)notification {
//    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) doReturnToThis:(NSNotification *)notification {
//    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [la_code setText:[self.UserInfo gDefaultVehicleLisence]];
    self.flagForViewHidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.flagForViewHidden = YES;
}

- (void) refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if (flagForSessionStatus == NO) return;
        
        // init data
        [m_listData setObject:@"数据加载中 ..." forKey:@"VSTATUS"];
        [m_listData setObject:@"数据加载中 ..." forKey:@"VRANGE"];
        [m_listData setObject:@"数据加载中 ..." forKey:@"VWARNING"];
        [m_tableview reloadData];
        
        if ([self.UserInfo isKCUser]) {
            [self sendPostSessionForKCData];
        }
        else {
            [self sendPostSessionForBasicData];
            
            if (thisFlag) [self sendPostSessionForVehicleStatusOnce];
            else [self sendPostSessionForVehicleStatus];
        }
    });
}

- (void) sendPostSessionForUserInfo {
    NSString * url = [NSString stringWithFormat:@"%@/api/getUserInfo", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"%@", self.userfixstr];
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) sendPostSessionForBasicData {
    NSString * url = [NSString stringWithFormat:@"%@/api/searchVhlStatus", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) sendPostSessionForVehicleStatusOnce {
    thisFlag = NO;
    flagForSessionStatus = NO;
    //    dispatch_release(dispatch_get_global_queue(0, 0));
    dispatch_queue_t queue = dispatch_queue_create("gnetlink.indexviewcontroller", NULL);
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    dispatch_async(queue, ^{
        NSString * code = nil;
        NSString * url = [NSString stringWithFormat:@"%@/api/getVhlCtlLastStatus", HTTP_GET_POST_ADDRESS];
        NSString * body = [NSString stringWithFormat:@"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
        NSDictionary * mdic = [self fetchPostSession:url Body:body];
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self setVehicleStatus:mdic];
            flagForSessionStatus = YES;
        });
    });
}

- (void) sendPostSessionForVehicleStatus {
    flagForSessionStatus = NO;
//    dispatch_release(dispatch_get_global_queue(0, 0));
    dispatch_queue_t queue = dispatch_queue_create("gnetlink.indexviewcontroller", NULL);
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    dispatch_async(queue, ^{
        NSString * code = nil;
        NSString * url = [NSString stringWithFormat:@"%@/api/sendVhlCtlStatusRequest", HTTP_GET_POST_ADDRESS];
        NSString * body = [NSString stringWithFormat:@"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
        NSDictionary * mdic = [self fetchPostSession:url Body:body];
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        
        if (![code isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_listData setObject:@"加载失败 .." forKey:@"VSTATUS"];
                [m_tableview reloadData];
                
                flagForSessionStatus = YES;
            });
            return;
        }
        
        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_VEHICLESTATUS];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
        url = [NSString stringWithFormat:@"%@/api/getVhlCtlStatus", HTTP_GET_POST_ADDRESS];
        while (sp > 0.0f) {
            if (self.flagForViewHidden) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"self.view.isHidden For Vehicle Status ..");
                });
                return;
            }
            
            sp = [sDate timeIntervalSinceDate:[NSDate date]];

            mdic = [self fetchPostSession:url Body:body];
            code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
            NSLog(@"** get vehicle status - %f %@", sp, code);
            if ([code isEqualToString:@"200"]) break;
            
            // 暂停 2s
            [NSThread sleepForTimeInterval: 3.0f];
        }
        
        if (sp < 0.0f) { // Time out
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Vehicle Status Time Out ..");
                [m_listData setObject:@"加载失败 .." forKey:@"VSTATUS"];
                [m_tableview reloadData];
                
                flagForSessionStatus = YES;
            });
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self setVehicleStatus:mdic];
            
            flagForSessionStatus = YES;
        });
    });
}

- (void) sendPostSessionForKCData {
//    [m_listData setObject:@"..." forKey:@"VRANGE"];
    flagForSessionStatus = NO;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * url = [NSString stringWithFormat:@"%@/system/dashboard/query", HTTP_GET_POST_ADDRESS_KC];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
        [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
        [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
        [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
        NSDictionary * body = [self fixDictionaryForKCSession:dict];
        NSDictionary * mdic = [self fetchPostSessionForKC:url Body:body];
        NSDictionary * value = [mdic objectForKey:@"data"];
        
        NSString * code = [[mdic objectForKey:@"errcode"] stringValue];
        if ([code isEqualToString:@"0"]) {
            NSString * res = [value objectForKey:@"dte_odometer"];
            if (res == nil || [res isEqualToString:@""] || [res isEqualToString:@"0"]) {
                res = @"--";
            }
            
            [m_listData setObject:[NSString stringWithFormat:@"%@ 公里", res] forKey:@"VRANGE"];
        }
        else {
            [m_listData setObject:@"数据加载失败!" forKey:@"VRANGE"];
        }
        
        url = [NSString stringWithFormat:@"%@/system/condition/query11", HTTP_GET_POST_ADDRESS_KC];
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
        [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
        [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
        [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
        body = [self fixDictionaryForKCSession:dict];
        mdic = [self fetchPostSessionForKC:url Body:body];
        
        value = [mdic objectForKey:@"data"];
        if ([[[mdic objectForKey:@"errcode"]stringValue] isEqualToString:@"0"]) {
            NSInteger tmp = [[[value objectForKey:@"doorand_trunk"] objectForKey:@"door_status"] integerValue];
            if (tmp == 0) {
                [m_listData setObject:@"全部关闭" forKey:@"VSTATUS"];
            }
            else {
                [m_listData setObject:@"车锁开启" forKey:@"VSTATUS"];
            }
        }
        else {
            [m_listData setObject:@"数据加载失败!" forKey:@"VSTATUS"];
        }
        
        url = [NSString stringWithFormat:@"%@/system/diagnosis/query", HTTP_GET_POST_ADDRESS_KC];
        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
        [param setObject: dict forKey: @"ntspheader"];
        [param setObject: @"0" forKey:@"start"];
        [param setObject: @"1" forKey:@"rows"];
        mdic = [self fetchPostSessionForKC:url Body:param];
        value = [mdic objectForKey:@"data"];
        
        if ([[[mdic objectForKey:@"errcode"]stringValue] isEqualToString:@"0"]) {
            NSInteger tmp = [[value objectForKey:@"acc_status"] integerValue];
            tmp += [[value objectForKey:@"acu_status"] integerValue];
            tmp += [[value objectForKey:@"bcm_light_status"] integerValue];
            tmp += [[value objectForKey:@"ems_status"] integerValue];
            tmp += [[value objectForKey:@"eps_status"] integerValue];
            tmp += [[value objectForKey:@"esp_status"] integerValue];
            tmp += [[value objectForKey:@"lde_status"] integerValue];
            tmp += [[value objectForKey:@"pas_status"] integerValue];
            tmp += [[value objectForKey:@"peps_status"] integerValue];
            tmp += [[value objectForKey:@"tcu_status"] integerValue];
            tmp += [[value objectForKey:@"tpms_status"] integerValue];
            
            if (tmp == 0) {
                [m_listData setObject:@"一切正常" forKey:@"VWARNING"];
            }
            else {
                [m_listData setObject:@"车辆发现故障" forKey:@"VWARNING"];
            }
        }
        else {
            [m_listData setObject:@"数据加载失败!" forKey:@"VWARNING"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
            [m_tableview reloadData];
            
            flagForSessionStatus = YES;
        });
    });
}

- (void) didPostSessionRequest:(NSString *)request {
    if ([request isEqualToString:@"NSURLErrorNetworkConnectionLost"]) {
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
        return;
    }
    
    if ([request isEqualToString:@"jk-Error"]) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:NETWORK_ERROR];
        [alertview show];
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
        return;
    }
    
    NSString * code = nil;
    NSDictionary * mdic = [postSession getDictionaryFromRequest];
    
    code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        // 续航公里
        [m_listData setObject:[NSString stringWithFormat:@"%@", [mdic objectForKey:@"rangeUnit"]] forKey:@"VRANGE"];
        // 警告信息
        NSArray * alertList = [mdic objectForKey:@"alertList"];
        if ([alertList count] == 0) {
            [m_listData setObject:@"一切正常" forKey:@"VWARNING"];
        }
        else {
            [m_listData setObject:@"车辆发现故障" forKey:@"VWARNING"];
        }
        
        // 刷新列表
        [m_tableview reloadData];
    }
    else if ([code isEqualToString:@"402"]) {
        [(MainNavigationController *)self.navigationController doLogoff:self.userfixstr];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyRunStatus Value:@"OTHERLINE"];
    }
    else {
        [m_listData setObject:@"加载失败 .." forKey:@"VRANGE"];
        [m_listData setObject:@"加载失败 .." forKey:@"VWARNING"];
        [m_tableview reloadData];
        
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
        [alertview show];
    }

    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setVehicleStatus: (NSDictionary *)dic {
    // 车辆状况优先级: 车门 ->车窗 ->后背厢 ->天窗 ->车锁
    NSArray * keys = [dic allKeys];
    NSInteger errorcount = 0;
    if ([keys containsObject:@"doorLockState"]
        && [keys containsObject:@"dormerStatus"]
        && [keys containsObject:@"trunkStatus"])
    {
        
        lastTime = [dic objectForKey:@"startTime"];
        
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

// tableview delegate Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [arrayItem count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeiht = tableviewHeight/4.0f;
    if ([self.UserInfo isRunDemo]) {
        cellHeiht = (tableviewHeight - 30.0f) / 4.0f;
    }
    return cellHeiht;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        
        if (indexPath.row == 0) {
            [cell setLabelText:[arrayItem objectAtIndex:indexPath.row] value:[m_listData objectForKey:@"VSTATUS"]];
            if ([lastTime length] == 19) {
                [cell setItemTime:[lastTime substringWithRange:NSMakeRange(0, 10)] Time:[lastTime substringWithRange:NSMakeRange(11, 8)]];
            }
        }
        
        if (indexPath.row == 1) {
            [cell setLabelText:[arrayItem objectAtIndex:indexPath.row] value:[m_listData objectForKey:@"VRANGE"]];
        }
        
        if (indexPath.row == 2) {
            [cell setLabelText:[arrayItem objectAtIndex:indexPath.row] value:[m_listData objectForKey:@"VWARNING"]];
        }
        res = cell;
    }
    else if (indexPath.row == ([arrayItem count] - 1)) {
        static NSString * cellIdentifier = @"OneKeyTableViewCell";
        OneKeyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:@"OneKeyTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        }
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if ([self.UserInfo isKCUser]) {
            [cell setSingleCell:@"menu_goto" Value:@"一键导航"];
        }
        else {
            [cell setSingleCell:[arrayIcon objectAtIndex:indexPath.row] Value:@"一键服务"];
        }
        res = cell;
    }
    res.selectionStyle = UITableViewCellSelectionStyleNone;
    return res;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 去除选中行的被选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [(MainNavigationController *)self.navigationController doSwitchViewController];
        VehicleManagerViewController * view = [[VehicleManagerViewController alloc]init];
        self.navigationController.viewControllers = @[view];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        [(MainNavigationController *)self.navigationController doSwitchViewController];
        DashBoardViewController * view = [[DashBoardViewController alloc]init];
        self.navigationController.viewControllers = @[view];
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        [(MainNavigationController *)self.navigationController doSwitchViewController];
        WarningViewController * view = [[WarningViewController alloc]init];
        self.navigationController.viewControllers = @[view];
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
    // 一键服务
        NSString * telCode = nil;
        AlertBoxView * alert = nil;
        
        if ([self.UserInfo isKCUser]) {
            telCode = @"0571-28815911";
            alert = [[AlertBoxView alloc]initWithTitle:@"确认拨打导航电话\n0571-28815911" Enter:@"确认" Cancle:@"取消"];
            
        }
        else {
            telCode = @"4000176801";
            alert = [[AlertBoxView alloc]initWithTitle:@"确认拨打服务电话\n4000176801" Enter:@"确认" Cancle:@"取消"];
        }
        alert.okBlock = ^() {
            [ExtendStaticFunctions doCallForHelp: telCode];
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
