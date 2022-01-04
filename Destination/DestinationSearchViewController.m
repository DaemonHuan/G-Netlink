//
//  DestinationSearchViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/31/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "DestinationSearchViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>

#import "public.h"

@interface DestinationSearchViewController () <AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation DestinationSearchViewController {
    IBOutlet UITextField * tf_search;
    IBOutlet UIView * vi_search;
    IBOutlet UITableView * m_tableview;
    
    AMapSearchAPI * m_search;
    NSArray * m_searchTips;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(doInputTextSearch)];
    [rightItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:self action:@selector(viewcontrollerReturn)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    UIBarButtonItem * titleItem = [[UIBarButtonItem alloc] initWithCustomView:vi_search];
    [vi_search setFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width * 0.7f, 32.0f)];
    vi_search.layer.cornerRadius = 5.0f;
    self.navigationItem.titleView = vi_search;
    
    m_search = [[AMapSearchAPI alloc]init];
    m_search.delegate = self;

    m_tableview.tableFooterView = [[UIView alloc]init];
    
    UIColor *color = [UIColor colorWithWhite: 0.333f alpha:0.5f];
    tf_search.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入目的地" attributes:@{NSForegroundColorAttributeName: color}];
    [tf_search setTintColor:[UIColor darkGrayColor]];
}

- (void) viewDidAppear:(BOOL)animated {
    self.result = nil;
    [tf_search setText:@""];
    m_searchTips = nil;
    [m_tableview reloadData];
    
    // 激活输入框 弹出软键盘
    [tf_search becomeFirstResponder];
}

- (IBAction) doInputTipsSearch:(id)sender {
    AMapInputTipsSearchRequest * tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = tf_search.text;
    tipsRequest.city = self.m_cityForLocation;
    
    //发起输入提示搜索
    [m_search AMapInputTipsSearch: tipsRequest];
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.count == 0) return;

    //通过AMapInputTipsSearchResponse对象处理搜索结果
    m_searchTips = response.tips;
    [m_tableview reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_searchTips count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    AMapTip * tips = (AMapTip *)[m_searchTips objectAtIndex: indexPath.row];
    cell.textLabel.text = tips.name;
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    tf_search.text = ((AMapTip *)[m_searchTips objectAtIndex: indexPath.row]).name;
    self.result = tf_search.text;
    [self textfield_TouchDown:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewcontrollerReturn {
    [tf_search setText:@""];
    self.result = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doInputTextSearch {
    self.result = [self fixKeyWordForSearch:tf_search.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *) fixKeyWordForSearch :(NSString *) str {
    // 过滤特殊字符
    NSString * key = str;
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"@[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+?/$!！.<>《》，。,;:'\"“”…‘’：；？＊％～"];
    key = [[key componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    return key;
}

// 隐藏键盘.
- (IBAction) textfield_didEdit:(id)sender {
    [sender resignFirstResponder];
    
    self.result = [self fixKeyWordForSearch:tf_search.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) textfield_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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
