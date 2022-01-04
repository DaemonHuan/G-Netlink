//
//  LoginViewController.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/8/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "LoginViewController.h"
#import "MainNavigationController.h"
#import "MainViewController.h"

#import "public.h"
#import "GNLUserInfo.h"
#import "jkAlertController.h"
#import "GetPostSessionData.h"

#import "ProtocolViewController.h"
#import "PasswordIdentifierViewController.h"
#import "MobClick.h"

#import "KCViewController.h"
#import "NodeRoot.h"

@interface LoginViewController () <PostSessionDataDelegate, UITableViewDelegate, UITableViewDataSource, KCLoginDelegate>

@end

@implementation LoginViewController {
    IBOutlet UITextField * tf_username;
    IBOutlet UITextField * tf_password;
    IBOutlet UITextField * tf_defaultcar;
    IBOutlet UIButton * bt_autologin;
    IBOutlet UIButton * bt_savepassword;
    IBOutlet UIButton * bt_xshowmodel;
    IBOutlet UIButton * bt_login;
    IBOutlet UIButton * bt_findpd;
    IBOutlet UIButton * bt_enterprotocol;
    IBOutlet UIButton * bt_protocol;
    IBOutlet UIButton * bt_displaylist;
    IBOutlet UITableView * tv_vehicletype;
    IBOutlet UIImageView * iv_centor;
    
    IBOutlet UILabel * lb_protocol;
    IBOutlet UILabel * lb_forgetpass;
    
    BOOL is_autologin;
    BOOL is_savepassword;
    BOOL is_protocol;
    
    NSArray * m_arrvehicletype;
    NSArray * m_arrkctypes;
    
    ProtocolViewController * m_protocolview;
    GetPostSessionData * PostSession;
    jkAlertController * loadview;
    
    KCViewController * m_kcview;
    NodeRoot * nodeRoot;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    
    iv_centor.layer.cornerRadius = 5.0f;
    
    [bt_autologin setTitle:@"" forState:UIControlStateNormal];
    [bt_autologin setImage: [UIImage imageNamed:@"login_unselected"] forState:UIControlStateNormal];
    [bt_savepassword setTitle:@"" forState:UIControlStateNormal];
    [bt_savepassword setImage:[UIImage imageNamed:@"login_unselected"] forState:UIControlStateNormal];
    
    [bt_protocol setTitle:@"" forState: UIControlStateNormal];
    [bt_protocol setImage: [UIImage imageNamed: @"login_protol2"] forState:UIControlStateNormal];
    
    NSMutableAttributedString * asProtocol = [[NSMutableAttributedString alloc]initWithString:@"阅读并同意用户协议"];
//    [asProtocol addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(4, 5)];
    [asProtocol addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:WORD_COLOR] range:NSMakeRange(5,4)];
    [asProtocol addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(5, 4)];
    [lb_protocol setAttributedText:asProtocol];
    
    NSMutableAttributedString * asforgot = [[NSMutableAttributedString alloc]initWithString:@"忘记密码？ 找回密码"];
    [asforgot addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:WORD_COLOR] range:NSMakeRange(6,4)];
    [asforgot addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(6, 4)];
    [lb_forgetpass setAttributedText:asforgot];
    
    bt_xshowmodel.layer.cornerRadius = 9.0f;
    bt_login.layer.cornerRadius = 9.0f;
    
    [bt_displaylist setTitle:@"" forState:UIControlStateNormal];
    //[bt_displaylist setBackgroundImage:[UIImage imageNamed:@"login_listicon"] forState:UIControlStateNormal];
    
    UIColor *color = [UIColor colorWithWhite:1.0f alpha:0.5f];
    tf_username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入账户" attributes:@{NSForegroundColorAttributeName: color}];
    tf_password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    tf_defaultcar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择车型" attributes:@{NSForegroundColorAttributeName: color}];

    // 默认车型选型
    m_arrvehicletype = [[NSArray alloc]initWithObjects: @"博越内部测试体验版", @"博瑞", nil]; //, @"帝豪GS" @"博越", 内部测试体验版
    m_arrkctypes = [[NSArray alloc] initWithObjects:@"博瑞", nil];
    
    [tv_vehicletype setHidden:YES];
    [tv_vehicletype setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]];
    [tv_vehicletype setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tv_vehicletype setSeparatorColor: [UIColor lightGrayColor]];

    // flags for userinfo
    is_autologin = NO;
    is_savepassword = NO;
    is_protocol = YES;
    [bt_protocol setImage:[UIImage imageNamed:@"login_protol1"] forState:UIControlStateNormal];
    
    //
    m_protocolview = [[ProtocolViewController alloc] init];
    
    // PostSession init
    PostSession = [[GetPostSessionData alloc]init];
    PostSession.delegate = self;
    
//    [self doLoadUserInfo];
}

- (void) viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if ([GNLUserInfo isTokenPass]) {
        jkAlertController * alerttopost = [[jkAlertController alloc] initWithOKButton:@"当前账户登录时效已过期,\n请重新登录" ];
        [alerttopost show];
        [GNLUserInfo setTokenPass: NO];
    }
    
    /* 清空登录页用户信息
    if (![GNLUserInfo isonline]) {
        is_autologin = NO;
        is_savepassword = NO;
        is_protocol = NO;
        [bt_autologin setBackgroundImage: [UIImage imageNamed:@"login_unselected"] forState:UIControlStateNormal];
        [bt_savepassword setBackgroundImage:[UIImage imageNamed:@"login_unselected"] forState:UIControlStateNormal];
        [bt_protocol setImage: [UIImage imageNamed: @"login_protol2"] forState:UIControlStateNormal];
        
        tf_username.text = nil;
        tf_password.text = nil;
        tf_defaultcar.text = nil;
        [self doSetUserInfo];       // 清理userdefault
    }
    else {
        [self doLoadUserInfo];
    }
    */
    
    tf_username.text = nil;
    tf_password.text = nil;
    tf_defaultcar.text = nil;
    [self doLoadUserInfo];
    
    //
    [bt_xshowmodel setHidden:[m_arrkctypes containsObject: tf_defaultcar.text]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Post Sessions
- (void) sendPostSession {
    loadview = [[jkAlertController alloc] initWithLoadingGif: @"正在连接服务器\n请稍候..."];
    [loadview show];
    NSString * url = [NSString stringWithFormat:@"%@/api/login", HTTP_GET_POST_ADDRESS];
    NSString *param = [NSString stringWithFormat:@"username=%@&password=%@&isdemo=%@", tf_username.text, tf_password.text, [GNLUserInfo isDemo] ? @"true" : @"false"];
    [PostSession SendPostSessionRequest:url Body:param];
}

- (void) sendcarpostSession {
    NSString * url = [NSString stringWithFormat:@"%@/api/getVehiclesOfUser", HTTP_GET_POST_ADDRESS];
    NSString * body =[NSString stringWithFormat:@"accessToken=%@&username=%@&isdemo=%@", [GNLUserInfo accessToken], tf_username.text, [GNLUserInfo isDemo] ? @"true" : @"false"];
    [PostSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    NSLog(@"Request - %@", request);
    if (request == nil) return;
    if ([request isEqualToString:@"jk-error .."]) {
        [loadview close];
        jkAlertController * alerttopost = [[jkAlertController alloc] initWithOKButton:NETWORK_ERROR ];
        [alerttopost show];
        return;
    }
    if ([request isEqualToString:@"jk-timeout .."]) {
        [loadview close];
        jkAlertController * alerttopost = [[jkAlertController alloc] initWithOKButton:NETWORK_TIMEOUT ];
        [alerttopost show];
        return;
    }
    
    NSDictionary * doc = [PostSession getDictionaryFromRequest];
    
    NSArray * arr = [doc allKeys];
    if ([arr containsObject:@"accessToken"]) {
        [GNLUserInfo setAccessToken:[doc objectForKey:@"accessToken"]];
        [GNLUserInfo setUserName:tf_username.text];
        [GNLUserInfo setUserID:tf_username.text];
        [GNLUserInfo setPhoneNumber:tf_username.text];
    
        NSDictionary * status = [doc objectForKey:@"status"];
//        NSString * flag = [status objectForKey:@"description"];
        
        if ([[status objectForKey:@"code"] isEqualToString: @"402"]) {
            jkAlertController * view = [[jkAlertController alloc]initWithOKButton:@"当前帐号登录时效已过期, 请重新登录"];
            [view show];
            [loadview close];
            return;
        }
        
        if ([[status objectForKey:@"code"] isEqualToString: @"201"]) {
            jkAlertController * view = [[jkAlertController alloc]initWithOKButton:@"连接服务器失败"];
            [view show];
            [loadview close];
            return;
        }
        
        if ([[status objectForKey:@"code"] isEqualToString: @"200"]) {
            [self sendcarpostSession];
            [self doSetUserInfo];
        }
        else {
            [loadview close];
            jkAlertController * view;
            if ([[status objectForKey:@"code"] isEqualToString:@"504"]) {
                view = [[jkAlertController alloc] initWithOKButton:@"账号名不存在\n请重新输入"];
            }
            if ([[status objectForKey:@"code"] isEqualToString:@"505"]) {
                view = [[jkAlertController alloc] initWithOKButton:@"密码错误\n请重新输入"];
            }
            [view show];
        }

    }
    
    if ([arr containsObject:@"vehicleInfo"]) {
        NSArray * arrayVehicle = [[PostSession getDictionaryFromRequest] objectForKey:@"vehicleInfo"];
        if (![arrayVehicle isEqual: nil] && [arrayVehicle count] != 0) {
            [GNLUserInfo setDefaultCarVin: [[arrayVehicle objectAtIndex:0] objectForKey:@"vin"]];
            [GNLUserInfo setDefaultCarLisence: [[arrayVehicle objectAtIndex:0] objectForKey:@"vehicleLisence"]];
            
            // go to mainwindow
            [loadview close];
            MainViewController * MainWindow = [[MainViewController alloc] init];
            MainNavigationController * mainNavigation = [[MainNavigationController alloc] initWithRootViewController:MainWindow];
            [mainNavigation setMainViewController:MainWindow];
            [self presentViewController:mainNavigation animated:YES completion:^{}];
        }
    }
}

// Actions
- (IBAction) doLogin:(id)sender {
    [GNLUserInfo setIsDemo: NO];
    [GNLUserInfo setDefaultCarType: tf_defaultcar.text];
    [GNLUserInfo selflogin];

    [self doCheckValueToLogin];
}

- (IBAction) doRunDemo:(id)sender {
    [GNLUserInfo setIsDemo: YES];
    [GNLUserInfo setDefaultCarType: tf_defaultcar.text];
    [GNLUserInfo selflogin];
    
    [self doCheckValueToLogin];
}

- (BOOL) doCheckUserInfoForLogin {
    if (tf_username.text == nil || [tf_username.text isEqualToString:@""]) {
        jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"请输入正确的用户名及密码"];
        [view show];
        return NO;
    }
    
    if (tf_password.text == nil || [tf_password.text isEqualToString:@""]) {
        jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"请输入正确的用户名及密码"];
        [view show];
        return NO;
    }
    return YES;
}

- (BOOL) doCheckExtendInfoForLogin {
    if (!is_protocol) {
        jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"请阅读并同意用户协议!"];
        [view show];
        return NO;
    }
    else return YES;
}

- (void) doCheckValueToLogin {
    if (tf_defaultcar.text == nil || [tf_defaultcar.text isEqualToString:@""]) {
        jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"请选择初始车型"];
        [view show];
//        view.okBlock = ^(){};
        return;
    }
    
    if ([m_arrkctypes containsObject:[GNLUserInfo defaultCarType]]) {
        loadview = [[jkAlertController alloc] initWithLoadingGif: @"正在连接服务器\n请稍候..."];
        [loadview show];
        if (![self doCheckUserInfoForLogin]) {
            [loadview close];
            return;
        }
        
        if (![self doCheckExtendInfoForLogin]) {
            [loadview close];
            return;
        }

        NSLog(@"Go To KC ..");
        m_kcview = [[KCViewController alloc]initWithControllerIDs:@[@(VIEWCONTROLLER_HALL), @(VIEWCONTROLLER_VEHICLECONTROL),@(VIEWCONTROLLER_DIAGNOSIS),@(VIEWCONTROLLER_USERMANAGEMENT)]];
        m_kcview.delegate = self;
        // @"1569586355" @"596747"
        m_kcview.username = tf_username.text;
        m_kcview.password = tf_password.text;

        nodeRoot = [[NodeRoot alloc] init];
        nodeRoot.window = [UIApplication sharedApplication].keyWindow;
        nodeRoot.rootViewController = (RootViewController*)m_kcview;
        ((RootViewController*)nodeRoot.rootViewController).parentNode = nodeRoot;
        [nodeRoot createChildNode];
        
        [m_kcview douserlogin];
    }
    else {
        if ([GNLUserInfo isDemo]) {
//            if (![self doCheckExtendInfoForLogin]) return;
            [self sendPostSession];
        }
        else {
            if (![self doCheckUserInfoForLogin]) return;
            if (![self doCheckExtendInfoForLogin]) return;
            [self sendPostSession];
        }
    }
}

// KC 登录验证
- (void)doKCLoginActions:(NSInteger) flag {
    
    if (flag == 1) {
        [self doSetUserInfo];
        [self presentViewController:m_kcview animated:YES completion:^{}];
    }
    else if (flag == 0) {
        jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"连接服务器失败"];
        [view show];
    }
    else if (flag == -1) {
        jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"请输入正确的用户名及密码"];
        [view show];
    }
    [loadview close];
}

- (IBAction) doExchangeFlagInpassword:(id)sender {
    if (is_savepassword) {
        is_savepassword = NO;
        [bt_savepassword setImage:[UIImage imageNamed:@"login_unselected"] forState:UIControlStateNormal];
        is_autologin = NO;
        [bt_autologin setImage:[UIImage imageNamed:@"login_unselected"] forState:UIControlStateNormal];
    }
    else {
        is_savepassword = YES;
        [bt_savepassword setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
    }
//    [self doSetUserInfo];
}

- (IBAction) doExchangeFlagInautologin:(id)sender {
    if (is_autologin) {
        is_autologin = NO;
        [bt_autologin setImage:[UIImage imageNamed:@"login_unselected"] forState:UIControlStateNormal];
    }
    else {
        is_autologin = YES;
        [bt_autologin setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
        is_savepassword = YES;
        [bt_savepassword setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
    }
//    [self doSetUserInfo];
}

- (IBAction) doExchangeFlagInprotocol:(id)sender {
    if (is_protocol) {
        is_protocol = NO;
        [bt_protocol setImage:[UIImage imageNamed:@"login_protol2"] forState:UIControlStateNormal];
//        jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"请阅读并同意用户协议。"];
//        [view show];
    }
    else {
        is_protocol = YES;
        [bt_protocol setImage:[UIImage imageNamed:@"login_protol1"] forState:UIControlStateNormal];
    }
//    [self doSetUserInfo];
}

- (IBAction) doChooseCarType:(id)sender {
    if (tv_vehicletype.isHidden) {
        [tv_vehicletype setHidden: NO];
    }
    else {
        [tv_vehicletype setHidden: YES];
    }
    [tv_vehicletype reloadData];
}

- (IBAction) doEnterProtocol:(id)sender {
    NSLog(@"enter protocol ..");
    [self.navigationController pushViewController:m_protocolview animated:YES];
}

- (IBAction) doFindPassword:(id)sender {
    if (tf_defaultcar.text == nil || [tf_defaultcar.text isEqualToString:@""]) {
        jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"请选择初始车型"];
        [view show];
        return;
    }
    
    if ([m_arrkctypes containsObject:tf_defaultcar.text]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://gnetlink.geely.com/jsp/password/passwordIndex.jsp"]];
    }
    else {
        PasswordIdentifierViewController * view = [[PasswordIdentifierViewController alloc] init];
        [self.navigationController pushViewController: view animated:YES];
    }
}

// load location messages
- (void) doSetUserInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //登陆成功后把用户名和密码存储到UserDefault
    if (is_savepassword) {
        [userDefaults setObject: tf_username.text forKey:@"UserNameFromGNetLink"];
        [userDefaults setObject: tf_password.text forKey:@"PassWordFromGNetLink"];
        [userDefaults setObject:@"1" forKey:@"SavePassFromGNetLink"];
    }
    else {
        [userDefaults removeObjectForKey:@"UserNameFromGNetLink"];
        [userDefaults removeObjectForKey:@"PassWordFromGNetLink"];
        [userDefaults removeObjectForKey:@"SavePassFromGNetLink"];
    }
    NSLog(@"** save password - %d", is_savepassword);
    
    if (is_autologin) {
        [userDefaults setObject: @"1" forKey:@"AutoLoginFromGNetLink"];
    }
    else {
        [userDefaults removeObjectForKey:@"AutoLoginFromGNetLink"];
    }
    NSLog(@"** auto login - %d", is_autologin);
    
    if (is_protocol) {
        [userDefaults setObject: @"1" forKey:@"ReadProtocolFromGNetLink"];
    }
    else {
        [userDefaults removeObjectForKey:@"ReadProtocolFromGNetLink"];
    }
    NSLog(@"** agree protocol - %d", is_protocol);
    
    if (![tf_defaultcar.text isEqualToString:@""] && tf_defaultcar.text != nil) {
        [userDefaults setObject: tf_defaultcar.text forKey:@"DefaultCarFromGNetLink"];
    }
    else {
        [userDefaults removeObjectForKey:@"DefaultCarFromGNetLink"];
    }
    NSLog(@"** default car type - %@", tf_defaultcar.text);
    
    //
    if (![tf_username.text isEqualToString:@""] && tf_username.text != nil) {
        [userDefaults setObject: tf_username.text forKey:@"UserNameFromGNetLink"];
    }
    else {
        [userDefaults removeObjectForKey:@"UserNameFromGNetLink"];
    }

    [userDefaults synchronize];
}

- (void) doLoadUserInfo {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString * username = [userDefault objectForKey:@"UserNameFromGNetLink"];
    NSString * password = [userDefault objectForKey:@"PassWordFromGNetLink"];
    NSString * defaultcar = [userDefault objectForKey:@"DefaultCarFromGNetLink"];
    NSString * flag = [userDefault objectForKey:@"AutoLoginFromGNetLink"];
    NSString * protocol = [userDefault objectForKey: @"ReadProtocolFromGNetLink"];
    NSString * savepass = [userDefault objectForKey:@"SavePassFromGNetLink"];
    
    NSInteger res = 0;
    if (![username isEqualToString:@""] && username != nil) {
        [tf_username setText: username];
        res += 1;
    }
    
    if (![password isEqualToString:@""] && password != nil) {
        [tf_password setText: password];
        res += 1;
    }
    
    if (![defaultcar isEqualToString:@""] && defaultcar != nil) {
        [tf_defaultcar setText: defaultcar];
    }
    
    if (![protocol isEqualToString:@""] && protocol != nil) {
        if ([protocol isEqualToString:@"1"]) {
            is_protocol = YES;
            [bt_protocol setImage:[UIImage imageNamed:@"login_protol1"] forState:UIControlStateNormal];
        }
        else {
            is_protocol = NO;
            [bt_protocol setImage:[UIImage imageNamed:@"login_protol2"] forState:UIControlStateNormal];
        }
    }
    
    if (![savepass isEqualToString:@""] && savepass != nil) {
        if ([savepass isEqualToString:@"1"]) {
            is_savepassword = YES;
            [bt_savepassword setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
        }
        else {
            is_savepassword = NO;
            [bt_savepassword setImage:[UIImage imageNamed:@"login_unselected"] forState:UIControlStateNormal];
        }
    }
    
    if (![flag isEqualToString:@""] && flag != nil) {
        if ([flag isEqualToString:@"1"]) {
            is_autologin = YES;
            [bt_autologin setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
        }
        else {
            is_autologin = NO;
            [bt_autologin setImage:[UIImage imageNamed:@"login_unselected"] forState:UIControlStateNormal];
        }
    }
    
    if (is_autologin && [GNLUserInfo isGoOut]) [self doLogin:self];
}

// 隐藏键盘.
- (IBAction) textfield_didEdit:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction) textfield_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    // 点击页面后隐藏车辆类型列表
    if (![tv_vehicletype isHidden]) [tv_vehicletype setHidden:YES];
}

// 修改用户名时 清空密码
- (IBAction) textfilef_didchange:(id)sender {
    [tf_password setText:@""];
}

// tableview load
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_arrvehicletype count];
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
//    NSString * item = [m_arrvehicletype objectAtIndex: indexPath.row];
//    if ([item isEqualToString:@"博越"]) {
//        cell.textLabel.text = [NSString stringWithFormat:@"%@内部测试体验版",[m_arrvehicletype objectAtIndex: indexPath.row]];
//    }
//    else {
        cell.textLabel.text = [m_arrvehicletype objectAtIndex: indexPath.row];
//    }
    
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [GNLUserInfo setDefaultCarType: [m_arrvehicletype objectAtIndex:indexPath.row]];
    [tf_defaultcar setText: [m_arrvehicletype objectAtIndex: indexPath.row]];
    
    if ([m_arrkctypes containsObject:[GNLUserInfo defaultCarType]]) {
        [bt_xshowmodel setHidden:YES];
    }
    else {
        [bt_xshowmodel setHidden:NO];
    }
    
    [tv_vehicletype setHidden:YES];
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
