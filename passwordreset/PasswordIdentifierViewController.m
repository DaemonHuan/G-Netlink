//
//  PasswordIdentifierViewController.m
//  G-Netlink-beta0.2
//
//  Created by jk on 10/29/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "PasswordIdentifierViewController.h"
#import "PasswordResetViewController.h"
#import "GetPostSessionData.h"

#import "public.h"
#import "jkAlertController.h"
#import "SCGIFImageView.h"

#import "jkProcessView.h"

@interface PasswordIdentifierViewController () <PostSessionDataDelegate> {
    GetPostSessionData * getPostSession;
    IBOutlet UITextField * tf_phonenum;
    IBOutlet UITextField * tf_identifycode;
    
    IBOutlet UIView * vi_status;
    IBOutlet UILabel * la_status;
    
    NSString * accessTokenForIdentify;
    NSString * telePhoneNum;
    NSString * identifyCode;
    jkProcessView * m_processview;
}

@end

@implementation PasswordIdentifierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    [self.navigationItem setTitle:@"修改密码"];
    
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_return"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftitem setTintColor: [UIColor whiteColor]];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submitOK)];
    [rightitem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftitem;
    self.navigationItem.rightBarButtonItem = rightitem;

   
    getPostSession = [[GetPostSessionData alloc]init];
    getPostSession.delegate = self;
    
    UIColor *color = [UIColor colorWithWhite:1.0f alpha:1.0f];
    tf_phonenum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: color}];
    tf_identifycode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: color}];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"runline.gif" ofType:nil];
    SCGIFImageView * gifImageView = [[SCGIFImageView alloc] initWithGIFFile:filePath];
    gifImageView.frame = CGRectMake(40.0f, 100.0f, CGRectGetWidth([UIScreen mainScreen].bounds) - 200.0f, 30.0f);
    vi_status.layer.cornerRadius = 5.0f;
    [vi_status addSubview: gifImageView];
    [vi_status setHidden: YES];
    [la_status setText:@""];
    [la_status setTextColor: [UIColor whiteColor]];
    [la_status setFont: [UIFont fontWithName:FONT_MM size:18.0f]];
    
    m_processview = [[jkProcessView alloc]initWithMessage:@""];
    [m_processview tohide];
    [self.view addSubview:m_processview];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitOK {
    // telephone check
    [self textfield_TouchDown:self];
    NSString * telnum = tf_phonenum.text;
    if ([telnum isEqualToString:@""] || telnum == nil) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"手机号码不能为空，请输入正确手机号码"];
        [alert show];
        return;
    }
    else if (![self isMobileNumber:telnum]) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"请输入正确手机号码"];
        [alert show];
        return;
    }
    [m_processview setTitile:@""];
    [m_processview toshow];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 同步 POST 请求 username
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/checkIdentifyCode", HTTP_GET_POST_ADDRESS]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
        //设置请求方式为POST
        [request setHTTPMethod:@"POST"];
        // 设置参数
        NSString * body = [NSString stringWithFormat:@"phone=%@&code=%@&accessToken=%@", tf_phonenum.text, tf_identifycode.text, accessTokenForIdentify];
        NSData * data = [body dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: nil];
        
        if ([[[dic objectForKey:@"status"]objectForKey:@"code"] isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                PasswordResetViewController * view = [[PasswordResetViewController alloc]init];
                [view setIdentifyValue:tf_phonenum.text token:accessTokenForIdentify];
                [self.navigationController pushViewController:view animated:YES];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_processview tohide];
                jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"验证码错误，请重新获取"];
                [alert show];
            });
        }
    });
}

- (IBAction) getIdentify:(id)sender {
//    NSLog(@"getIdentify ..");
    // telephone check
    [self textfield_TouchDown:self];
    NSString * telnum = tf_phonenum.text;
    if ([telnum isEqualToString:@""] || telnum == nil) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"手机号码不能为空，请输入正确手机号码"];
        [alert show];
        return;
    }
    else if (![self isMobileNumber:telnum]) {
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"请输入正确手机号码"];
        [alert show];
        return;
    }
    
    [vi_status setHidden: NO];
    [la_status setText:@"正在获取验证码"];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/getIdentifyCode", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"phone=%@", tf_phonenum.text];
    [getPostSession SendPostSessionRequest:url Body:body];
//    NSLog(@"%@ %@", url, body);
}

- (void) didPostSessionRequest:(NSString *)request {
    NSLog(@"%@", request);
    [vi_status setHidden:YES];
    NSDictionary * dic = [getPostSession getDictionaryFromRequest];
    if ([request isEqualToString:@"error"]) {
        NSLog(@"network error .. in PasswordIdentifyView");
        
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:NETWORK_ERROR];
        [alert show];
        return;
    }
    
    if ([[[dic objectForKey:@"status"]objectForKey:@"code"] isEqualToString:@"200"]) {
        accessTokenForIdentify = [dic objectForKey:@"accessToken"];
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"获取验证码成功，请查收"];
        [alert show];
        return;
    }
    
    if ([[[dic objectForKey:@"status"]objectForKey:@"code"] isEqualToString:@"504"]) {
        accessTokenForIdentify = [dic objectForKey:@"accessToken"];
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"此手机无对应账号"];
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

// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
/**
 * 大陆地区固话及小灵通
 * 区号：010,020,021,022,023,024,025,027,028,029
 * 号码：七位或八位
 */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
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
