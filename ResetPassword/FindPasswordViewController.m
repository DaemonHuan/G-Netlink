//
//  FindPasswordViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "ResetPasswordViewController.h"
#import "public.h"

#define IDENTIFY_ENABLED_TIME 60.0f

@interface FindPasswordViewController () <PostSessionDataDelegate>

@end

@implementation FindPasswordViewController {
    GetPostSessionData * postSession;
    IBOutlet UITextField * tf_phonenum;
    IBOutlet UITextField * tf_identifycode;
    IBOutlet UILabel * la_identifycode;
    
    IBOutlet UIButton * bt_getIdentifyCode;
    
    ProcessBoxView * m_loadingview;
    
    NSString * accessTokenForIdentify;
    NSString * telePhoneNum;
    NSString * identifyCode;
    
    NSTimer * m_timer;
    NSDate * m_startTime;
}

@synthesize userType, userKCFlag;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    
    
    if (self.userKCFlag == 1) {
        [self.navigationItem setTitle:@"找回密码"];
    }
    else {
        [self.navigationItem setTitle:@"修改密码"];
    }
    
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_return"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftitem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftitem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submitOK)];
    [rightitem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftitem;
    self.navigationItem.rightBarButtonItem = rightitem;
    
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
    
    m_loadingview = [[ProcessBoxView alloc]initWithMessage: @""];
    [self.view addSubview:m_loadingview];
    [m_loadingview hideView];
    
    UIColor *color = [UIColor colorWithWhite:1.0f alpha:1.0f];
    tf_phonenum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入登录手机号" attributes:@{NSForegroundColorAttributeName: color}];
    tf_identifycode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: color}];
    
    if (![self.telPhone isEqualToString:@""] || self.telPhone == nil) {
        [tf_phonenum setText:self.telPhone];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)submitOK {
    // telephone check
    [self textfield_TouchDown:self];
    NSString * telnum = tf_phonenum.text;
    if ([telnum isEqualToString:@""] || telnum == nil) {
        AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"手机号码不能为空，请输入正确手机号码。"];
        [alert show];
        return;
    }
    else if (![ExtendStaticFunctions isMobileNumber:telnum]) {
        AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"请输入正确手机号码。"];
        [alert show];
        return;
    }
    
    NSString * code = tf_identifycode.text;
    
    if ([code isEqualToString:@""] || code == nil) {
        AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"验证码为空,请重新出入。"];
        [alert show];
        return;
    }
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    code = [[code componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    if (![code isEqualToString:@""]) {
        AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"验证码有误,请重新出入。"];
        [alert show];
        return;
    }

    if (self.userType == 0) {
        [m_loadingview setTitile:@"正在核对验证码 .."];
        [m_loadingview showView];
        
        NSString * url = [NSString stringWithFormat:@"%@/api/checkIdentifyCode", HTTP_GET_POST_ADDRESS];
        NSString * body = [NSString stringWithFormat:@"phone=%@&code=%@&accessToken=%@", tf_phonenum.text, tf_identifycode.text, accessTokenForIdentify];
        [postSession SendPostSessionRequest:url Body:body];
    }
    else {
        identifyCode = tf_identifycode.text;
        ResetPasswordViewController * view = [[ResetPasswordViewController alloc]init];
        view.userBrandId = @"KC";
        [view setIdentifyValue:tf_phonenum.text token:identifyCode];
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (IBAction) getIdentify:(id)sender {
    // telephone check
    [self textfield_TouchDown:self];
    NSString * telnum = tf_phonenum.text;
    if ([telnum isEqualToString:@""] || telnum == nil) {
        AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"手机号码不能为空，请输入正确手机号码。"];
        [alert show];
        return;
    }
    else if (![ExtendStaticFunctions isMobileNumber:telnum]) {
        AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"请输入正确手机号码。"];
        [alert show];
        return;
    }
    else {
        [m_loadingview setTitile:@"正在获取验证码 .."];
        [m_loadingview showView];
        
//        NSString * url = [NSString stringWithFormat:@"%@/api/getIdentifyCode", HTTP_GET_POST_ADDRESS];
//        NSString * body = [NSString stringWithFormat:@"phone=%@&brandId=3", tf_phonenum.text];
//        [postSession SendPostSessionRequest:url Body:body];
        
        if (self.userType == 0) {
            NSString * url = [NSString stringWithFormat:@"%@/api/getIdentifyCode", HTTP_GET_POST_ADDRESS];
            NSString * body = [NSString stringWithFormat:@"phone=%@&brandId=%@", tf_phonenum.text, self.userBrandId];
            [postSession SendPostSessionRequest:url Body:body];
        }
        else {
            NSString * url = [NSString stringWithFormat:@"%@/system/user/GetResetPwdVerifyCode", HTTP_GET_POST_ADDRESS_KC];
//            NSString * body = [NSString stringWithFormat:@"mobilenumber=%@", tf_phonenum.text];
            NSMutableDictionary * body = [[NSMutableDictionary alloc] init];
            [body setObject: tf_phonenum.text forKey:@"mobilenumber"];
            [postSession SendPostSessionRequestForKC:url Body:body];
        }
        
        m_startTime = [NSDate date];    // 开始时间
        m_timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(doTimerSet) userInfo:nil repeats:YES];
        [m_timer fire];
        
        [bt_getIdentifyCode setHidden:YES];
    }
}

- (void) doTimerSet {
    CGFloat timeSpace = [m_startTime timeIntervalSinceNow];
    
    if (IDENTIFY_ENABLED_TIME + timeSpace < 0.0f) {
        [m_timer invalidate];
        [bt_getIdentifyCode setHidden:NO];
    }
    else {
        [la_identifycode setText:[NSString stringWithFormat:@"%zd 秒", (NSInteger)(IDENTIFY_ENABLED_TIME + timeSpace)]];
    }
}

- (void) didPostSessionRequest:(NSString *)request {
    if ([request isEqualToString:@"NSURLErrorNetworkConnectionLost"]) {
        [m_loadingview hideView];
        
        // 网络问题，重新获取
        [m_timer invalidate];
        [bt_getIdentifyCode setHidden:NO];
        
        return;
    }
    
    if ([request isEqualToString:@"jk-Error"]) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:NETWORK_ERROR];
        [alertview show];
        
        [m_loadingview hideView];
        
        // 网络问题，重新获取
        [m_timer invalidate];
        [bt_getIdentifyCode setHidden:NO];
        return;
    }
    
    [m_loadingview hideView];
    
    NSString * code = nil;
    NSDictionary * mdic = [postSession getDictionaryFromRequest];
    if ([[mdic allKeys] containsObject:@"customerName"] &&
        [[mdic allKeys] count] == 5) {
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            accessTokenForIdentify = [mdic objectForKey:@"accessToken"];
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"获取验证码成功, 请查收。"];
            [alertview show];
            return;
        }
        else if ([code isEqualToString:@"504"]) {
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"此手机无对应账号。"];
            alertview.okBlock = ^(){
                [m_timer invalidate];
                [bt_getIdentifyCode setHidden:NO];
            };
            [alertview show];
            return;
        }
        else { // code = 500
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"服务器出错,请重新获取。"];
            alertview.okBlock = ^(){
                [m_timer invalidate];
                [bt_getIdentifyCode setHidden:NO];
            };
            [alertview show];
            return;
        }
    }
    
    if ([[mdic allKeys] count] == 1 && [[mdic allKeys] containsObject:@"status"]) {
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];

        if ([code isEqualToString:@"200"]) {
            ResetPasswordViewController * view = [[ResetPasswordViewController alloc]init];
            view.userBrandId = self.userBrandId;
            [view setIdentifyValue:tf_phonenum.text token:accessTokenForIdentify];
            [self.navigationController pushViewController:view animated:YES];
            return;
        }
        else {
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"验证码错误，请重新获取。"];
            [alertview show];
            return;
        }
    }
    
    if ([[mdic allKeys] containsObject:@"errcode"] &&
        [[mdic allKeys] containsObject:@"errmsg"]) {
        code = [[mdic objectForKey:@"errcode"] stringValue];
        
        if ([code isEqualToString:@"0"]) {
//            identifyCode = [mdic objectForKey:@"data"];
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"获取验证码成功, 请查收。"];
            [alertview show];
        }
        else {
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[mdic objectForKey:@"errmsg"]];
            alertview.okBlock = ^(){
                [m_timer invalidate];
                [bt_getIdentifyCode setHidden:NO];
            };
            [alertview show];
            return;
        }
    }
}

- (IBAction) textfield_didEdit:(id)sender {
    // 隐藏键盘.
    [sender resignFirstResponder];
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
