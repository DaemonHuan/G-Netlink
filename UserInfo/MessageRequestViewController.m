//
//  MessageRequestViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "MessageRequestViewController.h"
#import "public.h"

@interface MessageRequestViewController () <UITextViewDelegate, PostSessionDataDelegate>

@end

@implementation MessageRequestViewController {
    IBOutlet UILabel * la_cout;
    IBOutlet UITextView * tv_request;
    IBOutlet UITextField * tf_connections;
    
    NSInteger m_textcount;
    
    GetPostSessionData * postSession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if ([self.UserInfo isRunDemo]) {
        [self.view addSubview: [ExtendStaticView MarkDemoView]];
    }
    
    m_textcount = 500;
    
    [la_cout setText: [NSString stringWithFormat:@"剩余 %zd 字", m_textcount - tv_request.text.length]];
    
    tv_request.editable = YES;
    tv_request.delegate = self;
    
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
}

- (void) sendPostSessionForNL {
    NSString * url = [NSString stringWithFormat:@"%@/api/addSuggestion", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"phone=%@&suggestion=%@&username=%@", tf_connections.text, tv_request.text, [self.UserInfo gTelePhoneNum]];
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) sendPostSessionForKC {
    NSString * url = [NSString stringWithFormat:@"%@/system/feedbackinfo/add", HTTP_GET_POST_ADDRESS_KC];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
    [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
    [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
    [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
    NSMutableDictionary * info = [[NSMutableDictionary alloc]init];
    [info setObject:tv_request.text forKey:@"feedback_content"];
    [info setObject:tf_connections.text forKey:@"contact"];
    NSMutableDictionary * body = [[NSMutableDictionary alloc]init];
    [body setObject: dict forKey: @"ntspheader"];
    [body setObject: info forKey: @"feedbackInfo"];
    
    
    [postSession SendPostSessionRequestForKC: url Body:body];
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
    if ([mdic count] == 2) {
        code = [[mdic objectForKey:@"errcode"] stringValue];
    }
    else {
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
    }

    if ([code isEqualToString:@"200"] || [code isEqualToString:@"0"]) {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"提交成功!"];
        [alertview show];
    }
    else {
        AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:@"提交失败,请重试。"];
        [alertview show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView {
    [la_cout setText: [NSString stringWithFormat:@"剩余 %zd 字", m_textcount - tv_request.text.length]];
}

- (IBAction) doRequestCommit:(id)sender {
    [self textfield_TouchDown:self];
    
    NSString * tel = tf_connections.text;
    if ([tel isEqualToString:@""] || tel == nil) {
        AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"手机号码不能为空，请输入正确手机号码。"];
        [alert show];
        return;
    }
    else if (![ExtendStaticFunctions isMobileNumber:tel]) {
        AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"请输入正确手机号码。"];
        [alert show];
        return;
    }
    
    if ([self.UserInfo isKCUser]) [self sendPostSessionForKC];
    else [self sendPostSessionForNL];
}

// 隐藏键盘.
- (IBAction) textfield_didEdit:(id)sender {
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
