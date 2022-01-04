//
//  DashBoardViewController.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/14/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "DashBoardViewController.h"
#import "MainNavigationController.h"
#import "DashBoardTableViewCell.h"

#import "DJRefresh.h"
#import "DJRefreshProgressView.h"

#import "GNLUserInfo.h"
#import "jkAlertController.h"
#import "public.h"
#import "GetPostSessionData.h"

@interface DashBoardViewController () <UITableViewDelegate, UITableViewDataSource, DJRefreshDelegate, PostSessionDataDelegate, UIGestureRecognizerDelegate>

@end

@implementation DashBoardViewController {
    IBOutlet UILabel * la_title;
    IBOutlet UITableView * m_tableview;
    
    GetPostSessionData * postSession;
    DJRefresh * m_refrese;
    
    NSMutableArray * m_arrtablevalue;
    NSArray * m_arrimageicon;
    NSArray * m_arrtitletext;
    
    BOOL flashflag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_menuicon"] style: UIBarButtonItemStylePlain target:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 向右滑动显示菜单
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    recognizer.delegate = self;
    [[self view] addGestureRecognizer:recognizer];
    
    self.navigationItem.title = @"仪表盘";
    //
    [la_title setText: [GNLUserInfo defaultCarLisence]];
    [la_title setFont: [UIFont fontWithName: FONT_MM size: 18.0f]];
    
    m_arrtablevalue = [[NSMutableArray alloc] init];
    m_arrimageicon = [[NSArray alloc] initWithObjects:@"dash_oil", @"dash_pay", @"dash_rang", @"dash_long", @"dash_speed", @"dash_away", nil];
    m_arrtitletext = [[NSArray alloc] initWithObjects:@"剩余油量", @"百公里油耗", @"可续航里程", @"总里程", @"平均车速", @"距离保养总里程", nil];

    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
    
    // table view header view
    UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_seperateline02"]];
    headerImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f);
//    UILabel * tmpla = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 30.0f)];
//    [tmpla setText: @" 汽车状态"];
//    [tmpla setFont: [UIFont fontWithName: FONT_XI size: 15.0f]];
//    [headerImage addSubview: tmpla];
    m_tableview.tableHeaderView = headerImage;
    m_tableview.allowsSelection = NO;
    [m_tableview setSeparatorColor:[UIColor clearColor]];
//    flashflag = NO;
    
    //
    m_refrese = [DJRefresh refreshWithScrollView: m_tableview];
    m_refrese.delegate = self;
    m_refrese.topEnabled=YES;
    m_refrese.autoRefreshTop=YES;
    
    
    if ([GNLUserInfo isDemo]) {
        [self.view addSubview: [ServicesPro loadMarkDemoView]];
    }
}

- (void) refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getPostSession];
        NSLog(@"%@", [self.view subviews]);
    });
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
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

//
- (void) getPostSession {
    NSString * url = [NSString stringWithFormat:@"%@/api/searchVhlStatus", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&vin=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo defaultCarVin], [GNLUserInfo isDemo] ? @"true" : @"false"];
    NSLog(@"%@ %@", url, body );
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    
    NSLog(@"Dash Board - %@", request);
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
    
    NSDictionary * dic = [postSession getDictionaryFromRequest];
    if ([[[dic objectForKey:@"status"] objectForKey:@"code"] isEqualToString: @"402"]) {
        MainNavigationController * ctl = (MainNavigationController *) self.navigationController;
        [ctl turntoLoginForOut];
        return;
    }
    
    if ([[[dic objectForKey:@"status"] objectForKey:@"description"] isEqualToString: @"Success"]) {
        
///////////////////////////
        [m_arrtablevalue removeAllObjects];
        [m_tableview setSeparatorColor:[UIColor lightGrayColor]];
        
        // 剩余油量 remainedOil ％ 显示 %%
        [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@ 升", [dic objectForKey:@"remainedOil"]]];
        // 百公里油耗 fuelConsumedAverage
        [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@ 升/100公里", [dic objectForKey:@"fuelConsumedAverage"]]];
        // 可续航里程 range
        [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@ 公里", [dic objectForKey:@"range"]]];
        // 总里程 totalMileage
        [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@ 公里", [dic objectForKey:@"totalMileage"]]];
        // 平均车速 speedAverage
        [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@ 公里/小时", [dic objectForKey:@"speedAverage"]]];
        // 距离保养总里程 mileageBeforeMaintenance
        [m_arrtablevalue addObject: [NSString stringWithFormat:@"%@ 公里", [dic objectForKey:@"mileageBeforeMaintenance"]]];
    }
    else {
        jkAlertController * view = [[jkAlertController alloc] initWithTitle:@"" CenterLabel: NETWORK_ERROR Enter: @"确 定" Cancle: nil];
        [view show];
        return;
    }
    [m_tableview reloadData];
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

// config tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [m_arrtablevalue count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
