//
//  NotationsViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/1/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "NotationsViewController.h"
#import "public.h"

#import "NotationsTableViewCell.h"
#import "NotationsDetailViewController.h"

@interface NotationsViewController () <PostSessionDataDelegate, DJRefreshDelegate>

@end

@implementation NotationsViewController {
    IBOutlet UILabel * la_title;
    IBOutlet UITableView * m_tableview;
    IBOutlet UIView * vi_wuwu;
    
    GetPostSessionData * postSession;
    DJRefresh * m_refrese;
    
    NSDictionary * m_msgTypes;
    NSDictionary * m_msgIcons;
    NSMutableArray * m_msgList;
    NSInteger m_rowsCount;
    NSInteger m_newsCount;
    
    BOOL flagForRefrese;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_outline"] style:UIBarButtonItemStylePlain target:self action:@selector(checkMessages)];
//    [rightItem setTintColor: [UIColor whiteColor]];
//    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationItem setTitle:@"消息推送"];
    
    m_msgTypes = @{@"0":@"普通消息", @"1":@"控制消息",
                   @"2":@"生日祝福", @"3":@"节日祝福",
                   @"4":@"SIM卡余额定时通知", @"5":@"油耗对比推送",
                   @"6":@"驾驶安全提醒推送", @"7":@"车况状态推送"
                   };
    m_msgIcons = @{@"0":@"notations_msg", @"2":@"notations_birth",
                   @"3":@"notations_holiday", @"4":@"notations_siminfo",
                   @"5":@"notations_oil", @"6":@"notations_drive",
                   @"7":@"notations_car"};
    m_msgList = [[NSMutableArray alloc]init];
    
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;

    [la_title setTextColor:[UIColor whiteColor]];
    [la_title setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE1]];
    
    UIImageView * headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"public_seperateline02"]];
    headerImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 2.0f);
    m_tableview.tableHeaderView = headerImage;
    m_tableview.tableFooterView = [[UIView alloc]init];
    m_refrese = [DJRefresh refreshWithScrollView: m_tableview];
    m_refrese.delegate = self;
    m_refrese.topEnabled = YES;
    m_refrese.bottomEnabled = YES;
    //    m_refrese.autoRefreshTop = YES;
//    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];

    if ([self.UserInfo isRunDemo]) {
        [self.view addSubview: [ExtendStaticView MarkDemoView]];
    }
    
    [vi_wuwu setHidden:YES];
    m_newsCount = 0;
    flagForRefrese = NO;
}

- (void) viewDidAppear:(BOOL)animated {
    [m_msgList removeAllObjects];
    [m_tableview reloadData];
    m_newsCount = 0;
    [la_title setText:[NSString stringWithFormat:@"您有 %zd 条新信息", m_newsCount]];
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (flagForRefrese == YES) return;
        
        if (direction == DJRefreshDirectionBottom) m_rowsCount += 1;
        else {
            [m_msgList removeAllObjects];
            m_rowsCount = 1;
        }
        
        if ([self.UserInfo isKCUser]) {
            [self sendPostSessionForKC: m_rowsCount];
            [vi_wuwu setHidden:YES];
        }
        else {
            [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
            [vi_wuwu setHidden:NO];
        }
    });
}

- (void) sendPostSessionForKC: (NSInteger) index {
    flagForRefrese = YES;
    NSString * url = [NSString stringWithFormat:@"%@/system/sendmsg/querylist", HTTP_GET_POST_ADDRESS_KC];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
    [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
    [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
    [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
    NSMutableDictionary * body = [[NSMutableDictionary alloc]init];
    [body setObject: dict forKey: @"ntspheader"];
    [body setObject: [NSString stringWithFormat:@"%zd", index] forKey: @"pageindex"];
    [body setObject: @"10" forKey: @"pagesize"];
    [body setObject: [NSArray arrayWithObjects:@"0", @"2", @"3", @"4", @"5", @"6", @"7", nil] forKey:@"messagetypes"];
//    [[NSArray alloc]initWithObjects: (NSInteger)0, nil];
    [postSession SendPostSessionRequestForKC:url Body:body];
}

- (void) sendPostSessionForKCNewsCount {
    flagForRefrese = YES;
    NSString * url = [NSString stringWithFormat:@"%@/system/sendmsg/querycount", HTTP_GET_POST_ADDRESS_KC];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
    [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
    [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
    [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
    NSMutableDictionary * body = [[NSMutableDictionary alloc]init];
    [body setObject: dict forKey: @"ntspheader"];
    [body setObject: [NSArray arrayWithObjects:@"0", @"2", @"3", @"4", @"5", @"6", @"7", nil] forKey:@"messagetypes"];
    
    [postSession SendPostSessionRequestForKC:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    flagForRefrese = NO;
    
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
    [m_refrese finishRefreshingDirection:DJRefreshDirectionBottom animation:YES];
    
    if ([request isEqualToString:@"NSURLErrorNetworkConnectionLost"]) {
        return;
    }
    
    if ([request isEqualToString:@"jk-Error"]) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:DATA_ERROR];
        [alertview show];
        alertview.okBlock = ^(){
            [m_msgList removeAllObjects];
            [m_tableview reloadData];
        };
        return;
    }
    
    NSDictionary * mdic = [postSession getDictionaryFromRequest];
    NSString * code = [[mdic objectForKey:@"errcode"]stringValue];
    NSDictionary * data = [mdic objectForKey:@"data"];
    if ([[data allKeys] count] == 2) {
        // 标记已读消息
        m_newsCount = [[data objectForKey:@"unreadcount"] integerValue];
        [la_title setText:[NSString stringWithFormat:@"您有 %zd 条新信息", m_newsCount]];
    }
    else if ([[data allKeys] count] == 3) {
        if ([code isEqualToString:@"0"]) {
            [m_msgList addObjectsFromArray:[[mdic objectForKey:@"data"]objectForKey:@"sendmsg"]];
            [m_tableview reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self sendPostSessionForKCNewsCount];
            });
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) checkMessages {
    
}

// tableview load
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_msgList count];
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"NotationsTableViewCell";
    NotationsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ([m_msgList count] == 0) {
        return cell;
    }
    
    NSDictionary * dict = [m_msgList objectAtIndex:indexPath.row];
    NSString * iconc = [[dict objectForKey:@"messagetype"]stringValue];
    NSString * icon = [m_msgIcons objectForKey: iconc];
    if ([[dict objectForKey:@"isread"]integerValue] == 0) {
        [cell setItemFlagIcon: YES Icon: icon];
//        m_newsCount += 1;
    }
    else {
        [cell setItemFlagIcon: NO Icon: icon];
    }

    [cell setItemTitle:[dict objectForKey:@"title"] Contains:[dict objectForKey:@"content"]];
    [cell setItemTime:[[dict objectForKey:@"addtime"] substringWithRange:NSMakeRange(0, 10)]];
    
    //
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 去除选中行的被选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * msginfo = [m_msgList objectAtIndex:indexPath.row];
    NSString * msgId = [msginfo objectForKey:@"msgid"];
    
    NSString * url = [NSString stringWithFormat:@"%@/system/sendmsg/hasread", HTTP_GET_POST_ADDRESS_KC];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
    [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
    [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
    [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
    NSMutableDictionary * body = [[NSMutableDictionary alloc]init];
    [body setObject: dict forKey: @"ntspheader"];
    [body setObject: msgId forKey: @"msgid"];
    [postSession SendPostSessionRequestForKC:url Body:body];

    NotationsDetailViewController * view = [[NotationsDetailViewController alloc]init];
    view.itemTime = [msginfo objectForKey:@"addtime"];
    view.itemSource = [msginfo objectForKey:@"source"];
    view.itemTitle = [msginfo objectForKey:@"title"];
    [self.navigationController pushViewController:view animated:YES];
    
    [view setItemDetail:[msginfo objectForKey:@"detail_content"]];
    
}

/* #pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
} */

@end
