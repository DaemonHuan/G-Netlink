//
//  ResetPasswordViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "public.h"

@interface ResetPasswordViewController () <PostSessionDataDelegate>

@end

@implementation ResetPasswordViewController  {
    GetPostSessionData * postSession;
    
    NSString * userName;
    NSString * accessToken;

    IBOutlet UITextField * tf_code_new;
    IBOutlet UITextField * tf_code_cpy;
    
    ProcessBoxView * m_loadingview;
}

- (void)viewDidLoad { // 13371227641 
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    [self.navigationItem setTitle:@"修改密码"];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIColor *color = [UIColor colorWithWhite:1.0f alpha:1.0f];
    tf_code_new.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName: color}];
    tf_code_cpy.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请重新输入新密码" attributes:@{NSForegroundColorAttributeName: color}];
    
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
    
    m_loadingview = [[ProcessBoxView alloc]initWithMessage: @""];
    [self.view addSubview:m_loadingview];
    [m_loadingview hideView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void) setIdentifyValue:(NSString *)name token:(NSString *)token {
    userName = name;
    accessToken = token;
}

- (IBAction) didReset:(id)sender {
    [self textfield_TouchDown:self];

    [m_loadingview setTitile:@"正在连接服务器\n请稍后 .."];
    [m_loadingview showView];
    
    if ([self.userBrandId isEqualToString:@"KC"]) {
        NSString * url = [NSString stringWithFormat:@"%@/system/user/ResetPwd", HTTP_GET_POST_ADDRESS_KC];
        NSMutableDictionary * body = [[NSMutableDictionary alloc] init];
        [body setObject: userName forKey:@"mobilenumber"];
        [body setObject: tf_code_new.text forKey:@"password"];
        [body setObject: accessToken forKey:@"verify_code"];
        [postSession SendPostSessionRequestForKC:url Body:body];
    }
    else {
        NSString * url = [NSString stringWithFormat:@"%@/api/getBackPassword", HTTP_GET_POST_ADDRESS];
        NSString * body = [NSString stringWithFormat:@"loginName=%@&password=%@&accessToken=%@&brandId=%@", userName, tf_code_new.text, accessToken, self.userBrandId];
        [postSession SendPostSessionRequest:url Body:body];
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
    
    [m_loadingview hideView];
    
    NSString * code = nil;
    NSDictionary * mdic = [postSession getDictionaryFromRequest];
    code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
    if ([[mdic allKeys] containsObject:@"status"]) {
        if ([code isEqualToString:@"200"]) {
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"用户密码修改成功。"];
            alertview.okBlock = ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            [alertview show];
        }
        else { // code = 500
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"用户密码修改失败。"];
            [alertview show];
        }
    }
    
    if ([[mdic allKeys] containsObject:@"errcode"] &&
        [[mdic allKeys] containsObject:@"errmsg"]) {
        code = [[mdic objectForKey:@"errcode"] stringValue];
        
        if ([code isEqualToString:@"0"]) {
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"用户密码修改成功。"];
            alertview.okBlock = ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            [alertview show];
        }
        else {
            AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"用户密码修改失败。"];
            [alertview show];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
