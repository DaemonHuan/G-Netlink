//
//  LoginViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/17/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "LoginViewController.h"
#import "public.h"

#import "IndexViewController.h"
#import "ICSDrawerController.h"
#import "SlideMenuViewController.h"
#import "MainNavigationController.h"
#import "ExtendStaticFunctions.h"
#import "ProtocolViewController.h"
#import "FindPasswordViewController.h"

#import "JPushNotification.h"

@interface LoginViewController () <PostSessionDataDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation LoginViewController {
    IBOutlet UITextField * tf_username;
    IBOutlet UITextField * tf_password;
    IBOutlet UITextField * tf_vehicletype;
    IBOutlet UIButton * bt_autologin;
    IBOutlet UIButton * bt_savepassword;
    IBOutlet UIButton * bt_xshowmodel;
    IBOutlet UIButton * bt_login;
    IBOutlet UIButton * bt_findpd;
    IBOutlet UIButton * bt_enterprotocol;
    IBOutlet UIButton * bt_protocol;
    IBOutlet UIButton * bt_displaylist;
    IBOutlet UITableView * tv_vehicletype;
    IBOutlet UILabel * la_protocol;
    IBOutlet UILabel * la_forgetpass;
    
    GetPostSessionData * postSession;
    ProcessBoxView * m_loadingview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_bg_h"]];

    //
    [self setCurrentViewControllerFlag: ViewsDiscriptionLogin];
    [tv_vehicletype setHidden:YES];
    [tv_vehicletype setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_bg_h"]]];
    [tv_vehicletype setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tv_vehicletype setSeparatorColor: [UIColor lightGrayColor]];
    
    m_loadingview = [[ProcessBoxView alloc]initWithMessage: @"正在连接服务器\n请稍候 .."];
    [self.view addSubview:m_loadingview];
    [m_loadingview hideView];
    
    //
    UIColor *color = [UIColor colorWithWhite:1.0f alpha:0.5f];
    tf_username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入账户" attributes:@{NSForegroundColorAttributeName: color}];
    tf_password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    tf_vehicletype.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择车型" attributes:@{NSForegroundColorAttributeName: color}];
    
    NSMutableAttributedString * asProtocol = [[NSMutableAttributedString alloc]initWithString:@"阅读并同意用户协议"];
    [asProtocol addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:WORD_COLOR_GLODEN] range:NSMakeRange(5,4)];
    [asProtocol addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(5, 4)];
    [la_protocol setAttributedText:asProtocol];
    NSMutableAttributedString * asforgot = [[NSMutableAttributedString alloc]initWithString:@"忘记密码？ 找回密码"];
    [asforgot addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString: WORD_COLOR_GLODEN] range:NSMakeRange(6,4)];
    [asforgot addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(6, 4)];
    [la_forgetpass setAttributedText:asforgot];
    
    // PostSession init
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
    
    // 默认选中用户协议
    [bt_protocol setImage:[UIImage imageNamed:@"login_protol_d"] forState:UIControlStateNormal];
    [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyConfirmProtocol Value:@"OK"];
    [bt_autologin setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
    [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyAutoLogin Value:@"OK"];
    [bt_savepassword setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
    [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeySaveUserKey Value:@"OK"];
    
    [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyRunStatus Value:@"OFFLINE"];
    
    [tf_vehicletype setText: @"博瑞"];
    [bt_xshowmodel setHidden: YES];
}

- (void) viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
//    [self clearDataForUser];
    
    if ([self.UserInfo gUserCurrentStatus] == UserStatusIsOffline) {
        [self doLoadUserInfo];
    }
    else if ([self.UserInfo gUserCurrentStatus] == UserStatusIsOtherline) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:@"402"]];
        [alertview show];
    }
    else if ([self.UserInfo gUserCurrentStatus] == UserStatusIsExitline) {
        
    }
}

- (NSString *) checkValueToLogin {
    NSString * res = nil;
    NSInteger flag = 0;
    if (![self.UserInfo isRunDemo]) {
        if (tf_username.text == nil || [tf_username.text isEqualToString:@""]) {
            res = [NSString stringWithFormat:@"请输入正确的用户名及密码"];
            flag = 1;
        }
        if (tf_password.text == nil || [tf_password.text isEqualToString:@""]) {
            res = [NSString stringWithFormat:@"请输入正确的用户名及密码"];
            flag = 1;
        }
    }

    if (tf_vehicletype.text == nil || [tf_vehicletype.text isEqualToString:@""]) {
        res = [NSString stringWithFormat:@"请选择初始车型"];
        flag = 1;
    }
    
    return res;
}

- (void) sendPostSessionForLogin {
    NSString * password = tf_password.text;
    NSString * username = tf_username.text;
    if ([self.UserInfo isRunDemo]) {
        password = @"707070";
        username = [self.UserInfo gTelePhoneNum];
    }
    
    NSString * url = [NSString stringWithFormat:@"%@/api/login", HTTP_GET_POST_ADDRESS];
    NSString * param = [NSString stringWithFormat:@"username=%@&password=%@&brandId=%@&isdemo=%@&ver=%@", username, password, [self.UserInfo gUserBrandID], [self.UserInfo isRunDemo] ? @"true" : @"false", NL_VERSION_CODE];
    [postSession SendPostSessionRequest:url Body:param];
}

- (void) sendPostSessionForLoginKC {
    [m_loadingview showView];
    NSString * password = tf_password.text;
    NSString * username = tf_username.text;
    
    NSString * url = [NSString stringWithFormat:@"%@/system/user/login", HTTP_GET_POST_ADDRESS_KC];
//    NSString * param = [NSString stringWithFormat:@"mobilenumber=%@&password=%@", username, password];
    // 15695863592 123456
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject: username forKey:@"mobilenumber"];
    [dict setObject: password forKey:@"password"];
    
    [postSession SendPostSessionRequestForKC:url Body:dict];
}

- (void) sendPostSessionForKCUserInfo {
    [m_loadingview showView];
    NSString * url = [NSString stringWithFormat:@"%@/system/user/query", HTTP_GET_POST_ADDRESS_KC];

    // 15695863592 123456
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
    [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
    [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
    [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
    
    [postSession SendPostSessionRequestForKC:url Body: [self fixDictionaryForKCSession:dict]];
}

- (void) sendPostSessionForVehicles {
    NSString * url = [NSString stringWithFormat:@"%@/api/getVehiclesOfUser", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&username=%@&isdemo=%@", [self.UserInfo gAccessToken], [self.UserInfo gTelePhoneNum], [self.UserInfo isRunDemo] ? @"true" : @"false"];
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    if ([request isEqualToString:@"NSURLErrorNetworkConnectionLost"]) {
        [m_loadingview hideView];
        return;
    }
    
    if ([request isEqualToString:@"jk-Error"]) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:NETWORK_ERROR];
        [alertview show];
        [m_loadingview hideView];
        return;
    }
    
//    BOOL flag = NO;
    NSDictionary * mdic = [postSession getDictionaryFromRequest];
    NSString * code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
    if ([[mdic allKeys] containsObject:@"accessToken"] && [[mdic allKeys] containsObject:@"status"]) {
        
        if ([code isEqualToString:@"200"]) {
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyAccessToken Value:[mdic objectForKey:@"accessToken"]];
            if (![self.UserInfo isRunDemo]){
                [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyTelePhoneNum Value:tf_username.text];
            }
            [self sendPostSessionForVehicles];
        }
        else if ([code isEqualToString:@"600"]) {
            // 用户续费验证
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"用户合同已过期，登录失败。"];
            alertview.okBlock = ^(){
                [m_loadingview hideView];
            };
            [alertview show];
        }
        else {
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
            alertview.okBlock = ^(){
                [m_loadingview hideView];
            };
            [alertview show];
        }
    }
    
    if ([[mdic allKeys] containsObject:@"vehicleInfo"] && [[mdic allKeys] containsObject:@"status"]) {
        
        [m_loadingview hideView];
        
        if ([code isEqualToString:@"200"]) {
            [self doSetUserInfo];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyDefaultVehicleType Value:tf_vehicletype.text];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyRunStatus Value:@"ONLINE"];

            // 默认车辆信息初始化
            [self setUserVehicles:[mdic objectForKey:@"vehicleInfo"]];

            // NL-3 用户开启行车轨迹开关，默认开启
            if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博越"]) {
                [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyMaplineFlag Value:@"ON"];
            }
            else {
                [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyMaplineFlag Value:@"OFF"];
            }

            // init main view
            IndexViewController * IndexView = [[IndexViewController alloc]init];
            MainNavigationController * mainNavgation = [[MainNavigationController alloc]initWithRootViewController:IndexView];
            SlideMenuViewController * slidemenu = [[SlideMenuViewController alloc]init];
            ICSDrawerController * drawerView = [[ICSDrawerController alloc]initWithLeftViewController:slidemenu centerViewController:mainNavgation];
            [self.navigationController presentViewController:drawerView animated:YES completion:^{}];
        }
        else {
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
            [alertview show];
        }
    }
    
    // KC
    if ([[mdic allKeys] containsObject:@"errmsg"] && [[mdic allKeys] containsObject:@"errcode"]) {
        code = [[mdic objectForKey:@"errcode"] stringValue];
        if ([code isEqualToString:@"0"] && [[mdic objectForKey:@"data"] count] == 3) {
            [self doSetUserInfo];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyAccessToken Value: [[mdic objectForKey:@"data"] objectForKey:@"access_token"]];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyTelePhoneNum Value:tf_username.text];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyKCTuid Value:[[mdic objectForKey:@"data"] objectForKey:@"tuid"]];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyKCUuid Value:[[mdic objectForKey:@"data"] objectForKey:@"uuid"]];
            
            [self sendPostSessionForKCUserInfo];
            
            //设置推送的对象为当前用户
            JPushNotification * jPush = (JPushNotification *)[JPushNotification sharePushNotification];
            [jPush registerUserTags:nil andAlias: tf_username.text callbackSelector:nil target:nil];
        }
        
        if ([code isEqualToString:@"0"] && [[mdic objectForKey:@"data"] count] == 14) {
            [self.UserInfo resetVehicleForUserList];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyUserName Value:[[mdic objectForKey:@"data"] objectForKey:@"realname"]];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyKCuTel Value:[[mdic objectForKey:@"data"] objectForKey:@"mobilephone"]];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyDefaultVehicleLisence Value:[[mdic objectForKey:@"data"] objectForKey:@"veh_no"]];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyDefaultVehicleLisence Value:[[mdic objectForKey:@"data"] objectForKey:@"veh_no"]];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyDefaultVehicleVin Value:[[mdic objectForKey:@"data"] objectForKey:@"frame_no"]];
            
            // 经销商信息
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyKCsName Value:[[mdic objectForKey:@"data"] objectForKey:@"sales_name"]];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyKCsAddr Value:[[mdic objectForKey:@"data"] objectForKey:@"sales_address"]];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyKCsTel Value:[[mdic objectForKey:@"data"] objectForKey:@"sales_phone"]];
            
            VehicleInformations * one = [[VehicleInformations alloc]init];
            one.vin = [[mdic objectForKey:@"data"] objectForKey:@"frame_no"];
            one.lisence = [[mdic objectForKey:@"data"] objectForKey:@"veh_no"];
            one.color = [[mdic objectForKey:@"data"] objectForKey:@"body_color"];
            one.type = [[mdic objectForKey:@"data"] objectForKey:@"vehicle_type"];
            
            [self.UserInfo addVehicleForUserList: one];

            //////////
            [m_loadingview hideView];
            
            IndexViewController * IndexView = [[IndexViewController alloc]init];
            MainNavigationController * mainNavgation = [[MainNavigationController alloc]initWithRootViewController:IndexView];
            SlideMenuViewController * slidemenu = [[SlideMenuViewController alloc]init];
            ICSDrawerController * drawerView = [[ICSDrawerController alloc]initWithLeftViewController:slidemenu centerViewController:mainNavgation];
            [self.navigationController presentViewController:drawerView animated:YES completion:^{}];
        }
        
        if (![code isEqualToString:@"0"]) {
            [m_loadingview hideView];
            NSString * str = [mdic objectForKey:@"errmsg"];
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:str];
            [alertview show];
        }
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*  登陆成功后把用户名和密码存储到 UserDefault  load location messages
    UserNameFromGNetLink 用户名  PassWordFromGNetLink 密码
    DefaultCarFromGNetLink 默认车型  AutoLoginFromGNetLink 自动登录
    SavePassFromGNetLink 保存密码  ReadProtocolFromGNetLink 用户协议  */
- (void) doSetUserInfo {
    [ExtendStaticFunctions doSetUserDefaults:tf_username.text withKey:@"UserNameFromGNetLink"];
    [ExtendStaticFunctions doSetUserDefaults: tf_vehicletype.text withKey:@"DefaultCarFromGNetLink"];

//    if ([self.UserInfo isConfirmProtocol]) {
//        [ExtendStaticFunctions doSetUserDefaults: @"1" withKey:@"ReadProtocolFromGNetLink"];
//    }
//    else {
//        [ExtendStaticFunctions doRemoveDefaultsWithKey:@"ReadProtocolFromGNetLink"];
//    }

    if ([self.UserInfo isSaveUserKey]) {
        [ExtendStaticFunctions doSetUserDefaults:tf_password.text withKey:@"PassWordFromGNetLink"];
    }
    else {
        [ExtendStaticFunctions doRemoveDefaultsWithKey:@"PassWordFromGNetLink"];
    }
    
    if ([self.UserInfo isAutoLogin]) {
        [ExtendStaticFunctions doSetUserDefaults: @"1" withKey:@"AutoLoginFromGNetLink"];
    }
    else {
        [ExtendStaticFunctions doSetUserDefaults: @"0" withKey:@"AutoLoginFromGNetLink"];
    }
    
    NSLog(@"** Set UserDefault: %@ %@ %d %d %d", tf_username.text, tf_vehicletype.text, [self.UserInfo isConfirmProtocol], [self.UserInfo isSaveUserKey], [self.UserInfo isAutoLogin]);
}

- (void) doLoadUserInfo {
    NSString * username = [ExtendStaticFunctions getUserDefaultsWithKey:@"UserNameFromGNetLink"];
    NSString * password = [ExtendStaticFunctions getUserDefaultsWithKey:@"PassWordFromGNetLink"];
    NSString * defaultcar = [ExtendStaticFunctions getUserDefaultsWithKey:@"DefaultCarFromGNetLink"];
    
    NSString * flag = [ExtendStaticFunctions getUserDefaultsWithKey:@"AutoLoginFromGNetLink"];
//    NSString * protocol = [ExtendStaticFunctions getUserDefaultsWithKey:@"ReadProtocolFromGNetLink"];
    
    if (![username isEqualToString:@""] && username != nil) {
        [tf_username setText: username];
    }
    
    if (![defaultcar isEqualToString:@""] && defaultcar != nil) {
        [tf_vehicletype setText: defaultcar];
        if ([defaultcar isEqualToString:@"博越"]) {
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyUserBrandID Value: @"5"];
        }
        else if ([defaultcar isEqualToString:@"帝豪GS"]) {
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyUserBrandID Value: @"6"];
        }
        else if ([defaultcar isEqualToString:@"帝豪GL"]) {
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyUserBrandID Value: @"8"];
        }

        [self changeVehicleTypes:self];     // 根据车型判断演示模式
    }
    
//    if ([protocol isEqualToString:@"1"]) {
//        [bt_protocol setImage:[UIImage imageNamed:@"login_protol_d"] forState:UIControlStateNormal];
//        [self.UserInfo doSetValueForUserInformationsWithKey:INformationsKeyConfirmProtocol Value:@"OK"];
//    }
//    else {
//        [bt_protocol setImage:[UIImage imageNamed:@"login_protol"] forState:UIControlStateNormal];
//        [self.UserInfo doSetValueForUserInformationsWithKey:INformationsKeyConfirmProtocol Value:@"NO"];
//    }
    
    if (![password isEqualToString:@""] && password != nil) {
        [tf_password setText: password];
        [bt_savepassword setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeySaveUserKey Value:@"OK"];
    }

    if ([flag isEqualToString:@"1"]) {
        [bt_autologin setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyAutoLogin Value:@"OK"];
        [self doLogin:self];
    }
    else if ([flag isEqualToString:@"0"]) {
        [bt_autologin setImage:[UIImage imageNamed:@"login_unselected"] forState:UIControlStateNormal];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyAutoLogin Value:@"NO"];
    }
    else {
        [bt_autologin setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyAutoLogin Value:@"OK"];
    }
    
    NSLog(@"** Set UserDefault: %@ %@ %d %d %d", tf_username.text, tf_vehicletype.text, [self.UserInfo isConfirmProtocol], [self.UserInfo isSaveUserKey], [self.UserInfo isAutoLogin]);
}

- (void) setUserVehicles:(NSArray *)vehicles {
    [self.UserInfo resetVehicleForUserList];
    
    if ([vehicles count] <= 0) return;
    
    for (NSDictionary * dic in vehicles) {
        VehicleInformations * one = [[VehicleInformations alloc]init];
        one.vin = [dic objectForKey:@"vin"];
        one.lisence = [dic objectForKey:@"vehicleLisence"];
        one.color = [dic objectForKey:@"vehicleColor"];
        one.type = [dic objectForKey:@"vehicleType"];
        [self.UserInfo addVehicleForUserList: one];

        //
        if ([dic objectForKey:@"vin"] != nil && ![[dic objectForKey:@"vin"] isEqualToString:@""]
            && [self.UserInfo gDefaultVehicleLisence] == nil) {
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyDefaultVehicleLisence Value:[dic objectForKey:@"vehicleLisence"]];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyDefaultVehicleVin Value:[dic objectForKey:@"vin"]];
        }
        
        if ([[dic objectForKey:@"vehicleType"] isEqualToString:[self.UserInfo gDefaultVehicleType]]) {
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyDefaultVehicleLisence Value:[dic objectForKey:@"vehicleLisence"]];
            [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyDefaultVehicleVin Value:[dic objectForKey:@"vin"]];
        }
    }
    
    NSDictionary * dic = [self.UserInfo gVehicleList];
    VehicleInformations * oldone = [dic objectForKey:[self.UserInfo gDefaultVehicleVin]];
    VehicleInformations * newone = [[VehicleInformations alloc]init];
    newone.vin = oldone.vin;
    newone.lisence = oldone.lisence;
    newone.color = oldone.color;
    newone.type = oldone.type;
    newone.isDefaultVehicle = YES;
    [self.UserInfo addVehicleForUserList: newone];
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

- (IBAction) doChooseCarType:(id)sender {
    if (tv_vehicletype.isHidden) [tv_vehicletype setHidden: NO];
    else [tv_vehicletype setHidden: YES];
    [tv_vehicletype reloadData];
}

- (IBAction) changeVehicleTypes:(id)sender {
    if ([tf_vehicletype.text isEqualToString:@"博瑞"]) {
        [bt_xshowmodel setHidden:YES];
    }
    else [bt_xshowmodel setHidden: NO];
}

- (IBAction) doExchangeFlagInpassword:(id)sender {
    if ([self.UserInfo isSaveUserKey]) {
        [bt_savepassword setImage:[UIImage imageNamed:@"login_unselected"] forState:UIControlStateNormal];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeySaveUserKey Value:@"NO"];
        [bt_autologin setImage:[UIImage imageNamed:@"login_unselected"] forState:UIControlStateNormal];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyAutoLogin Value:@"NO"];
    }
    else {
        [bt_savepassword setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeySaveUserKey Value:@"OK"];
    }
}

- (IBAction) doExchangeFlagInautologin:(id)sender {
    if ([self.UserInfo isAutoLogin]) {
        [bt_autologin setImage:[UIImage imageNamed:@"login_unselected"] forState:UIControlStateNormal];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyAutoLogin Value:@"NO"];
    }
    else {
        [bt_autologin setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyAutoLogin Value:@"OK"];
        [bt_savepassword setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeySaveUserKey Value:@"OK"];
    }
}

- (IBAction) doExchangeFlagInprotocol:(id)sender {
    if ([self.UserInfo isConfirmProtocol]) {
        [bt_protocol setImage:[UIImage imageNamed:@"login_protol"] forState:UIControlStateNormal];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyConfirmProtocol Value:@"NO"];
    }
    else {
        [bt_protocol setImage:[UIImage imageNamed:@"login_protol_d"] forState:UIControlStateNormal];
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyConfirmProtocol Value:@"OK"];
    }
}

- (IBAction) doEnterProtocol:(id)sender {
    ProtocolViewController * view = [[ProtocolViewController alloc]init];
    [self.navigationController pushViewController: view animated:YES];
}

- (IBAction) doFindPassword:(id)sender {
    
    if (tf_vehicletype.text == nil || [tf_vehicletype.text isEqualToString:@""]) {
        AlertBoxView * view = [[AlertBoxView alloc] initWithOKButton:@"请选择初始车型"];
        [view show];
        return;
    }
    
    FindPasswordViewController * view = [[FindPasswordViewController alloc]init];
    view.userKCFlag = 1;
    view.userBrandId = [self.UserInfo gUserBrandID];
    
    if ([tf_vehicletype.text isEqualToString:@"博瑞"]) {
        view.userType = 1;
    }
    else {
        view.userType = 0;
    }
    
    [self.navigationController pushViewController: view animated:YES];
}

// Actions
- (IBAction) doLogin:(id)sender {
    if (![self.UserInfo isConfirmProtocol]) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"请阅读并同意用户协议!"];
        [alertview show];
        return;
    }
    
    [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyRunMode Value:@"UNDEMO"];
    
    // 检查用户名 密码 被选车型
    NSString * res = [self checkValueToLogin];
    if (res != nil) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton: res];
        [alertview show];
        return;
    }

    [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyDefaultVehicleType Value: tf_vehicletype.text];
    if ([self.vehicletypesforKC containsObject:tf_vehicletype.text]) {
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyUserType Value:@"KC"];
        
        [self sendPostSessionForLoginKC];
    }
    else {
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyUserType Value:@"NL"];
        [self sendPostSessionForLogin];
    }

    [m_loadingview showView];
}

- (IBAction) doRunDemo:(id)sender {
    [self.UserInfo doSetValueForUserInformationsWithKey: InformationsKeyRunMode Value:@"DEMO"];
    [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyDefaultVehicleType Value: tf_vehicletype.text];
    [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyTelePhoneNum Value:@"10000000000"];
    
    NSString * res = [self checkValueToLogin];
    if (res != nil) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton: res];
        [alertview show];
        return;
    }
    
    if ([self.vehicletypesforKC containsObject:tf_vehicletype.text]) {
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyUserType Value:@"KC"];
        
        [self sendPostSessionForLoginKC];
    }
    else {
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyUserType Value:@"NL"];

        [self sendPostSessionForLogin];
    }
    
    [m_loadingview showView];
}

// 修改用户名时 清空密码
- (IBAction) textfilef_didchange:(id)sender {
    [tf_password setText:@""];
}

// tableview load
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.vehicletypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableViewForVehicleTypes";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text = [self.vehicletypes objectAtIndex: indexPath.row];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tf_vehicletype setText: [self.vehicletypes objectAtIndex: indexPath.row]];
    [tv_vehicletype setHidden:YES];
    
//    [self.UserInfo doSetValueForUserInformationsWithKey: InformationsKeyDefaultVehicleType Value:<#(NSString *)#>]
    
    if (indexPath.row == 0) {
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyUserBrandID Value:@"5"];
    }
    else if (indexPath.row == 1) {
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyUserBrandID Value:@"6"];
    }
    else if (indexPath.row == 2) {
        [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyUserBrandID Value:@"8"];
    }
    
    [self changeVehicleTypes:self];     // 根据车型判断演示模式
}

@end
