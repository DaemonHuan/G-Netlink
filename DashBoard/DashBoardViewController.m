//
//  DashBoardViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/31/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "DashBoardViewController.h"
#import "public.h"
#import "DashBoardTableViewCell.h"

@interface DashBoardViewController () <PostSessionDataDelegate, UITableViewDataSource, UITableViewDelegate, DJRefreshDelegate>

@end

@implementation DashBoardViewController {
    IBOutlet UILabel * la_title;
    IBOutlet UIImageView * iv_title;
    IBOutlet UITableView * m_tableview;
    
    NSMutableArray * m_arrtablevalue;
    NSArray * m_arrimageicon;
    NSArray * m_arrtitletext;
    
    GetPostSessionData * postSession;
    DJRefresh * m_refrese;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"仪表盘"];
    
    m_arrtablevalue = [[NSMutableArray alloc] init];

    if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GS"]) {
        m_arrimageicon = [[NSArray alloc] initWithObjects:@"dash_oil", @"dash_pay", @"dash_rang", @"dash_long", @"dash_speed", nil];
        m_arrtitletext = [[NSArray alloc] initWithObjects:@"剩余油量", @"百公里油耗", @"可续航里程", @"总里程", @"平均车速", nil];
    }
    else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GL"]) {
        m_arrimageicon = [[NSArray alloc] initWithObjects:@"dash_oil", @"dash_pay", @"dash_rang", @"dash_long", @"dash_speed", nil];
        m_arrtitletext = [[NSArray alloc] initWithObjects:@"剩余油量", @"百公里油耗", @"可续航里程", @"总里程", @"平均车速", nil];
    }
    else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博越"]) {
        m_arrimageicon = [[NSArray alloc] initWithObjects:@"dash_oil", @"dash_pay", @"dash_rang", @"dash_long", @"dash_speed", @"dash_away", nil];
        m_arrtitletext = [[NSArray alloc] initWithObjects:@"剩余油量", @"百公里油耗", @"可续航里程", @"总里程", @"平均车速", @"距离保养总里程", nil];
    }
    else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博瑞"]) {
        m_arrimageicon = [[NSArray alloc] initWithObjects:@"dash_oil", @"dash_battery", @"dash_pay", @"dash_rang", @"dash_long", @"dash_speed", @"dash_away", nil];
        m_arrtitletext = [[NSArray alloc] initWithObjects:@"剩余油量", @"蓄电池", @"百公里油耗", @"可续航里程", @"总里程", @"平均车速", @"距离保养总里程", nil];
    }
    
    [la_title setText:[self.UserInfo gDefaultVehicleLisence]];
    
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
    
    //
    [la_title setText:[self.UserInfo gDefaultVehicleLisence]];
    [la_title setTextColor:[UIColor whiteColor]];
    [la_title setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE1]];

    //
    UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_seperateline02"]];
    headerImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f);
    m_tableview.tableHeaderView = headerImage;
    m_tableview.allowsSelection = NO;
    [m_tableview setSeparatorColor:[UIColor clearColor]];
    // 隐藏多余的分割线
    m_tableview.tableFooterView = [[UIView alloc]init];
    
    m_refrese = [DJRefresh refreshWithScrollView: m_tableview];
    m_refrese.delegate = self;
    m_refrese.topEnabled = YES;
    m_refrese.autoRefreshTop = YES;
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
    
    if ([self.UserInfo isRunDemo]) {
        [self.view addSubview: [ExtendStaticView MarkDemoView]];
    }
}

- (void) refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // init data
        if ([self.UserInfo isKCUser]) [self sendPostSessionForKCVehicleStatus];
        else [self sendPostSessionForVehicleStatus];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) sendPostSessionForKCVehicleStatus {
    NSString * url = [NSString stringWithFormat:@"%@/system/dashboard/query", HTTP_GET_POST_ADDRESS_KC];
    
    // 15695863592 123456
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
    [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
    [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
    [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
    
    [postSession SendPostSessionRequestForKC:url Body: [self fixDictionaryForKCSession:dict]];
}

- (void) sendPostSessionForVehicleStatus {
    NSString * url = [NSString stringWithFormat:@"%@/api/searchVhlStatus", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    if ([request isEqualToString:@"NSURLErrorNetworkConnectionLost"]) {
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
        return;
    }
    
    if ([request isEqualToString:@"jk-Error"]) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton: NETWORK_ERROR];
        [alertview show];
        [m_refrese finishRefreshingDirection: DJRefreshDirectionTop animation:YES];
        return;
    }
    
    NSString * code = nil;
    NSDictionary * mdic = nil;
    
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
    
    if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GS"]) {
        mdic = [postSession getDictionaryFromRequest];
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        
        if ([[mdic allKeys] containsObject:@"alertList"] && [[mdic allKeys] containsObject:@"range"]) {
            if ([code isEqualToString:@"200"]) {
                [m_arrtablevalue removeAllObjects];
                [m_tableview setSeparatorColor:[UIColor lightGrayColor]];
                
                // 剩余油量 remainedOil ％ 显示 %% 升
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", ([mdic objectForKey:@"remainedOilUnit"])]];
                // 百公里油耗 fuelConsumedAverage  升/100公里
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"fuelConsumedAverageUnit"]]];
                // 可续航里程 range  公里
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"rangeUnit"]]];
                // 总里程 totalMileage  公里
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"totalMileageUnit"]]];
                // 平均车速 speedAverage  公里/小时
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"speedAverageUnit"]]];
                // 距离保养总里程 mileageBeforeMaintenance  公里
//                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"mileageBeforeMaintenanceUnit"]]];
                
                // 刷新列表
                [m_tableview reloadData];
            }
            else {
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
                [alertview show];
            }
        }
    }
    else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GL"]) {
        mdic = [postSession getDictionaryFromRequest];
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        
        if ([[mdic allKeys] containsObject:@"alertList"] && [[mdic allKeys] containsObject:@"range"]) {
            if ([code isEqualToString:@"200"]) {
                [m_arrtablevalue removeAllObjects];
                [m_tableview setSeparatorColor:[UIColor lightGrayColor]];
                
                // 剩余油量 remainedOil ％ 显示 %% 升
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", ([mdic objectForKey:@"remainedOilUnit"])]];
                // 百公里油耗 fuelConsumedAverage  升/100公里
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"fuelConsumedAverageUnit"]]];
                // 可续航里程 range  公里
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"rangeUnit"]]];
                // 总里程 totalMileage  公里
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"totalMileageUnit"]]];
                // 平均车速 speedAverage  公里/小时
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"speedAverageUnit"]]];
                // 距离保养总里程 mileageBeforeMaintenance  公里
                //                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"mileageBeforeMaintenanceUnit"]]];
                
                // 刷新列表
                [m_tableview reloadData];
            }
            else {
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
                [alertview show];
            }
        }
    }
    else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博越"]) {
        mdic = [postSession getDictionaryFromRequest];
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        
        if ([[mdic allKeys] containsObject:@"alertList"] && [[mdic allKeys] containsObject:@"range"]) {
            if ([code isEqualToString:@"200"]) {
                [m_arrtablevalue removeAllObjects];
                [m_tableview setSeparatorColor:[UIColor lightGrayColor]];
                
                // 剩余油量 remainedOil ％ 显示 %% 升
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", ([mdic objectForKey:@"remainedOilUnit"])]];
                // 百公里油耗 fuelConsumedAverage  升/100公里
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"fuelConsumedAverageUnit"]]];
                // 可续航里程 range  公里
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"rangeUnit"]]];
                // 总里程 totalMileage  公里
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"totalMileageUnit"]]];
                // 平均车速 speedAverage  公里/小时
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"speedAverageUnit"]]];
                // 距离保养总里程 mileageBeforeMaintenance  公里
                [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@", [mdic objectForKey:@"mileageBeforeMaintenanceUnit"]]];
                
                // 刷新列表
                [m_tableview reloadData];
            }
            else {
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
                [alertview show];
            }
        }
    }
    else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博瑞"]) {
        mdic = [postSession getDictionaryFromRequest];
        code = [[mdic objectForKey:@"errcode"] stringValue];
        NSDictionary * dict = [mdic objectForKey:@"data"];
        
        if ([mdic count] == 3 && [[mdic allKeys] containsObject:@"data"]) {
            [m_arrtablevalue removeAllObjects];
            [m_tableview setSeparatorColor:[UIColor lightGrayColor]];
            
            // 剩余油量 remainedOil ％ 显示 %% 升
            NSString * result = [dict objectForKey:@"fuel_level_status"];
            if (result == nil || [result isEqualToString:@""] || [result isEqualToString:@"0.0"]) {
                result = @"--";
            }
            [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@ 升", result]];
            // 蓄电池
            [m_arrtablevalue addObject: ([[dict objectForKey:@"battery_voltage_error_status"] isEqualToString:@"0"] ? @"正常" : @"不正常")];
            // 百公里油耗 fuelConsumedAverage  升/100公里
            result = [dict objectForKey:@"average_fuel_consumption"];
            if (result == nil || [result isEqualToString:@""] || [result isEqualToString:@"0.0"]) {
                result = @"--";
            }
            [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@ 升/100公里", result]];
            // 可续航里程 range  公里
            result = [dict objectForKey:@"dte_odometer"];
            if (result == nil || [result isEqualToString:@""] || [result isEqualToString:@"0"]) {
                result = @"--";
            }
            [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@ 公里", result]];
            // 总里程 totalMileage  公里
            result = [dict objectForKey:@"total_odometer"];
            if (result == nil || [result isEqualToString:@""] || [result isEqualToString:@"0"]) {
                result = @"--";
            }
            [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@ 公里", result]];
            // 平均车速 speedAverage  公里/小时
            result = [dict objectForKey:@"average_vehicle_speed"];
            if (result == nil || [result isEqualToString:@""] || [result isEqualToString:@"0"]) {
                result = @"--";
            }
            [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@ 公里/小时", result]];
            // 距离保养总里程 mileageBeforeMaintenance  公里
            result = [dict objectForKey:@"distance_maintenance_mileage"];
            if (result == nil || [result isEqualToString:@""] || [result isEqualToString:@"0"]) {
                result = @"--";
            }
            [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@ 公里", result]];
            
            // 刷新列表
            [m_tableview reloadData];
        }
        else {
            NSString * str = [mdic objectForKey:@"errmsg"];
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:str];
            alertview.okBlock = ^(){
                [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
            };
            [alertview show];
            return;
        }
    }
    
    // 重新登录
    if ([code isEqualToString:@"402"]) {
        [(MainNavigationController *)self.navigationController doLogoff:self.userfixstr];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyRunStatus Value:@"OTHERLINE"];
    }
}

// config tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [m_arrtablevalue count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DashBoardTableViewCell";
    
    DashBoardTableViewCell *cell = (DashBoardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    [cell setItemTitle: [m_arrtitletext objectAtIndex:indexPath.row]];
    [cell setItemIcon: [m_arrimageicon objectAtIndex:indexPath.row]];
    [cell setItemValue: [m_arrtablevalue objectAtIndex:indexPath.row]];
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
