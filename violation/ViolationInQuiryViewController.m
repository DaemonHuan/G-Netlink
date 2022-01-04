//
//  ViolationInQuiryViewController.m
//  G-Netlink-beta0.2
//
//  Created by jk on 11/20/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "ViolationInQuiryViewController.h"
#import "GNLUserInfo.h"
#import "public.h"
#import "GetPostSessionData.h"
#import "DJRefresh.h"
#import "jkAlertController.h"

#import "MainNavigationController.h"
#import "violationTableViewCell.h"

@interface ViolationInQuiryViewController () <UITableViewDataSource, UITableViewDelegate, PostSessionDataDelegate, DJRefreshDelegate, UIGestureRecognizerDelegate> {
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
    
    IBOutlet UITableView * mainTableView;
    IBOutlet UILabel * lb_carlisence;
    NSMutableDictionary * m_arrayTiao;
    NSArray * m_arrtoshow;
    
    GetPostSessionData * postSession;
    DJRefresh * m_refrese;
}

@end

@implementation ViolationInQuiryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    
    self.navigationItem.title = @"违章查询";
    //
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"travellog_date1"] style:UIBarButtonItemStylePlain target:self action:@selector(chooseDate)];
    [rightitem setTintColor: [UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_menuicon"] style: UIBarButtonItemStylePlain target:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 向右滑动显示菜单
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    recognizer.delegate = self;
    [[self view] addGestureRecognizer:recognizer];
    
    [lb_carlisence setText: [GNLUserInfo defaultCarLisence]];
    
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
    
    m_arrtoshow = [[NSArray alloc]init];
    m_arrayTiao = [[NSMutableDictionary alloc]init];
    
    CGFloat wx = [UIScreen mainScreen].bounds.size.width;
    CGFloat hx = [UIScreen mainScreen].bounds.size.height;
    [vi_popView setFrame:CGRectMake(0.0f, 0.0f, wx, hx)];
    [vi_popView setHidden:YES];
    [vi_dp setHidden:YES];
    [self.view addSubview: vi_popView];
    
    [dp_datepicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    // 将tableview 的背景颜色和cell的背景颜色都致为透明
    mainTableView.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
    UIView * tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f)];
    UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_seperateline02"]];
    headerImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f);
    [tableHeaderView addSubview: headerImage];
    mainTableView.tableHeaderView = tableHeaderView;
    mainTableView.allowsSelection = NO;
    
    //
    m_refrese = [DJRefresh refreshWithScrollView: mainTableView];
    m_refrese.delegate = self;
    m_refrese.topEnabled=YES;
    m_refrese.autoRefreshTop=YES;
//    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
    //
    if ([GNLUserInfo isDemo]) {
        [self.view addSubview: [ServicesPro loadMarkDemoView]];
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void) refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreseData];
    });
}

-(void) viewDidAppear:(BOOL)animated {
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) viewDidDisappear:(BOOL)animated {
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// config tableview
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([m_arrtoshow count] == 0) {
//        return 1;
//    }
//    else return 1;
//}

- (CGFloat)tableView:(UITableView *)atableView heightForHeaderInSection:(NSInteger)section {
    if ([m_arrtoshow count] == 0) {
        return [UIScreen mainScreen].bounds.size.height - 120.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    
    CGFloat ax = [UIScreen mainScreen].bounds.size.width;
    CGFloat hx = [UIScreen mainScreen].bounds.size.height;
    view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, hx - 120.0f)];
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 100.0f, ax - 16.0f, 40.0f)];
    [title setText: @"暂无违章记录"];
    [title setTextAlignment: NSTextAlignmentCenter];
    [title setTextColor: [UIColor colorWithHexString:@"7C8E9A"]];
    [title setFont: [UIFont fontWithName:FONT_MM size:24.0f]];
    [view addSubview:title];
    
    return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [m_arrtoshow count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"violationTableViewCell";
    
    violationTableViewCell *cell = (violationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //
    if (cell == nil) {
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSDictionary * dic = [m_arrayTiao objectForKey:[m_arrtoshow objectAtIndex:indexPath.row]];
    
    [cell setCellDetail:[dic objectForKey:@"address"] Detail:[dic objectForKey:@"detail"]];
    [cell setCellValue:[dic objectForKey:@"date"] Value: [dic objectForKey:@"point"] Pay: [dic objectForKey:@"money"]];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    return cell;
}

// post Session
- (void) refreseData {
    NSString * url = [NSString stringWithFormat:@"%@/api/getNewViolationinQuiry", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&vin=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo defaultCarVin], [GNLUserInfo isDemo] ? @"true" : @"false"];
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    NSLog(@"violations .. %@", request);
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
    
    [m_arrayTiao removeAllObjects];
    NSDictionary * dic = [postSession getDictionaryFromRequest];
    if ([[[dic objectForKey:@"status"] objectForKey:@"code"] isEqualToString: @"402"]) {
        MainNavigationController * ctl = (MainNavigationController *) self.navigationController;
        [ctl turntoLoginForOut];
        return;
    }
    
    NSArray * violations = [[postSession getDictionaryFromRequest] objectForKey:@"violations"];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    for (NSDictionary * tmp in violations) {
        NSDate * date = [[NSDate alloc] initWithTimeIntervalSince1970:[[tmp objectForKey:@"date"] doubleValue]];
        
        NSString * strtime = [formatter stringFromDate:date];
        NSLog(@"%@ %@", date, strtime);
        
        [m_arrayTiao setObject:tmp forKey:[strtime substringWithRange:NSMakeRange(0, 10)]];
    }

    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    m_arrtoshow = [m_arrayTiao allKeys];
    m_arrtoshow = [m_arrtoshow sortedArrayUsingDescriptors:@[sort]];
    if ([m_arrtoshow count] > 0) {
        m_starttime = [[NSString alloc]initWithString:[m_arrtoshow lastObject]];
        m_overtime = [[NSString alloc]initWithString:[m_arrtoshow firstObject]];
    }

    NSLog(@"all data: %@", m_arrayTiao);
    
    [mainTableView reloadData];
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (NSString *) toLocalTime:(NSString *) stime {
    NSTimeZone* gtm = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSTimeZone* local = [NSTimeZone localTimeZone];
    
    NSDateFormatter * dateformat = [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [dateformat setTimeZone: gtm];
    
    NSDate * date = [dateformat dateFromString:stime];
    //    NSLog(@"** %@", date);
    if (date.description == nil) return nil;
    
    NSInteger interval = [local secondsFromGMTForDate: date];
    NSDate * localdate = [date dateByAddingTimeInterval: interval];
    return localdate.description;
}

- (IBAction) popOK:(id)sender {
//    NSLog(@"start to check out ..");
//    NSLog(@"%@ %@", bt_startDate.titleLabel.text, bt_overDate.titleLabel.text);

    NSDateFormatter * formartter1 = [[NSDateFormatter alloc] init];
    [formartter1 setDateFormat:@"yyyy/MM/dd"];
    NSDate * staDate = [formartter1 dateFromString: bt_startDate.titleLabel.text];
    NSDate * endDate = [formartter1 dateFromString: bt_overDate.titleLabel.text];
    
    [vi_dp setHidden:YES];
    [vi_popView setHidden:YES];
    
    // 判断开始时间和结束时间的大小
    NSTimeInterval secondsInterval = [endDate timeIntervalSinceDate:staDate]
    ;
    if (secondsInterval < 0.0f) {
        jkAlertController * view = [[jkAlertController alloc]initWithOKButton:@"时间区间选择错误，请重新选择。"];
        [view show];
        return;
    }
    
    // reset table data
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSDateFormatter * formartter2 = [[NSDateFormatter alloc] init];
    [formartter2 setDateFormat:@"yyyy/MM/dd"];
    
    for (NSString * key in [m_arrayTiao allKeys]) {
        NSDate * date = [formartter1 dateFromString:key];
//        NSLog(@"%@ %lf %lf", key, [date timeIntervalSinceDate:staDate],[date timeIntervalSinceDate:endDate]);
        
        if ([date timeIntervalSinceDate:staDate] >= 0 && [date timeIntervalSinceDate:endDate] <= 0 ) {
            [array addObject:[formartter2 stringFromDate:date]];
        }
    }
//    m_arrtoshow = nil;
    m_arrtoshow = (NSMutableArray *)array;
    
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    m_arrtoshow = [m_arrtoshow sortedArrayUsingDescriptors:@[sort]];
    [mainTableView reloadData];
}

- (IBAction) popCancel:(id)sender {
    [bt_startDate setTitle:m_starttime forState:UIControlStateNormal];
    [bt_overDate setTitle: m_overtime forState:UIControlStateNormal];
}

- (IBAction) touchdownStartTimeEdit:(id)sender {
    m_isnotStart = 1;
    [vi_dp setHidden: NO];
    
    NSDateFormatter * formartter = [[NSDateFormatter alloc] init];
    [formartter setDateFormat:@"yyyy/MM/dd"];
    [dp_datepicker setDate:[formartter dateFromString:bt_startDate.titleLabel.text]];
}

- (IBAction) touchdownOverTimeEdit:(id)sender {
    m_isnotStart = 2;
    [vi_dp setHidden: NO];
    
    NSDateFormatter * formartter = [[NSDateFormatter alloc] init];
    [formartter setDateFormat:@"yyyy/MM/dd"];
    [dp_datepicker setDate:[formartter dateFromString:bt_overDate.titleLabel.text]];
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
    [formartter setDateFormat:@"yyyy/MM/dd"];
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
    //
    if (m_starttime == nil || m_overtime == nil) {
        jkAlertController * view = [[jkAlertController alloc]initWithOKButton:@"数据异常,请重新获取数据 .."];
        view.okBlock = ^() {
            [vi_popView setHidden: YES];
        };
        [view show];
    }
    
    [bt_startDate setTitle:m_starttime forState:UIControlStateNormal];
    [bt_overDate setTitle: m_overtime forState:UIControlStateNormal];
    
    NSDateFormatter * formartter = [[NSDateFormatter alloc] init];
    [formartter setDateFormat:@"yyyy/MM/dd"];
    dp_datepicker.minimumDate = [formartter dateFromString:m_starttime];
    dp_datepicker.maximumDate = [formartter dateFromString:m_overtime];
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
