//
//  SlideMenuView.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/7/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "SlideMenuView.h"
#import "public.h"
//#import "jkAlertController.h"
#import "SlideMenuTableViewCell.h"

@interface SlideMenuView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@end

@implementation SlideMenuView {
    UIView * backBroudView;
    CGRect viewbounds;
    
    IBOutlet UIButton * bt_logoff;
    IBOutlet UIButton * bt_usericon;
    IBOutlet UIButton * bt_userinfo;
    IBOutlet UILabel * la_username;
    IBOutlet UILabel * la_carcode;
    IBOutlet UITableView * menutableview;
    
    NSArray * m_menulist;
    NSArray * m_menuicon;
    
    NSInteger m_currentviewcode;
}

@synthesize delegate;

- (id) initWithContainView {
    if (self = [super init]) {
        m_menulist = [[NSArray alloc] initWithObjects:@"首页", @"车辆控制", @"车辆位置",@"发送目的地", @"行车日志", @"仪表盘", @"告警", @"一键服务", @"切换车辆", nil];
        m_menuicon = [[NSArray alloc]initWithObjects:@"menu_home", @"menu_carcontrol", @"menu_location", @"menu_destination", @"menu_travellog", @"menu_panel", @"menu_alert", @"menu_onekey", @"menu_check", nil];
        
        viewbounds.origin = CGPointZero;
        viewbounds.size.width = [UIScreen mainScreen].bounds.size.width * 0.8f;
        viewbounds.size.height = [UIScreen mainScreen].bounds.size.height;
        
        UIView * centerView = [[[NSBundle mainBundle] loadNibNamed:@"SlideMenuView" owner:self options:nil] lastObject];
        [centerView setFrame: viewbounds];
//        [centerView setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_title"]]];
        [self addSubview: centerView];
        
        //
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        
        la_username.text = @"Default User ..";
        la_username.textColor = [UIColor colorWithHexString: WordColor];
        [la_username setFont: [UIFont fontWithName: FONT_MM size:18.0f]];
        
        la_carcode.text = @"- - - - - -";
        la_carcode.textColor = [UIColor whiteColor];
        [la_carcode setFont: [UIFont fontWithName:FONT_XI size: 16.0f]];
        
        bt_logoff.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [bt_logoff setTintColor: [UIColor colorWithHexString: WordColor]];
        [bt_logoff setTitleColor:[UIColor colorWithHexString: WordColor] forState:UIControlStateNormal];
        [bt_logoff.titleLabel setFont: [UIFont fontWithName:FONT_MM size: 20.0f]];
        
        //
        menutableview.opaque = NO;
        menutableview.sectionHeaderHeight = 0.0f;
        menutableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        menutableview.rowHeight = 60.0f;
        m_currentviewcode = 0;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void) setMessageForTitle: (NSString *)username carlisence: (NSString *) code {
    [la_username setText:username];
    [la_carcode setText:code];
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake(-viewbounds.size.width, 0.0f, viewbounds.size.width, viewbounds.size.height);
    [topVC.view addSubview:self];
}

- (void) close {
    [self dismissAlert];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!backBroudView) {
        backBroudView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        backBroudView.backgroundColor = [UIColor blackColor];
        backBroudView.alpha = 0.0f;
        backBroudView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        // clicked to hidden
        UITapGestureRecognizer * singleTouchUp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)];
        [backBroudView addGestureRecognizer:singleTouchUp];
        
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
    }
    [topVC.view addSubview: backBroudView];
    
    self.transform = CGAffineTransformMakeTranslation(-viewbounds.size.width, 0.0f);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = viewbounds;
        backBroudView.alpha = 0.5f;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview: newSuperview];
}

- (void)removeFromSuperview
{
    [backBroudView removeFromSuperview];
    backBroudView = nil;
    
    CGRect afterFrame = CGRectMake(-viewbounds.size.width, 0.0f, viewbounds.size.width, viewbounds.size.height);
    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

// Actions
- (IBAction) doShowUserManager:(id)sender {
    if (m_currentviewcode == 100) {
        [self dismissAlert];
        return;
    }
    else {
        m_currentviewcode = 100;
        [delegate doSlideMenuActions:@"00"];
        [self dismissAlert];
    }
}

- (IBAction) doLogoff:(id)sender {
    if (m_currentviewcode == 101) {
        [self dismissAlert];
        return;
    }
    else {
        m_currentviewcode = 101;
        [delegate doSlideMenuActions:@"exit&logoff"];
    }
}

// tableview delegate functions
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld %ld", m_currentviewcode, indexPath.row);
    if (m_currentviewcode == indexPath.row && indexPath.row != 0) {
        [self dismissAlert];
        return;
    }
    else {
        m_currentviewcode = indexPath.row;
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        // 首页
        [delegate doSlideMenuActions:@"01"];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        // 车辆控制
        [delegate doSlideMenuActions:@"02"];
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        // 车辆位置
        [delegate doSlideMenuActions:@"03"];
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
        // 发送目的地
        [delegate doSlideMenuActions:@"04"];
    }
    else if (indexPath.section == 0 && indexPath.row == 4) {
        // 行车日志
        [delegate doSlideMenuActions:@"05"];
    }
    else if (indexPath.section == 0 && indexPath.row == 5) {
        // 仪表盘
        [delegate doSlideMenuActions:@"06"];
    }
    else if (indexPath.section == 0 && indexPath.row == 6) {
        // 告警
        [delegate doSlideMenuActions:@"07"];
    }
    else if (indexPath.section == 0 && indexPath.row == 7) {
        // 一键服务
        [delegate doSlideMenuActions:@"08"];
    }
//    else if (indexPath.section == 0 && indexPath.row == 8) {
//        // 违章查询
//        [delegate doSlideMenuActions:@"09"];
//        
//    }
    else if (indexPath.section == 0 && indexPath.row == 8) {
        // 更改车辆
        [delegate doSlideMenuActions:@"10"];
    }
    else {
        NSLog(@"Error ..");
    }
    // close this view
    [self dismissAlert];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [m_menulist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    SlideMenuTableViewCell *cell = (SlideMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"SlideMenuTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    }
    cell = (SlideMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [cell setitem:[m_menuicon objectAtIndex:indexPath.row] LabelText:[m_menulist objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
}

@end
