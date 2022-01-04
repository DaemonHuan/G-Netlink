//
//  PasswordResetViewController.m
//  G-Netlink-beta0.2
//
//  Created by jk on 10/29/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "PasswordResetViewController.h"
#import "GetPostSessionData.h"
#import "public.h"
#import "jkAlertController.h"
#import "jkProcessView.h"

@interface PasswordResetViewController () <PostSessionDataDelegate> {
    GetPostSessionData * postSession;
    
    NSString * userName;
    NSString * accessToken;
    
//    IBOutlet UITextField * tf_username;
    IBOutlet UITextField * tf_code_new;
    IBOutlet UITextField * tf_code_cpy;
    
    jkProcessView * m_processview;
}


@end

@implementation PasswordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_return"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftitem setTintColor: [UIColor whiteColor]];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didReset)];
    [rightitem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftitem;
    self.navigationItem.rightBarButtonItem = rightitem;
    [self.navigationItem setTitle:@"修改密码"];

    
//    [tf_username setText:userName];
    
    UIColor *color = [UIColor colorWithWhite:1.0f alpha:1.0f];
//    tf_username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:@{NSForegroundColorAttributeName: color}];
    tf_code_new.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName: color}];
    tf_code_cpy.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请重新输入新密码" attributes:@{NSForegroundColorAttributeName: color}];
    
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
    
    m_processview = [[jkProcessView alloc]initWithMessage:@""];
    [m_processview tohide];
    [self.view addSubview:m_processview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setIdentifyValue:(NSString *)name token:(NSString *)token {
    userName = name;
    accessToken = token;
    
}

- (void)didReset {
    [self textfield_TouchDown:self];
    if ([tf_code_new.text isEqualToString:@""] || tf_code_new.text == nil) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"新密码不能为空，请重新输入"];
        [alert show];
        return;
    }
    
    if (![tf_code_new.text isEqualToString:tf_code_cpy.text]) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"新密码输入不同，请重新输入"];
        [alert show];
        return;
    }
    
    [m_processview setTitile:@"正在连接服务器\n请稍后..."];
    [m_processview toshow];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/getBackPassword", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"loginName=%@&password=%@&accessToken=%@", userName, tf_code_new.text, accessToken];
    [postSession SendPostSessionRequest:url Body:body];
//
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
    NSLog(@"%@", request);
    if (request == nil || [request isEqualToString: @""]) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:DATA_ERROR];
        [alert show];
        [m_processview tohide];
        return;
    }
    
    [m_processview tohide];
    NSDictionary * dicdata = [postSession getDictionaryFromRequest];
    if ([[[dicdata objectForKey:@"status"] objectForKey:@"code"] isEqualToString:@"200"]) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"用户密码修改成功"];
        
        alert.okBlock = ^() {
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
        [alert show];
    }
    else {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"用户密码修改失败"];
        [alert show];
    }
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
