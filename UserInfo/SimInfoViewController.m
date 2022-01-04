//
//  SimInfoViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "SimInfoViewController.h"
#import "public.h"
#import "SimInfoTableViewCell.h"
#import "SimInfoObject.h"

@interface SimInfoViewController () <PostSessionDataDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation SimInfoViewController {
    GetPostSessionData * postSession;
    IBOutlet UITableView * m_tableview;
    
    NSMutableDictionary * m_dictData;
    NSMutableArray * m_arrTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"套餐余量查询";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
    
    m_tableview.allowsSelection = NO;
    m_tableview.tableFooterView = [[UIView alloc]init];
    m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    m_arrTitle = [[NSMutableArray alloc]initWithObjects:@"截止时间", @"套餐语音", @"剩余语音"
                  , @"套餐流量", @"剩余流量", nil];
    m_dictData = [[NSMutableDictionary alloc]init];
}

- (void) viewDidAppear:(BOOL)animated {
    [self sendPostSessionForsimInfo];
//    if ([[self.UserInfo gKCUserSim]count] == 0) {
    
//    }
//    else {
//        m_dictData = [self.UserInfo gKCUserSim];
//        [m_tableview reloadData];
//    }
}

- (void) sendPostSessionForsimInfo {
    NSString * url = [NSString stringWithFormat:@"%@/system/user/queryproduct", HTTP_GET_POST_ADDRESS_KC];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
    [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
    [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
    [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
    NSDictionary * body = [self fixDictionaryForKCSession:dict];
    
    [postSession SendPostSessionRequestForKC:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    if ([request isEqualToString:@"NSURLErrorNetworkConnectionLost"]) {
        return;
    }
    
    if ([request isEqualToString:@"jk-Error"]) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:NETWORK_ERROR];
        [alertview show];
        return;
    }
    
    NSString * code = nil;
    NSDictionary * mdic = [postSession getDictionaryFromRequest];
    code = [[mdic objectForKey:@"errcode"]stringValue];
    
    if ([mdic count] == 3 && [[mdic allKeys] containsObject:@"data"]) {
        
        if ([code isEqualToString:@"0"]) {
            NSArray * list = [[mdic objectForKey:@"data"]objectForKey:@"product_list"];

            [m_dictData removeAllObjects];
            for (NSDictionary * dict in list) {
                NSString * name = [dict objectForKey:@"resource_name"];
                NSString * value = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"resouce_value"], [dict objectForKey:@"resouce_unit"]];
                
                SimInfoObject * obj = [[SimInfoObject alloc]init];
                obj.key = name;
                obj.value = value;
                
                NSString * code = [dict objectForKey:@"resouce_order"];
                [m_dictData setObject:obj forKey:code];

            } // end For
            
            [m_tableview reloadData];
        }
        else {
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
            [alertview show];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// config tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [m_dictData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SimInfoTableViewCell";
    
    SimInfoTableViewCell *cell = (SimInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }

    NSArray * keys = [m_dictData allKeys];
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    keys = [keys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    NSString * key = [keys objectAtIndex:indexPath.row];
    
    SimInfoObject * obj = (SimInfoObject *)[m_dictData objectForKey:key];
    [cell setItemValue:obj.value Key:obj.key];
    
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
