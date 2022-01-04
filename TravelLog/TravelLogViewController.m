//
//  TravelLogViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/1/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "TravelLogViewController.h"
#import "public.h"

#import "TravelLogTableViewCell.h"
#import "TravelLogDetailViewController.h"
#import "TravelLogRangeViewController.h"
#import "DataForDrivingLog.h"

@interface TravelLogViewController () <DJRefreshDelegate, PostSessionDataDelegate, UITableViewDelegate, UITableViewDataSource, didChooseRangeForTravelLog>

@end

@implementation TravelLogViewController {
    IBOutlet UILabel * la_startTime;
    IBOutlet UILabel * la_endTime;
    IBOutlet UITableView * m_tableview;
    IBOutlet UILabel * la_zhi;
    IBOutlet UIView * vi_title;
    
    GetPostSessionData * postSession;
    DJRefresh * m_refrese;
    
    BOOL m_isselected;
    NSString * m_staDateStr;
    NSString * m_endDtaeStr;
    
    NSArray * m_arrTitle;
    NSMutableDictionary * m_dicAllData;
    NSMutableDictionary * m_dicShowData;

    TravelLogDetailViewController * m_detailview;
    TravelLogRangeViewController * m_rangeview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_outline"] style:UIBarButtonItemStylePlain target:self action:@selector(checkLogs)];
    [rightItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationItem setTitle:@"行车日志"];
    
    [la_startTime setTextColor:[UIColor whiteColor]];
    [la_startTime setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE2]];
    
    [la_endTime setTextColor:[UIColor whiteColor]];
    [la_endTime setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE2]];
    [vi_title setHidden:YES];
    
    // 默认 7天 Title
    NSDateFormatter * formartter = [[NSDateFormatter alloc] init];
    NSDate * staDate = [NSDate date];
    [formartter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [formartter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    m_endDtaeStr = [[formartter stringFromDate:staDate] substringWithRange:NSMakeRange(0, 10)];
    m_staDateStr = [[formartter stringFromDate:[staDate dateByAddingTimeInterval: -518400.0f]] substringWithRange:NSMakeRange(0, 10)];
    [la_startTime setText: m_staDateStr];
    [la_endTime setText: m_endDtaeStr];
    m_isselected = NO;

    m_dicAllData = [[NSMutableDictionary alloc]init];
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
    
    // TableView Config
    UIView * tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f)];
    UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_seperateline02"]];
    headerImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f);
    [tableHeaderView addSubview: headerImage];
    m_tableview.tableHeaderView = tableHeaderView;
    [m_tableview setSeparatorStyle: UITableViewCellSeparatorStyleNone];

    m_refrese = [DJRefresh refreshWithScrollView: m_tableview];
    m_refrese.delegate = self;
    m_refrese.topEnabled=YES;
    m_refrese.autoRefreshTop=YES;
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
    
    m_isselected = NO;
    m_detailview = [[TravelLogDetailViewController alloc]init];
    m_rangeview = [[TravelLogRangeViewController alloc]init];
    m_rangeview.delegate = self;
    
    if ([self.UserInfo isRunDemo]) {
        [self.view addSubview: [ExtendStaticView MarkDemoView]];
    }
}

- (void) refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (m_isselected) {
            [self sendPostSessionFromDate: m_staDateStr endDate:m_endDtaeStr];
        }
        else {
            [self sendPostSessionFromDate: @"" endDate:@""];
        }
        
    });
}

- (void) sendPostSessionFromDate:(NSString *)fromDate endDate:(NSString *)endDate {
    NSLog(@"** Post Session From Date : %@ ~ %@", fromDate, endDate);
    
    NSString * url = [NSString stringWithFormat:@"%@/api/searchLogVhlDriving", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"%@&vin=%@&fromDate=%@&endDate=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin], fromDate, endDate];
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    if ([request isEqualToString:@"NSURLErrorNetworkConnectionLost"]) {
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
        [vi_title setHidden:YES];
        return;
    }
    
    if ([request isEqualToString:@"jk-Error"]) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:NETWORK_ERROR];
        [alertview show];
        
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
        [vi_title setHidden:YES];
        return;
    }
    
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
    
    NSString * code = nil;
    NSDictionary * mdic = [postSession getDictionaryFromRequest];
    code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
    if ([[mdic allKeys] containsObject:@"vhlDriving"] && [[mdic allKeys] containsObject:@"beginTime"]) {
        if ([code isEqualToString:@"200"]) {
            // remove old data
            [m_dicAllData removeAllObjects];
            
            // init data with DataForDrivingLog
            [m_detailview.arrayForAllDrivingLog removeAllObjects];
            NSArray * logArray = [mdic objectForKey:@"vhlDriving"];
            for (NSDictionary * one in logArray) {
                DataForDrivingLog * data = [[DataForDrivingLog alloc]init];
                data.startTime = [one objectForKey:@"startTime"];
                data.endTime = [one objectForKey:@"stopTime"];
                data.startPointLatitude = [[one objectForKey:@"startLocale"] objectForKey:@"lat"];
                data.startPointLongitude = [[one objectForKey:@"startLocale"] objectForKey:@"lon"];
                data.endPointLatitude = [[one objectForKey:@"endLocale"] objectForKey:@"lat"];
                data.endPointLongitude = [[one objectForKey:@"endLocale"] objectForKey:@"lon"];
                data.detailAway = [one objectForKey:@"singleMileage"];
                data.detailOil = [one objectForKey:@"singleConsumedAverage"];
                data.detailTime = [one objectForKey:@"singleDrivingTime"];
                
                [m_detailview.arrayForAllDrivingLog addObject:data];
            }
//            [m_detailview fixAllDrivingLogForName];
            
            // init data for dictionary
            for (DataForDrivingLog * one in m_detailview.arrayForAllDrivingLog) {
                NSString * date = [one.startTime substringWithRange:NSMakeRange(0, 10)];
                if ([[m_dicAllData allKeys] containsObject: date]) {
                    NSMutableArray * arr = [m_dicAllData objectForKey:date];
                    [arr addObject:one];
                    
                    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:NO];
                    [arr sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    [m_dicAllData setValue:arr forKey:date];
                }
                else {
                    NSMutableArray * arr = [[NSMutableArray alloc]init];
                    [arr addObject:one];
                    [m_dicAllData setValue:arr forKey:date];
                }
            }
            
            if ([m_detailview.arrayForAllDrivingLog count] == 0) [vi_title setHidden:YES];
            else [vi_title setHidden: NO];
            
            m_dicShowData = m_dicAllData;
            m_arrTitle = [m_dicShowData allKeys];
            NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
            m_arrTitle = [m_arrTitle sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
            
            NSLog(@"** title - %zd  arr - %zd", [m_arrTitle count], [m_dicShowData count]);
            
            if ([m_arrTitle count] == 0) {
                [m_dicAllData removeAllObjects];
                m_dicShowData = nil;
                m_arrTitle = nil;
            }
            // 刷新列表
            [m_tableview reloadData];
        }
        else {
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
            [alertview show];
        }
    }
    
    code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
    if ([code isEqualToString:@"402"]) {
        [(MainNavigationController *)self.navigationController doLogoff:self.userfixstr];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyRunStatus Value:@"OTHERLINE"];
    }
}

- (void) fixPointNameForArrayInDetail {
    // remove old data
    [m_dicAllData removeAllObjects];
    
    NSLog(@"fix over ..");
    for (DataForDrivingLog * one in m_detailview.arrayForAllDrivingLog) {
        NSString * date = [one.startTime substringWithRange:NSMakeRange(0, 10)];
        if ([[m_dicAllData allKeys] containsObject: date]) {
            NSMutableArray * arr = [m_dicAllData objectForKey:date];
            [arr addObject:one];
            [m_dicAllData setValue:arr forKey:date];
        }
        else {
            NSMutableArray * arr = [[NSMutableArray alloc]init];
            [arr addObject:one];
            [m_dicAllData setValue:arr forKey:date];
        }
    }
/*
    m_arrTitle = [[m_dicAllData allKeys] copy];
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    m_arrTitle = [m_arrTitle sortedArrayUsingDescriptors:@[sort]];
    m_dicShowData = m_dicAllData;
*/
    m_dicShowData = m_dicAllData;
    m_arrTitle = [m_dicShowData allKeys];
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    m_arrTitle = [m_arrTitle sortedArrayUsingDescriptors:@[sort]];
    
    NSLog(@"Title - %zd  arr - %zd", [m_arrTitle count], [m_dicShowData count]);
    
    if ([m_arrTitle count] == 0) {
        [m_dicAllData removeAllObjects];
        
        m_dicShowData = nil;
        m_arrTitle = nil;
    }
    // 刷新列表
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
    [m_tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) checkLogs {
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    m_endDtaeStr = [[formatter stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
    m_staDateStr = [[formatter stringFromDate:[[NSDate date] dateByAddingTimeInterval: -518400.0f]] substringWithRange:NSMakeRange(0, 10)];
    
    m_rangeview.startTime = [formatter dateFromString: [NSString stringWithFormat:@"%@ 00:00:00", m_staDateStr]];
    m_rangeview.endTime = [formatter dateFromString: [NSString stringWithFormat:@"%@ 23:59:59", m_endDtaeStr]];
    [self.navigationController pushViewController: m_rangeview animated:YES];
}

- (void) showRangeForTravelLogs:(NSString *)startTime EndTime:(NSString *)endTime {
    [m_dicAllData removeAllObjects];
    [m_dicShowData removeAllObjects];
    m_arrTitle = nil;
    [m_tableview reloadData];

    m_isselected = YES;
    m_staDateStr = [startTime substringWithRange:NSMakeRange(0, 10)];
    m_endDtaeStr = [endTime substringWithRange:NSMakeRange(0, 10)];
    [la_startTime setText:m_staDateStr];
    [la_endTime setText:m_endDtaeStr];
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];

//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self sendPostSessionFromDate:startTime endDate:endTime];
//    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([m_arrTitle count] == 0) return 1;
    else return [m_arrTitle count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    if ([m_arrTitle count] == 0) return 0;
    
    NSString * key = [m_arrTitle objectAtIndex:sectionIndex];
    NSMutableArray * objects = [m_dicShowData objectForKey:key];
    return [objects count];
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)atableView heightForHeaderInSection:(NSInteger)section {
    if ([m_arrTitle count] == 0) {
        return [UIScreen mainScreen].bounds.size.height - 120.0f;
    }
    else return 46.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    CGFloat ax = [UIScreen mainScreen].bounds.size.width;
    CGFloat hx = [UIScreen mainScreen].bounds.size.height;
    
    if ([m_arrTitle count] == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ax, hx - 120.0f)];
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 100.0f, ax - 16.0f, 40.0f)];
        [title setText: @"暂无行车记录"];
        [title setTextAlignment: NSTextAlignmentCenter];
        [title setTextColor: [UIColor colorWithHexString:@"7C8E9A"]];
        [title setFont: [UIFont fontWithName:FONT_MM size:24.0f]];
        [view addSubview:title];
    }
    else {
        view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ax, 46.0f)];
        
        UIImageView * bg0 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ax, 46.0f)];
        [bg0 setImage: [UIImage imageNamed:@"public_bg"]];
        UIImageView * bg = [[UIImageView alloc] initWithFrame:CGRectMake(ax/3 - 5.0f, 8.0f, ax/3 + 10.0f, 30.0f)];
        [bg setImage: [UIImage imageNamed:@"travellog_date2"]];
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(ax/3, 8.0f, ax/3, 30.0f)];
        [title setText:[m_arrTitle objectAtIndex:section]];
        [title setTextAlignment: NSTextAlignmentCenter];
        [title setTextColor: [UIColor colorWithHexString:WORD_COLOR_GLODEN]];
        [title setFont: [UIFont fontWithName:FONT_MM size:17.0f]];
        
        [view addSubview: bg0];
        [view addSubview: bg];
        [view addSubview: title];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TravelLogView";
    TravelLogTableViewCell *cell = (TravelLogTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TravelLogTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    NSString * key = [m_arrTitle objectAtIndex:indexPath.section];
    NSMutableArray * tmp = [m_dicShowData objectForKey:key];
//    DataArrayForOneDay * tmp = (DataArrayForOneDay *)[m_dicShowData objectForKey:key];
//    NSDictionary * currentCell = (NSDictionary *)[[tmp getCurrentArray] objectAtIndex:indexPath.row];
    NSLog(@"row - %ld", indexPath.row);
    NSInteger tt = indexPath.row;
    if (indexPath.row >= [tmp count]) tt = [tmp count] - 1;
    DataForDrivingLog * data = [tmp objectAtIndex: tt];
    
    NSString * tt1, * tt2;//, * tt3, * tt4;
    if (![data.startTime isEqualToString:@""] && data.startTime != nil) {
        tt1 = [data.startTime substringWithRange:NSMakeRange(11, 5)];
    }
    else tt1 = @"";
    
    if (![data.endTime isEqualToString:@""] && data.endTime != nil) {
        tt2 = [data.endTime substringWithRange:NSMakeRange(11, 5)];
    }
    else tt2 = @"";
    
    NSInteger count = [tmp count] - indexPath.row;
    [cell setItemCount:[NSString stringWithFormat:@"行程 %zd", count]];
    [cell setTime:tt1 endtime:tt2];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * key = [m_arrTitle objectAtIndex:indexPath.section];
    NSMutableArray * tmp = [m_dicShowData objectForKey:key];
    DataForDrivingLog * data = [tmp objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:m_detailview animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_detailview setValueForDetail:data];
        [m_detailview setValueForPoint:data];
    });
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
