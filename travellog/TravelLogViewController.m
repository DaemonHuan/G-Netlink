//
//  TravelLogViewController.m
//  G-Netlink-beta0.2
//
//  Created by jk on 10/30/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "TravelLogViewController.h"
#import "MainNavigationController.h"
#import "public.h"
#import "GNLUserInfo.h"
#import "jkAlertController.h"

#import "TravelLogTableViewCell.h"
#import "DateSelectorView.h"
#import "DataArrayForOneDay.h"

#import "GetPostSessionData.h"
#import "DJRefresh.h"

#import "TravelLogDetailViewController.h"

@interface TravelLogViewController () <PostSessionDataDelegate, DJRefreshDelegate, UIGestureRecognizerDelegate> {
    DateSelectorView * dsView;

    
    GetPostSessionData * postSession;
    DJRefresh * m_refrese;
    
    IBOutlet UIView * vi_popView;
    IBOutlet UIButton * bt_popOK;
    IBOutlet UIButton * bt_popReset;
    IBOutlet UIButton * bt_startDate;
    IBOutlet UIButton * bt_overDate;
    
    IBOutlet UIDatePicker * dp_datepicker;
    IBOutlet UIView * vi_dp;
    
    NSInteger m_isnotStart;
    
    NSString * m_starttime;
    NSString * m_overtime;
    
    NSArray * m_arrTitle;
    NSInteger m_rowcout;
    NSMutableDictionary * m_dicdata;
    NSMutableDictionary * m_dictoshow;
    
    BOOL m_isselected;
    TravelLogDetailViewController * m_detailview;
}

@end

@implementation TravelLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];

    self.navigationItem.title = @"行车日志";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_menuicon"] style: UIBarButtonItemStylePlain target:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 向右滑动显示菜单
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    recognizer.delegate = self;
    [[self view] addGestureRecognizer:recognizer];

    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"travellog_date1"] style:UIBarButtonItemStylePlain target:self action:@selector(chooseDate)];
    [rightitem setTintColor: [UIColor lightGrayColor]];
    self.navigationItem.rightBarButtonItem = rightitem;

    UIView * tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f)];
    UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_seperateline02"]];
    headerImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f);
    [tableHeaderView addSubview: headerImage];
    self.tableView.tableHeaderView = tableHeaderView;
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    
    m_detailview = [[TravelLogDetailViewController alloc]init];

    //
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
    
    m_arrTitle = [[NSArray alloc] init];
    m_dicdata = [[NSMutableDictionary alloc] init];
//    m_dictoshow = [[NSMutableDictionary alloc] init];
    m_rowcout = 0;
    m_isnotStart = 0;
    
    CGFloat wx = [UIScreen mainScreen].bounds.size.width;
    CGFloat hx = [UIScreen mainScreen].bounds.size.height;
    [vi_popView setFrame:CGRectMake(0.0f, 0.0f, wx, hx)];
    [vi_popView setHidden:YES];
    [vi_dp setHidden:YES];
    [self.view addSubview: vi_popView];
    
    [bt_startDate setTitle:@"" forState:UIControlStateNormal];
    [bt_startDate.titleLabel setFont:[UIFont fontWithName:FONT_XI size:18.0f]];
    [bt_overDate setTitle:@"" forState:UIControlStateNormal];
    [bt_overDate.titleLabel setFont: [UIFont fontWithName:FONT_XI size:18.0f]];
    
    [dp_datepicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];

    //
    m_refrese = [DJRefresh refreshWithScrollView: self.tableView];
    m_refrese.delegate = self;
    m_refrese.topEnabled=YES;
    m_refrese.autoRefreshTop=YES;
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
    
    if ([GNLUserInfo isDemo]) {
        [self.view addSubview: [ServicesPro loadMarkDemoView]];
    }
    
    m_isselected = NO;
}

- (void) refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (!m_isselected) {
            [self sendPostSession];
        }
        
        m_isselected = NO;

    });
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

-(void) viewDidAppear:(BOOL)animated {
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) viewDidDisappear:(BOOL)animated {
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) sendPostSession {
    NSString * url = [NSString stringWithFormat:@"%@/api/searchLogVhlDriving", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&vin=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo defaultCarVin], [GNLUserInfo isDemo] ? @"true" : @"false"];
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    NSLog(@"Request - %@", request);
    if (request == nil) return;
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
        return;
    }
    
    NSDictionary *jsonDic = [postSession getDictionaryFromRequest];
    NSArray * logArray = [jsonDic objectForKey:@"vhlDriving"];
    if ([[[jsonDic objectForKey:@"status"] objectForKey:@"code"] isEqualToString: @"402"]) {
        MainNavigationController * ctl = (MainNavigationController *) self.navigationController;
        [ctl turntoLoginForOut];
        return;
    }
    
    [m_dicdata removeAllObjects];
    [m_dictoshow removeAllObjects];
    
    if ([logArray count] > 0) {
        m_rowcout = [logArray count];
//        m_arrTitle = [[NSArray alloc] init];

        /*
        m_starttime = [NSString stringWithString:[jsonDic objectForKey:@"beginTime"]];
        m_starttime = [[self toLocalTime:m_starttime] substringWithRange:NSMakeRange(0, 10)];
        m_overtime = [NSString stringWithString:[jsonDic objectForKey:@"endTime"]];
        m_overtime = [[self toLocalTime:m_overtime] substringWithRange:NSMakeRange(0, 10)];  */
        m_starttime = [[NSString stringWithString:[jsonDic objectForKey:@"beginTime"]] substringWithRange:NSMakeRange(0, 10)];
        m_overtime = [[NSString stringWithString:[jsonDic objectForKey:@"endTime"]] substringWithRange:NSMakeRange(0, 10)];
        NSLog(@"-- %@ %@", m_starttime, m_overtime);
    }
    
    for (NSDictionary * one in logArray) {
//        NSString * str = [self toLocalTime:[one objectForKey:@"startTime"]];
//        NSLog(@"** %@ ^^ %@", [str substringWithRange:NSMakeRange(0, 10)], [str substringWithRange:NSMakeRange(11, 8)]);
        NSString * str = [one objectForKey:@"startTime"];
        NSString * date = [str substringWithRange:NSMakeRange(0, 10)];
        
       if ([[m_dicdata allKeys] containsObject:date]) {
            DataArrayForOneDay * oneday = (DataArrayForOneDay *)[m_dicdata objectForKey:date];
            [oneday addArrayObject: one];
            [m_dicdata setValue:oneday forKey:date];
        }
        else {
            DataArrayForOneDay * oneday = [[DataArrayForOneDay alloc]init];
            [oneday addArrayObject: one];
            [m_dicdata setValue:oneday forKey:date];
        }
    }
    
    m_arrTitle = [[m_dicdata allKeys] copy];
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    m_arrTitle = [m_arrTitle sortedArrayUsingDescriptors:@[sort]];
    
    m_dictoshow = m_dicdata;
    
    [self.tableView reloadData];
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (NSString *) toLocalTime:(NSString *) stime {
    NSTimeZone* gtm = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSTimeZone* local = [NSTimeZone localTimeZone];
    
    NSDateFormatter * dateformat = [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateformat setTimeZone: gtm];
    
    NSDate * date = [dateformat dateFromString:stime];
//    NSLog(@"** %@", date);
    if (date.description == nil) return nil;
    
    NSInteger interval = [local secondsFromGMTForDate: date];
    NSDate * localdate = [date dateByAddingTimeInterval: interval];
    return localdate.description;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([m_arrTitle count] == 0) {
        return 1;
    }
    else return [m_arrTitle count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    if ([m_arrTitle count] == 0) return 0;
    
    NSString * key = [m_arrTitle objectAtIndex:sectionIndex];
    DataArrayForOneDay * res = (DataArrayForOneDay *)[m_dictoshow objectForKey:key];
    return [[res getCurrentArray] count];
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}

- (CGFloat)tableView:(UITableView *)atableView heightForHeaderInSection:(NSInteger)section {
    if ([m_arrTitle count] == 0) {
        return [UIScreen mainScreen].bounds.size.height - 120.0f;
    }
    else return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    
    if ([m_arrTitle count] == 0) {
        CGFloat ax = [UIScreen mainScreen].bounds.size.width;
        CGFloat hx = [UIScreen mainScreen].bounds.size.height;
        view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, hx - 120.0f)];
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 100.0f, ax - 16.0f, 40.0f)];
        [title setText: @"暂无行车记录"];
        [title setTextAlignment: NSTextAlignmentCenter];
        [title setTextColor: [UIColor colorWithHexString:@"7C8E9A"]];
        [title setFont: [UIFont fontWithName:FONT_MM size:24.0f]];
        [view addSubview:title];
    }
    else {
        view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 60.0f)];
        CGFloat ax = [UIScreen mainScreen].bounds.size.width;
        
        UIImageView * bg = [[UIImageView alloc] initWithFrame:CGRectMake(ax/3 - 5.0f, 15.0f, ax/3 + 10.0f, 30.0f)];
        [bg setImage: [UIImage imageNamed:@"travellog_date2"]];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(ax/3, 15.0f, ax/3, 30.0f)];
        [title setText:[m_arrTitle objectAtIndex:section]];
        [title setTextAlignment: NSTextAlignmentCenter];
        [title setTextColor: [UIColor colorWithHexString:WordColor]];
        [title setFont: [UIFont fontWithName:FONT_MM size:17.0f]];
        
        [view addSubview: bg];
        [view addSubview: title];
    }

    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TravelLogView";
//    NSLog(@"%ld %ld", indexPath.section, indexPath.row);
    TravelLogTableViewCell *cell = (TravelLogTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TravelLogTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    NSString * key = [m_arrTitle objectAtIndex:indexPath.section];
    DataArrayForOneDay * tmp = (DataArrayForOneDay *)[m_dictoshow objectForKey:key];
    NSDictionary * currentCell = (NSDictionary *)[[tmp getCurrentArray] objectAtIndex:indexPath.row];
/*
    NSString * tt1 = [[self toLocalTime:[currentCell objectForKey:@"startTime"]] substringWithRange:NSMakeRange(11, 5)];
    NSString * tt2 = [[self toLocalTime:[currentCell objectForKey:@"stopTime"]] substringWithRange:NSMakeRange(11, 5)];  */

    NSString * tt1, *tt2, *tt3, *tt4;
    if ([[currentCell allKeys]containsObject:@"startTime"]) {
        tt1 = [[currentCell objectForKey:@"startTime"] substringWithRange:NSMakeRange(11, 5)];
    }
    else tt1 = @"";
    
    if ([[currentCell allKeys]containsObject:@"stopTime"]) {
        tt2 = [[currentCell objectForKey:@"stopTime"] substringWithRange:NSMakeRange(11, 5)];
    }
    else tt2 = @"";

    if ([[currentCell allKeys]containsObject:@"singleMileage"]) {
        tt3 = currentCell[@"singleMileage"];
    }
    else tt3 = @"0";
    
    if ([[currentCell allKeys]containsObject:@"singleConsumedAverage"]) {
        tt4 = currentCell[@"singleConsumedAverage"];
    }
    else tt4 = @"0";

    [cell setTime:tt1 endtime:tt2];
    [cell setMessage:tt3 oilconsume:tt4];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.navigationController pushViewController:m_detailview animated:YES];
}

- (IBAction) popOK:(id)sender {

    NSLog(@"start to check out ..");
    if ([bt_overDate.titleLabel.text isEqualToString:@""] || bt_overDate.titleLabel.text == nil || [bt_startDate.titleLabel.text isEqualToString:@""] || bt_startDate.titleLabel.text == nil) {
        jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"时间区间选择错误，请重新选择。"];
        [view show];
        return;
    }
    NSLog(@"%@ %@", bt_startDate.titleLabel.text, bt_overDate.titleLabel.text);

    // 借助UTC时间 判断开始时间与结束时间的大小 最后将时间转化为字符串
    NSDateFormatter * formartter = [[NSDateFormatter alloc] init];
    [formartter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [formartter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate * staDate = [formartter dateFromString: [NSString stringWithFormat:@"%@ 00:00:00", bt_startDate.titleLabel.text]];
    NSDate * endDate = [formartter dateFromString: [NSString stringWithFormat:@"%@ 23:59:59", bt_overDate.titleLabel.text]];
    
//    NSLog(@"%lf",[endDate timeIntervalSinceDate:staDate]);
    
    [vi_dp setHidden:YES];
    [vi_popView setHidden:YES];
    
    NSTimeInterval secondsInterval = [endDate timeIntervalSinceDate:staDate]
    ;
    //
    if (secondsInterval < 0.0f) {
        jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"时间区间选择错误，请重新选择。"];
        [view show];
        return;
    }
    
    // 时间范围小于 30 天
    if (secondsInterval / 86400.0f > 30.0f) {
        jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"选择时间区间超过 30 天，\n请重新选择。"];
        [view show];
        return;
    }
    
    
    NSString * url = [NSString stringWithFormat:@"%@/api/searchLogVhlDriving", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&vin=%@&fromDate=%@&endDate=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo defaultCarVin], [[staDate description]substringWithRange:NSMakeRange(0, 19)], [[endDate description]substringWithRange:NSMakeRange(0, 19)], [GNLUserInfo isDemo] ? @"true" : @"false"];
    [postSession SendPostSessionRequest:url Body:body];

//    m_isselected = YES;
//    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
    

    // reset table data
//    m_dictoshow = nil;
//    m_dictoshow = [[NSMutableDictionary alloc]init];
//    for (NSString * key in [m_dicdata allKeys]) {
//        NSDate * date = [formartter dateFromString:key];
//        NSLog(@"%@ %lf %lf", key, [date timeIntervalSinceDate:staDate],[date timeIntervalSinceDate:endDate]);
//        
//        if ([date timeIntervalSinceDate:staDate] >= 0 && [date timeIntervalSinceDate:endDate] <= 0 ) {
//            [m_dictoshow setObject:(DataArrayForOneDay *)[m_dicdata objectForKey:key] forKey:key];
//        }
//    }
//    
//    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
//    m_arrTitle = [[NSArray alloc]initWithArray: [m_dictoshow allKeys]];
//    m_arrTitle = [m_arrTitle sortedArrayUsingDescriptors:@[sort]];
//    [self.tableView reloadData];
}

- (IBAction) popCancel:(id)sender {
    [bt_startDate setTitle:m_starttime forState:UIControlStateNormal];
    [bt_overDate setTitle: m_overtime forState:UIControlStateNormal];
}

- (IBAction) touchdownStartTimeEdit:(id)sender {
    m_isnotStart = 1;
    [vi_dp setHidden: NO];
    
    NSDateFormatter * formartter = [[NSDateFormatter alloc] init];
    [formartter setDateFormat:@"yyyy-MM-dd"];
    if ([bt_startDate.titleLabel.text isEqualToString:@""] || bt_startDate.titleLabel.text == nil) {
        [dp_datepicker setDate:[NSDate date]];
    }
    else {
        [dp_datepicker setDate:[formartter dateFromString:bt_startDate.titleLabel.text]];
    }
}

- (IBAction) touchdownOverTimeEdit:(id)sender {
    m_isnotStart = 2;
    [vi_dp setHidden: NO];
    
    NSDateFormatter * formartter = [[NSDateFormatter alloc] init];
    [formartter setDateFormat:@"yyyy-MM-dd"];
    
    if ([bt_overDate.titleLabel.text isEqualToString:@""] || bt_overDate.titleLabel.text == nil) {
        [dp_datepicker setDate:[NSDate date]];
    }
    else {
        [dp_datepicker setDate:[formartter dateFromString:bt_overDate.titleLabel.text]];
    }
}

- (IBAction) hiddenDatepicker:(id)sender {
    if (vi_dp.isHidden) {
        [vi_popView setHidden:YES];
    }
    else {
        [vi_dp setHidden: YES];
    }
}

- (IBAction) exchangeDP:(id)sender {
    NSDateFormatter * formartter = [[NSDateFormatter alloc]init];
    [formartter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"%@", [formartter stringFromDate:[dp_datepicker date]]);
    NSString * res = [formartter stringFromDate:[dp_datepicker date]];
    
    if (m_isnotStart == 1) {
        [bt_startDate setTitle:res forState:UIControlStateNormal];
    }
    else if (m_isnotStart == 2) {
        [bt_overDate setTitle:res forState:UIControlStateNormal];
    }
}

- (void) chooseDate {
    [vi_popView setHidden:NO];
    
    [bt_startDate setTitle:m_starttime forState:UIControlStateNormal];
    [bt_overDate setTitle: m_overtime forState:UIControlStateNormal];

    NSDateFormatter * formartter = [[NSDateFormatter alloc] init];
    [formartter setDateFormat:@"yyyy-MM-dd"];
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
