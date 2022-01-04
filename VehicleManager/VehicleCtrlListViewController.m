//
//  VehicleCtrlListViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 5/13/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "VehicleCtrlListViewController.h"
#import "public.h"

#import "VehicleHistoryForKC.h"
#import "VehicleCtrlTableViewCell.h"
#import "VehicleCtrlDetailViewController.h"


@interface VehicleCtrlListViewController () <PostSessionDataDelegate, DJRefreshDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation VehicleCtrlListViewController {
    GetPostSessionData * postSession;
    
    DJRefresh * m_refrese;
    IBOutlet UITableView * m_tableview;
    IBOutlet UIView * vi_datepicker;
    IBOutlet UIDatePicker * dp_selector;
    
    NSInteger m_rowsCount;
    NSString * m_currentDate;
    BOOL m_isselected;
    BOOL m_isRefresed;
    
    NSMutableDictionary * m_data;
    NSMutableArray * m_sectionList;
    NSDictionary * m_cmdTypes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"控制历史"];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_outline"] style:UIBarButtonItemStylePlain target:self action:@selector(doChooseDateForSelect:)];
    [rightItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    dp_selector.datePickerMode = UIDatePickerModeDate;
    [dp_selector setBackgroundColor:[UIColor clearColor]];
    [dp_selector setValue:[UIColor whiteColor] forKey:@"textColor"];

    [dp_selector setTintColor:[UIColor whiteColor]];
    [dp_selector setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [dp_selector setEnabled: YES];
    [vi_datepicker setHidden: YES];
    
    SEL selector = NSSelectorFromString(@"setHighlightsToday:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:dp_selector];

    
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
    
    m_data = [[NSMutableDictionary alloc]init];
    m_sectionList = [[NSMutableArray alloc]init];
    m_cmdTypes = @{@"RP-LOCAL":@"重新上报位置信息", @"CLOSE-DOOR":@"关闭车门",
                   @"OPEN-DOOR":@"开启车门", @"RP-VEH-CON":@"重新上报车况",
                   @"DIAGNOSIS-ALL":@"通知远程诊断", @"OPEN-WINDOW":@"通知远程解锁车窗",
                   @"CLOSE-WINDOW":@"关闭车窗", @"OPEN-AIR-CONDITIONING":@"远程开启空调",
                   @"CLOSE-AIR-CONDITIONING":@"远程关闭空调", @"OPEN-DORMER":@"远程打开天窗",
                   @"CLOSE-DORMER":@"远程关闭天窗", @"OPEN-TRUNK":@"远程打开后备箱", @"CLOSE-TRUNK":@"远程关闭后备箱", @"SEEK-CAR":@"双闪鸣笛"
                   };
    // @"CLOSE-WINDOW":@"通知远程锁定车窗"
    UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_seperateline02"]];
    headerImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f);
    m_tableview.tableHeaderView = headerImage;
    m_tableview.tableFooterView = [[UIView alloc]init];
    m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_refrese = [DJRefresh refreshWithScrollView: m_tableview];
    m_refrese.delegate = self;
    m_refrese.topEnabled = YES;
    m_refrese.bottomEnabled = YES;
//    m_refrese.autoRefreshTop = YES;
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
    
    m_rowsCount = 0;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate * date = [NSDate date];
    m_currentDate = [formatter stringFromDate: date];
    [dp_selector setDate:date];
    [dp_selector setMaximumDate:date];
    m_isselected = NO;
    m_isRefresed = NO;
}

- (void) refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"** ** Return %d ** **", m_isRefresed);
        if (m_isRefresed == YES) {
            NSLog(@"** ** Return ** **");
            return;
        }
        
//        [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
        
        if (direction == DJRefreshDirectionBottom) m_rowsCount += 10;
        else{
            [m_data removeAllObjects];
            m_rowsCount = 0;
        }

        if (!m_isselected) {
            [self sendPostSessionForRows: m_rowsCount fromDate: @""];
        }
        else {
            [self sendPostSessionForRows: m_rowsCount fromDate: m_currentDate];
        }
        
    });
}

- (IBAction) doChooseDateForSelect:(id)sender {
    [vi_datepicker setHidden: NO];
}

- (IBAction) doCheckDate:(id)sender {
    [vi_datepicker setHidden: YES];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    
    NSLog(@"%@ %@", dp_selector.date, [formatter stringFromDate:dp_selector.date]);
    
    m_rowsCount = 0;
    [m_data removeAllObjects];
    [m_tableview reloadData];
    m_isselected = YES;
//    [self sendPostSessionForRows: m_rowsCount fromDate: [formatter stringFromDate:dp_selector.date]];
    
    m_currentDate = [formatter stringFromDate:dp_selector.date];
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) sendPostSessionForRows:(NSInteger) rows fromDate:(NSString *)date {
    m_isRefresed = YES;
    
    NSString * url = [NSString stringWithFormat:@"%@/system/command/query11", HTTP_GET_POST_ADDRESS_KC];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
    [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
    [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
    [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
    NSMutableDictionary * body = [[NSMutableDictionary alloc]init];
    [body setObject: dict forKey: @"ntspheader"];
    [body setObject: [NSString stringWithFormat:@"%zd", rows] forKey:@"start"];
    [body setObject: @"10" forKey:@"rows"];
    
    if (![date isEqualToString:@""]) [body setObject: date forKey:@"send_time"];

    [postSession SendPostSessionRequestForKC:url Body: body];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) didPostSessionRequest:(NSString *)request {
    
    if ([request isEqualToString:@"NSURLErrorNetworkConnectionLost"]) {
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
        m_isRefresed = NO;
        return;
    }
    
    if ([request isEqualToString:@"jk-Error"]) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:NETWORK_ERROR];
        [alertview show];
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
        m_isRefresed = NO;
        return;
    }
    
    NSString * code = nil;
    NSDictionary * mdic = [postSession getDictionaryFromRequest];
    
    if ([mdic count] == 3 && [[mdic allKeys] containsObject:@"data"]) {
        code = [[mdic objectForKey:@"errcode"] stringValue];
        NSArray * tmplist = [[mdic objectForKey:@"data"]objectForKey:@"cmd_list"];

        for (NSDictionary * dict in tmplist) {
            VehicleHistoryForKC * one = [[VehicleHistoryForKC alloc]init];
            one.time = [dict objectForKey:@"send_time"];
            one.command = [dict objectForKey:@"command"];
            one.send_status = [[dict objectForKey:@"send_state"]stringValue];
            one.exec_status = [[dict objectForKey:@"execute_state"]stringValue];
            one.exec_desc = [dict objectForKey:@"execute_desc"];

            NSString * sectiontitle = [[dict objectForKey:@"send_time"]substringWithRange:NSMakeRange(0, 10)];
            NSArray * list = [m_data allKeys];
            if ([list containsObject:sectiontitle]) {
                NSMutableArray * list = [m_data objectForKey:sectiontitle];
                [list addObject: one];
                [m_data setObject:list forKey:sectiontitle];
            }
            else {
                NSMutableArray * list = [[NSMutableArray alloc]init];
                [list addObject: one];
                [m_data setObject: list forKey:sectiontitle];
            }
        }
        
        [m_tableview reloadData];
    }
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        m_isRefresed = NO;
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray * list = [m_data allKeys];

    return [list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    NSArray * list = [m_data allKeys];
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    list = [list sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];

    NSString * key = [list objectAtIndex: sectionIndex];
    NSArray * data = [m_data objectForKey:key];
    return [data count];
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"VehicleCtrlTableViewCell";
    VehicleCtrlTableViewCell * cell = (VehicleCtrlTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray * list = [m_data allKeys];

    NSLog(@"** %zd %zd", indexPath.row, [list count]);
    if ([list count] == 0) return cell;
    
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    list = [list sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSString * key = [list objectAtIndex: indexPath.section];
    NSArray * data = [m_data objectForKey: key];
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
    data = [data sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    VehicleHistoryForKC * one = [data objectAtIndex: indexPath.row];
    [cell setItemValue:one.time Title: [m_cmdTypes objectForKey:one.command]];
    [cell setItemStatus:([one.exec_status isEqualToString:@"1"])];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)atableView heightForHeaderInSection:(NSInteger)section {
    return 46.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat ax = [UIScreen mainScreen].bounds.size.width;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ax, 46.0f)];
    UIImageView * bg0 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ax, 46.0f)];
    [bg0 setImage: [UIImage imageNamed:@"public_bg"]];
    UIImageView * bg = [[UIImageView alloc] initWithFrame:CGRectMake(ax/3 - 5.0f, 8.0f, ax/3 + 10.0f, 30.0f)];
    [bg setImage: [UIImage imageNamed:@"travellog_date2"]];
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(ax/3, 8.0f, ax/3, 30.0f)];
    
    NSArray * list = [m_data allKeys];
    if ([list count] == 0) return view;
    
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    list = [list sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSString * key = [list objectAtIndex: section];
    
    [title setText: key];
    [title setTextAlignment: NSTextAlignmentCenter];
    [title setTextColor: [UIColor colorWithHexString:WORD_COLOR_GLODEN]];
    [title setFont: [UIFont fontWithName:FONT_MM size:17.0f]];
    
    [view addSubview: bg0];
    [view addSubview: bg];
    [view addSubview: title];
    
    return view;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray * list = [m_data allKeys];
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    list = [list sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSString * key = [list objectAtIndex: indexPath.section];
    NSArray * data = [m_data objectForKey: key];
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
    data = [data sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    VehicleHistoryForKC * one = [data objectAtIndex: indexPath.row];
    
    VehicleCtrlDetailViewController * view = [[VehicleCtrlDetailViewController alloc]init];
    view.exec = [m_cmdTypes objectForKey:one.command];
    view.time = one.time;
    view.result = ([one.exec_status isEqualToString:@"1"] ? @"成功" : @"失败");
    view.detail = one.exec_desc;
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
