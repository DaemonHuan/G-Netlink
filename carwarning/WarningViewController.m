//
//  WarningViewController.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/14/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "WarningViewController.h"
#import "MainNavigationController.h"
#import "WarningTableViewCell.h"

#import "public.h"
#import "GNLUserInfo.h"
#import "jkAlertController.h"
#import "DJRefresh.h"
#import "GetPostSessionData.h"

@interface WarningViewController () <UITableViewDelegate, UITableViewDataSource, PostSessionDataDelegate, DJRefreshDelegate, UIGestureRecognizerDelegate>

@end

@implementation WarningViewController {
    IBOutlet UITableView * m_tableview;
    IBOutlet UILabel * la_title;
    IBOutlet UIImageView * iv_title;
    
    GetPostSessionData * PostSession;
    DJRefresh * m_refrese;
    
    NSDictionary * m_dicTitle;
    NSDictionary * m_dicIcon;
    NSDictionary * m_dicWIcon;

    NSMutableArray * m_arrAllValue;
    NSMutableArray * m_arrErrValue;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    
    self.navigationItem.title = @"告警";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_menuicon"] style: UIBarButtonItemStylePlain target:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 向右滑动显示菜单
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    recognizer.delegate = self;
    [[self view] addGestureRecognizer:recognizer];
    
    [la_title setFont: [UIFont fontWithName:FONT_MM size:18.0f]];
    
    // init data
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
    m_arrErrValue = [[NSMutableArray alloc]init];
    
    // post session
    PostSession = [[GetPostSessionData alloc] init];
    PostSession.delegate = self;
    
    // table view header view
//    UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_title2"]];
//    headerImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 30.0f);
//    UILabel * tmpla = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 30.0f)];
//    [tmpla setText: @" 汽车状态"];
//    [tmpla setFont: [UIFont fontWithName: FONT_XI size: 15.0f]];
//    [headerImage addSubview: tmpla];
    UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_seperateline02"]];
    headerImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f);
    m_tableview.tableHeaderView = headerImage;
    m_tableview.allowsSelection = NO;
    
    m_refrese = [DJRefresh refreshWithScrollView: m_tableview];
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
        [self getPostSession];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) viewDidDisappear:(BOOL)animated {
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) getPostSession {
    [la_title setText: @"数据加载中 .."];
    NSString * url = [NSString stringWithFormat:@"%@/api/searchVhlStatus", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&vin=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo defaultCarVin], [GNLUserInfo isDemo] ? @"true" : @"false"];
    [PostSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    NSLog(@"warning - %@", request);
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
    
    NSArray * arrayRes = [[PostSession getDictionaryFromRequest]objectForKey:@"alertList"];
    if ([[[[PostSession getDictionaryFromRequest] objectForKey:@"status"] objectForKey:@"description"] isEqualToString: @"Success"]) {
        
        m_arrAllValue = [[NSMutableArray alloc]initWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", nil];
        [m_arrErrValue removeAllObjects];
        
        for (NSDictionary * tmp in arrayRes) {
            [m_arrAllValue removeObject:[tmp objectForKey:@"alertName"]];
            [m_arrErrValue addObject:[tmp objectForKey:@"alertName"]];
        }
        
        
        [m_tableview reloadData];
    }
    else {
        jkAlertController * view = [[jkAlertController alloc] initWithTitle:@"" CenterLabel: DATA_ERROR Enter: @"确 定" Cancle: nil];
        [view show];
    }
    
    NSLog(@"** warning list - %ld %ld", [m_arrAllValue count], [m_arrErrValue count]);
    if ([m_arrErrValue count] == 0) {
        [la_title setText: @"看起来一切正常"];
        [la_title setTextColor:[UIColor whiteColor]];
        [iv_title setImage:[UIImage imageNamed:@"warn_normal"]];
    }
    else {
        [la_title setText: @"车辆发现故障"];
//        [la_title setTextColor:[UIColor redColor]];
        [iv_title setImage:[UIImage imageNamed:@"warn_title"]];
    }
    
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    NSInteger lines = [m_arrAllValue count] + [m_arrErrValue count];
    return lines;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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


//    if ([m_arrvalue containsObject:[NSString stringWithFormat:@"%02ld", indexPath.row + 1]]) {
//        [cell setItemIconWithTitle:[m_arrwicon objectAtIndex:indexPath.row] Title:[m_arrtitle objectAtIndex:indexPath.row]];
//        [cell setItemStatus: WARNING_ERROR];
//    }
//    else {
//        [cell setItemIconWithTitle:[m_arricon objectAtIndex:indexPath.row] Title:[m_arrtitle objectAtIndex:indexPath.row]];
//        [cell setItemStatus: WARNING_OK];
//    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
