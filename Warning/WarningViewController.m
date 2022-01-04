
//
//  WarningViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/31/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "WarningViewController.h"
#import "public.h"
#import "WarningTableViewCell.h"
#import "AboutThisTableViewCell.h"
#import "AboutFunctionViewController.h"

#import "AlertViewForWarnDetail.h"



#define VEHICLE_STATUS_NORMAL @"看起来一切正常"
#define VEHICLE_STATUS_ERROR @"车辆发现故障"
#define VEHICLE_STATUS_NETWORK_ERROR @"信息获取失败"


@interface WarningViewController () <PostSessionDataDelegate, UITableViewDataSource, UITableViewDelegate, DJRefreshDelegate>

@end

@implementation WarningViewController {
    IBOutlet UILabel * la_title;
    IBOutlet UIImageView * iv_title;
    IBOutlet UITableView * m_tableview;
    
    GetPostSessionData * postSession;
    DJRefresh * m_refrese;
    
    NSDictionary * m_dicTitle;
    NSDictionary * m_dicIcon;
    NSDictionary * m_dicWIcon;
    NSDictionary * m_dicErrMsg;
    AlertViewForWarnDetail * m_ErrNotions;
    
    NSMutableArray * m_arrAllValue;
    NSMutableArray * m_arrErrValue;
    BOOL flagForKCWarning;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"告警"];
    
    // 根据默认车辆类型 选择车型图
    if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GS"] ||
        [[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GL"]) {
        m_dicTitle = @{@"01":@"TPMS胎压故障", @"02":@"水温高报警",
                       @"03":@"燃油过低报警", @"04":@"发动机故障",
                       @"05":@"发动机系统故障", @"06":@"EPS故障",
                       @"07":@"EPB故障", @"08":@"ABS故障",
                       @"09":@"ESP故障", @"10":@"EBD故障",
                       @"11":@"四驱过热故障", @"12":@"安全气囊故障指示灯",
                       @"13":@"保养里程报警"};
        m_dicIcon = @{@"01":@"warn_tpms", @"02":@"warn_dep",
                      @"03":@"warn_oil", @"04":@"warn_out",
                      @"05":@"warn_svs", @"06":@"warn_eps",
                      @"07":@"warn_epb", @"08":@"warn_abs",
                      @"09":@"warn_esc", @"10":@"warn_ebd",
                      @"11":@"warn_4wd", @"12":@"warn_box",
                      @"13":@"warn_ff"};
        m_dicWIcon = @{@"01":@"warn_tpms_w", @"02":@"warn_dep_w",
                       @"03":@"warn_oil_w", @"04":@"warn_out_w",
                       @"05":@"warn_svs_w", @"06":@"warn_eps_w",
                       @"07":@"warn_epb_w", @"08":@"warn_abs_w",
                       @"09":@"warn_esc_w", @"10":@"warn_ebd_w",
                       @"11":@"warn_4wd_w", @"12":@"warn_box_w",
                       @"13":@"warn_ff_w"};
        
        m_arrAllValue = [[NSMutableArray alloc]initWithObjects:@"01", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"12", @"13", nil];
    }
    else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博越"]) {
        m_dicTitle = @{@"01":@"TPMS胎压故障", @"02":@"水温高报警",
                       @"03":@"燃油过低报警", @"04":@"发动机排放故障",
                       @"05":@"发动机系统故障", @"06":@"EPS故障",
                       @"07":@"EPB故障", @"08":@"ABS故障",
                       @"09":@"ESC故障", @"10":@"EBD故障",
                       @"11":@"四驱过热故障", @"12":@"安全气囊故障指示灯"};
        m_dicIcon = @{@"01":@"warn_tpms", @"02":@"warn_dep",
                      @"03":@"warn_oil", @"04":@"warn_out",
                      @"05":@"warn_svs", @"06":@"warn_eps",
                      @"07":@"warn_epb", @"08":@"warn_abs",
                      @"09":@"warn_esc", @"10":@"warn_ebd",
                      @"11":@"warn_4wd", @"12":@"warn_box"};
        m_dicWIcon = @{@"01":@"warn_tpms_w", @"02":@"warn_dep_w",
                       @"03":@"warn_oil_w", @"04":@"warn_out_w",
                       @"05":@"warn_svs_w", @"06":@"warn_eps_w",
                       @"07":@"warn_epb_w", @"08":@"warn_abs_w",
                       @"09":@"warn_esc_w", @"10":@"warn_ebd_w",
                       @"11":@"warn_4wd_w", @"12":@"warn_box_w"};
        
        m_arrAllValue = [[NSMutableArray alloc]initWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", nil];
    }
    else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博瑞"]) {
        m_dicTitle = @{@"01":@"安全气囊", @"02":@"轮胎压力传感器",
                       @"03":@"发动机控制单元", @"04":@"电动助力转向",
                       @"05":@"电子稳定系统", @"06":@"泊车辅助系统",
                       @"07":@"无钥匙进入和电子控制单元", @"08":@"自适应巡航系统",
                       @"09":@"车道偏离警示系统", @"10":@"自动变速器",
                       @"11":@"小灯状态"};
        m_dicIcon = @{@"01":@"diagnosis_acu", @"02":@"diagnosis_tpms",
                      @"03":@"diagnosis_ems", @"04":@"diagnosis_eps",
                      @"05":@"diagnosis_esp", @"06":@"diagnosis_pas",
                      @"07":@"diagnosis_peps", @"08":@"diagnosis_acc",
                      @"09":@"diagnosis_ldw", @"10":@"diagnosis_tcu",
                      @"11":@"diagnosis_bcm" };
        m_dicWIcon = @{@"01":@"diagnosis_acu_e", @"02":@"diagnosis_tpms_e",
                       @"03":@"diagnosis_ems_e", @"04":@"diagnosis_eps_e",
                       @"05":@"diagnosis_esp_e", @"06":@"diagnosis_pas_e",
                       @"07":@"diagnosis_peps_e", @"08":@"diagnosis_acc_e",
                       @"09":@"diagnosis_ldw_e", @"10":@"diagnosis_tcu_e",
                       @"11":@"diagnosis_bcm_e" };
        
        m_dicErrMsg = @{@"01":@"您的ACU(安全气囊系统)存在故障,请您到经销店进行排查!",
                        @"02":@"您的TPMS(轮胎压力传感器)存在故障,请您到经销店进行排查!",
                        @"03":@"您的EMS(发动机控制单元)存在故障,请您到经销店进行排查!",
                        @"04":@"您的EPS(电动助力转向)存在故障,请您到经销店进行排查!",
                        @"05":@"您的ESP(电子稳定系统)存在故障,请您到经销店进行排查!",
                        @"06":@"您的PAS(泊车辅助系统)存在故障,请您到经销店进行排查!",
                        @"07":@"您的PEPS(无钥匙进入和启动电子控制单元)存在故障,请您到经销店进行排查!",
                        @"08":@"您的ACC(自适应巡航系统)存在故障,请您到经销店进行排查!",
                        @"09":@"您的LDW(车道偏离警示系统)存在故障,请您到经销店进行排查!	",
                        @"10":@"您的TCU(自动变速器)存在故障,请您到经销店进行排查!",
                        @"11":@"您的BCM(小灯状态)未关闭,请您及时排查关闭!"};
        
        m_arrAllValue = [[NSMutableArray alloc]initWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", nil];
    }
    
    m_arrErrValue = [[NSMutableArray alloc]init];
    
    // post session
    postSession = [[GetPostSessionData alloc] init];
    postSession.delegate = self;
    
    //
    [la_title setText:VEHICLE_STATUS_NORMAL];
    [la_title setTextColor:[UIColor whiteColor]];
    [la_title setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE1]];
    
    //
    UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_seperateline02"]];
    headerImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f);
    m_tableview.tableHeaderView = headerImage;
    [m_tableview setSeparatorColor:[UIColor clearColor]];
    
    // 隐藏多余的分割线
    m_tableview.tableFooterView = [[UIView alloc]init];
    
    m_refrese = [DJRefresh refreshWithScrollView: m_tableview];
    m_refrese.delegate = self;
    m_refrese.topEnabled=YES;
    m_refrese.autoRefreshTop=YES;
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
    
    if ([self.UserInfo isRunDemo]) {
        [self.view addSubview: [ExtendStaticView MarkDemoView]];
    }
    
    m_ErrNotions = [[AlertViewForWarnDetail alloc]init];
    [self.view addSubview: m_ErrNotions];
    
    flagForKCWarning = NO;
}

- (void) viewDidAppear:(BOOL)animated {
}

- (void) refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if (flagForKCWarning == YES) return;
        
        if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GS"]) {
            [self sendPostSessionForFEWarn];
        }
        else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GL"]) {
            [self sendPostSessionForFEWarn];
        }
        else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博越"]) {
            [self sendPostSessionForWarn];
        }
        else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博瑞"]) {
            [self sendPostSessionForKCWarn];
        }
    });
}

- (void) sendPostSessionForWarn {
    NSString * url = [NSString stringWithFormat:@"%@/api/searchVhlStatus", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) sendPostSessionForKCWarn {
   
    flagForKCWarning = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * code = nil;
        NSString * url = [NSString stringWithFormat:@"%@/system/diagnosis/query", HTTP_GET_POST_ADDRESS_KC];
        
        // 15695863592 123456
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
        [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
        [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
        [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
        
        NSMutableDictionary * body = [[NSMutableDictionary alloc]init];
        [body setObject: dict forKey: @"ntspheader"];
        [body setObject: @"0" forKey:@"start"];
        [body setObject: @"1" forKey:@"rows"];
        
        NSDictionary * dictForResult = [self fetchPostSessionForKC:url Body:body];
        NSLog(@"** dict For Result - %@", dictForResult);
        code = [[dictForResult objectForKey:@"errcode"] stringValue];
        NSString * dateStr = [[dictForResult objectForKey:@"data"]objectForKey:@"diagnosis_time"];
        if (![code isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                flagForKCWarning = NO;
            });
        }
        
        url = [NSString stringWithFormat:@"%@/system/command/send", HTTP_GET_POST_ADDRESS_KC];
        [dict removeAllObjects];
        [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
        [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
        [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
        [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
        [body removeAllObjects];
        [body setObject:dict forKey:@"ntspheader"];
        [body setObject:@"" forKey:@"content"];
        [body setObject:@"1" forKey:@"isInstant"];
        [body setObject:@"DIAGNOSIS-ALL" forKey:@"type"];
        [body setObject: APP_VERSION_CODE forKey:@"version"];
        dictForResult = [self fetchPostSessionForKC:url Body:body];
        
        code = [[dictForResult objectForKey:@"errcode"] stringValue];
        if (![code isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                flagForKCWarning = NO;
            });
        }
        
        url = [NSString stringWithFormat:@"%@/system/diagnosis/query", HTTP_GET_POST_ADDRESS_KC];
        [dict removeAllObjects];
        [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
        [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
        [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
        [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
        [body removeAllObjects];
        [body setObject: dict forKey: @"ntspheader"];
        [body setObject: @"0" forKey:@"start"];
        [body setObject: @"1" forKey:@"rows"];

        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_VEHICLESTATUS];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
        
        while (sp > 0.0f) {
        
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            dictForResult = [self fetchPostSessionForKC:url Body:body];
            NSLog(@"** dict For diagnosis Result - \n%@", dictForResult);
            code = [[dictForResult objectForKey:@"errcode"] stringValue];
            
            NSString * str = [[dictForResult objectForKey:@"data"]objectForKey:@"diagnosis_time"];
            if (![dateStr isEqualToString:str]) break;
            
            // 暂停 2s
            [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
        }
        
        if (sp < 0.0f) { // Time out
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Vehicle Status Time Out ..");
                [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:NETWORK_TIMEOUT]];
                [alertview show];
                
                flagForKCWarning = NO;
            });
            return;
        }
        
        if (![code isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * str = [dictForResult objectForKey:@"errmsg"];
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:str];
                alertview.okBlock = ^(){
                    flagForKCWarning = NO;
                    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                };
                [alertview show];
            });
            return;
        }
        else {
            NSDictionary * data = [dictForResult objectForKey:@"data"];
            m_arrAllValue = [[NSMutableArray alloc]initWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", nil];
            [m_arrErrValue removeAllObjects];
            
            if ([[data objectForKey:@"acu_status"] isEqualToString:@"1"]) {
                [m_arrAllValue removeObject:@"01"];
                [m_arrErrValue addObject:@"01"];
            }
            
            if ([[data objectForKey:@"tpms_status"] isEqualToString:@"1"]) {
                [m_arrAllValue removeObject:@"02"];
                [m_arrErrValue addObject:@"02"];
            }
            
            if ([[data objectForKey:@"ems_status"] isEqualToString:@"1"]) {
                [m_arrAllValue removeObject:@"03"];
                [m_arrErrValue addObject:@"03"];
            }
            
            if ([[data objectForKey:@"eps_status"] isEqualToString:@"1"]) {
                [m_arrAllValue removeObject:@"04"];
                [m_arrErrValue addObject:@"04"];
            }
            
            if ([[data objectForKey:@"esp_status"] isEqualToString:@"1"]) {
                [m_arrAllValue removeObject:@"05"];
                [m_arrErrValue addObject:@"05"];
            }
            
            if ([[data objectForKey:@"pas_status"] isEqualToString:@"1"]) {
                [m_arrAllValue removeObject:@"06"];
                [m_arrErrValue addObject:@"06"];
            }
            
            if ([[data objectForKey:@"peps_status"] isEqualToString:@"1"]) {
                [m_arrAllValue removeObject:@"07"];
                [m_arrErrValue addObject:@"07"];
            }
            
            if ([[data objectForKey:@"acc_status"] isEqualToString:@"1"]) {
                [m_arrAllValue removeObject:@"08"];
                [m_arrErrValue addObject:@"08"];
            }
            
            if ([[data objectForKey:@"lde_status"] isEqualToString:@"1"]) {
                [m_arrAllValue removeObject:@"09"];
                [m_arrErrValue addObject:@"09"];
            }
            
            if ([[data objectForKey:@"tcu_status"] isEqualToString:@"1"]) {
                [m_arrAllValue removeObject:@"10"];
                [m_arrErrValue addObject:@"10"];
            }
            
            if ([[data objectForKey:@"bcm_light_status"] isEqualToString:@"1"]) {
                [m_arrAllValue removeObject:@"11"];
                [m_arrErrValue addObject:@"11"];
            }
            
            if ([m_arrErrValue count] > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [la_title setText: VEHICLE_STATUS_ERROR];
                    [iv_title setImage:[UIImage imageNamed:@"warn_allno"]];
                });
                
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [la_title setText: VEHICLE_STATUS_NORMAL];
                    [iv_title setImage:[UIImage imageNamed:@"warn_allright"]];
                });
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            flagForKCWarning = NO;
            [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];

            // 刷新列表
            [m_tableview reloadData];
        });
    });
}

- (void) sendPostSessionForFEWarn {
    flagForKCWarning = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * url = [NSString stringWithFormat:@"%@/api/searchVhlStatus", HTTP_GET_POST_ADDRESS];
        NSString * body = [NSString stringWithFormat:@"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];

        NSDictionary * dictForResult = [self fetchPostSession:url Body:body];
        NSLog(@"** dict For Result - %@", dictForResult);
        NSString * code = [[dictForResult objectForKey:@"status"] objectForKey:@"code"];

        if (![code isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton: [ExtendStaticFunctions getServerErrorMessage:code]];
                alertview.okBlock = ^(){
                    flagForKCWarning = NO;
                    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                };
                [alertview show];
            });
            return;
        }
        else {
            NSArray * alertList = [dictForResult objectForKey:@"alertList"];
            m_arrAllValue = [[NSMutableArray alloc]initWithObjects:@"01", @"03", @"04",  @"06", @"07", @"08", @"09", @"10", @"12", @"13", nil];
            [m_arrErrValue removeAllObjects];
            
            for (NSDictionary * tmp in alertList) {
                NSString * value = [tmp objectForKey:@"alertName"];
                if ([value isEqualToString:@"05"]) value = @"04";
                
                if (![m_arrAllValue containsObject:value]) continue;
                
                [m_arrAllValue removeObject: value];
                [m_arrErrValue addObject: value];
            }
            
            if ([m_arrErrValue count] > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [la_title setText: VEHICLE_STATUS_ERROR];
                    [iv_title setImage:[UIImage imageNamed:@"warn_allno"]];
                });
                
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [la_title setText: VEHICLE_STATUS_NORMAL];
                    [iv_title setImage:[UIImage imageNamed:@"warn_allright"]];
                });
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            flagForKCWarning = NO;
            [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
            
            // 刷新列表
            [m_tableview reloadData];
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
        
        [la_title setText: VEHICLE_STATUS_NETWORK_ERROR];
        [iv_title setImage:[UIImage imageNamed:@"warn_noget"]];
        return;
    }
    
    NSString * code = nil;
    NSDictionary * mdic = [postSession getDictionaryFromRequest];
    code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
    if ([[mdic allKeys] containsObject:@"alertList"] && [[mdic allKeys] containsObject:@"range"]) {
        if ([code isEqualToString:@"200"]) {
            NSArray * arrayRes = [mdic objectForKey:@"alertList"];
            m_arrAllValue = [[NSMutableArray alloc]initWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", nil];
            [m_arrErrValue removeAllObjects];
            
            for (NSDictionary * tmp in arrayRes) {
                [m_arrAllValue removeObject:[tmp objectForKey:@"alertName"]];
                [m_arrErrValue addObject:[tmp objectForKey:@"alertName"]];
            }
            
            // 刷新列表
            [m_tableview reloadData];
            
            if ([m_arrErrValue count] == 0) {
                [la_title setText: VEHICLE_STATUS_NORMAL];
                [iv_title setImage:[UIImage imageNamed:@"warn_allright"]];
            }
            else {
                [la_title setText: VEHICLE_STATUS_ERROR];
                [iv_title setImage:[UIImage imageNamed:@"warn_allno"]];
            }
        }
        else {
            [la_title setText: VEHICLE_STATUS_NETWORK_ERROR];
            [iv_title setImage:[UIImage imageNamed:@"warn_noget"]];
        }
    }

    if ([code isEqualToString:@"402"]) {
        [(MainNavigationController *)self.navigationController doLogoff:self.userfixstr];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyRunStatus Value:@"OTHERLINE"];
    }
    
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    NSInteger lines = 0;
    if (sectionIndex == 0) lines = [m_arrAllValue count] + [m_arrErrValue count];
    else if (sectionIndex == 1) lines = 1;
    else lines = 0;
    
    return lines;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) return 120.0f;
    else return 70.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) return 0.0f;
    else return 70.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * sectionHeaderView = [[UIView alloc]init];
    if (section == 0 || section == 1) {
        sectionHeaderView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 0.0f);
    }
    else {
        sectionHeaderView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 70.0f);
    }
    
    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * res = nil;
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"WarningTableViewCell";
        WarningTableViewCell *cell = (WarningTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        if ([m_arrErrValue count] > indexPath.row) {
            NSString * key = [m_arrErrValue objectAtIndex:indexPath.row];
            [cell setItemIconWithTitle:[m_dicWIcon objectForKey:key] Title:[m_dicTitle objectForKey:key]];
            [cell setItemStatus: WARNING_ERROR];
        }
        else {
            NSString * key = [m_arrAllValue objectAtIndex:(indexPath.row - [m_arrErrValue count])];
            [cell setItemIconWithTitle:[m_dicIcon objectForKey:key] Title:[m_dicTitle objectForKey:key]];
            [cell setItemStatus: WARNING_OK];
        }
        res = cell;
    }
    else if (indexPath.section == 1) {
        static NSString * cellIdentifier = @"AboutThisTableViewCell";
        AboutThisTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        }
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        res = cell;
    }
    
    [res setSelectionStyle:UITableViewCellSelectionStyleNone];
    return res;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 去除选中行的被选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1) {
        AboutFunctionViewController * view = [[AboutFunctionViewController alloc]init];
        [self.navigationController pushViewController:view animated:YES];
        return;
    }
    
    if ([self.UserInfo isKCUser] && ([m_arrErrValue count] > indexPath.row)) {
        NSString * key = [m_arrErrValue objectAtIndex:indexPath.row];
        NSString * value = [m_dicErrMsg objectForKey: key];
        [m_ErrNotions setTextShow: value];
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
