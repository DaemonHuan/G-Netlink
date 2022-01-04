//
//  PasswordReset2ViewController.m
//  G-NetLink-v1.0
//
//  Created by jk on 2/22/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "PasswordReset2ViewController.h"
#import "GetPostSessionData.h"

#import "public.h"
#import "jkAlertController.h"
#import "GNLUserInfo.h"
#import "MainNavigationController.h"

#import "jkProcessView.h"

@interface PasswordReset2ViewController () <PostSessionDataDelegate> {
    IBOutlet UITextField * tf_oldpa;
    IBOutlet UITextField * tf_newpa;
    IBOutlet UITextField * tf_identifyPassword;
    
    GetPostSessionData * PostSession;
    jkProcessView * m_processview;
}

@end

@implementation PasswordReset2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_return"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftitem setTintColor: [UIColor whiteColor]];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(doResetPassword)];
    [rightitem setTintColor: [UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightitem;
    self.navigationItem.leftBarButtonItem = leftitem;
    [self.navigationItem setTitle:@"修改密码"];
    
    UIColor *color = [UIColor colorWithWhite:1.0f alpha:1.0f];
    tf_oldpa.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入旧密码" attributes:@{NSForegroundColorAttributeName: color}];
    tf_newpa.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName: color}];
    tf_identifyPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请确认新密码" attributes:@{NSForegroundColorAttributeName: color}];
    
    PostSession = [[GetPostSessionData alloc]init];
    PostSession.delegate = self;
    
    m_processview = [[jkProcessView alloc]initWithMessage:@""];
    [m_processview tohide];
    [self.view addSubview:m_processview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doResetPassword {
    [self textfield_TouchDown:self];
    if ([tf_oldpa.text isEqualToString:@""] || tf_oldpa.text == nil) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"旧密码不能为空，请重新输入"];
        [alert show];
        return;
    }
    
    if ([tf_newpa.text isEqualToString:@""] || tf_newpa.text == nil) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"新密码不能为空，请重新输入"];
        [alert show];
        return;
    }
    
    if (![tf_newpa.text isEqualToString:tf_identifyPassword.text]) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"新密码输入不同，请重新输入"];
        [alert show];
        return;
    }
    
    [m_processview setTitile:@"正在连接服务器\n请稍后..."];
    [m_processview toshow];

    NSString * url = [NSString stringWithFormat:@"%@/api/updatePassword", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&oldPassword=%@&password=%@", [GNLUserInfo accessToken], tf_oldpa.text, tf_newpa.text];
    [PostSession SendPostSessionRequest:url Body:body];
    NSLog(@"PassWord Reset Send .. %@", body);
}

- (void) didPostSessionRequest:(NSString *)request {
    NSLog(@"PassWord Reset Request .. %@", request);
    if (request == nil || [request isEqualToString: @""]) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:DATA_ERROR];
        [alert show];
        [m_processview tohide];
        return;
    }
    
    [m_processview tohide];
    NSDictionary * dic = [PostSession getDictionaryFromRequest];
    NSString * code = [[dic objectForKey:@"status"]objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"密码修改成功"];
        [alert show];
        return;
    }
    else if ([code isEqualToString:@"402"]) {
        MainNavigationController * ctl = (MainNavigationController *) self.navigationController;
        [ctl turntoLoginForOut];
        return;
    }
    else if ([code isEqualToString:@"400"]) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"旧密码错误，请重新输入"];
        [alert show];
        return;
    }
    else {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"修改密码失败，请重新操作"];
        [alert show];
        return;
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
