//
//  BasicViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/17/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "BasicViewController.h"
#import "HttpHead.h"
#import "JPushNotification.h"

#define POST_TIME_OUT 20.0f
#define IS_DEMOVIEW_HEIGHT 30.0f
#define IS_DEMOVIEW_TEXT @"模拟运行"

static UserInformations * UserInformation;
static ViewsManager * ViewsMan;
static NSString * CurrentViewName;

static NSArray * ArrayForVehicletypes;
static NSArray * ArrayForVehicletypesforKC;

@interface BasicViewController () <PushNotificationDelegate>
@end

@implementation BasicViewController

- (id) init {
    if (self = [super init]) {
        if (UserInformation == nil) {
            UserInformation = [[UserInformations alloc]init];
        }
        self.UserInfo = UserInformation;
        
        if (ArrayForVehicletypes == nil) {
            ArrayForVehicletypes = [[NSArray alloc]initWithObjects:@"博越", @"帝豪GS",@"帝豪GL", @"博瑞", nil];
        }
        self.vehicletypes = ArrayForVehicletypes;
        
        if (ArrayForVehicletypesforKC == nil) {
            ArrayForVehicletypesforKC = [[NSArray alloc]initWithObjects:@"博瑞", nil];
        }
        self.vehicletypesforKC = ArrayForVehicletypesforKC;
        
        if (ViewsMan == nil) {
            ViewsMan = [[ViewsManager alloc]init];
        }
        self.ViewsManager = ViewsMan;
        self.userfixstr = [NSString stringWithFormat:@"accessToken=%@&username=%@&isdemo=%@", [self.UserInfo gAccessToken], [self.UserInfo gTelePhoneNum], [self.UserInfo isRunDemo] ? @"true" : @"false"];
        
        [JPushNotification sharePushNotification].observer = self;
//        if ([self.UserInfo isKCUser]) {
//            [JPushNotification sharePushNotification].observer = self;
//        }
//        else {
//            [JPushNotification sharePushNotification].observer = nil;
//        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    MainNavigationController * mainNVController = (MainNavigationController *)self.navigationController;
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_menuicon"] style: UIBarButtonItemStylePlain target:mainNVController action:@selector(openDrawer:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    
    // demoLogoView init
    self.demoLogoView = [[UIView alloc]init];
    self.demoLogoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    CGFloat ax = [UIScreen mainScreen].bounds.size.height - IS_DEMOVIEW_HEIGHT;
    CGFloat wx = [UIScreen mainScreen].bounds.size.width;
    
    self.demoLogoView.frame = CGRectMake(0, ax, wx, IS_DEMOVIEW_HEIGHT);
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, wx, 2.0f)];
    [image setImage: [UIImage imageNamed:@"public_seperateline01"]];
    [self.demoLogoView addSubview: image];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(wx/2.0f - 45.0f, 5.0f, 70.0f, 20.0f)];
    [title setText: IS_DEMOVIEW_TEXT];
    [title setTextColor: [UIColor whiteColor]];
    [title setFont: [UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:17.0f]];
    [self.demoLogoView addSubview: title];
    
    //    UIImageView * imageup = [[UIImageView alloc] initWithFrame:CGRectMake(wx/2.0f + 35.0f, 10.0f, 15.0f, 10.0f)];
    //    [imageup setImage: [UIImage imageNamed:@"home_up"]];
    //    [thisView addSubview: imageup];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setCurrentViewControllerFlag:(ViewsDiscription)flag {
    [ViewsMan setCurrentViewDiscription:flag];
    self.thisflag = flag;
}

- (NSDictionary *) fetchPostSession:(NSString *)str Body:(NSString *)body {
    // 同步 POST 请求
    NSURL *url = [NSURL URLWithString: str];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
    //设置请求方式为POST
    [request setHTTPMethod:@"POST"];
    
    // 设置参数
    NSData * data = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: &error];
    if (received == nil) {
        NSLog(@"** fetchPostSession received nil ..");
        return nil;
    }
    
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: &error];
    
    if (error) {
        NSLog(@"** fetchPostSession Error : %@",error);
        return nil;
    }
    
    return dic;
}

- (NSDictionary *) fetchPostSessionForKC:(NSString *)str Body:(NSDictionary *)dict {
    // 同步 POST 请求
    NSURL *url = [NSURL URLWithString: str];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
    //设置请求方式为POST
    [request setHTTPMethod:@"POST"];
    
    // 设置参数
    NSData * data = [NSJSONSerialization dataWithJSONObject: dict options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:data];
    
    HttpHead * headerContentType = [[HttpHead alloc] init];
    headerContentType.headName = HEADER_CONTENT_TYPE_NAME;
    headerContentType.headValue = HEADER_CONTENT_TYPE_VALUE;
    [request setValue: headerContentType.headValue forHTTPHeaderField:headerContentType.headName];
    
    HttpHead * headerContentEncoding = [[HttpHead alloc] init];
    headerContentEncoding.headName = HEADER_CONTENT_LENGTH_NAME;
    headerContentEncoding.headValue = HEADER_CONTENT_LENGTH_VALUE;
    [request setValue: headerContentEncoding.headValue forHTTPHeaderField:headerContentEncoding.headName];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if (received == nil) {
        NSLog(@"** fetchPostSession received nil ..");
        return nil;
    }
    
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: &error];
    
    if (error) {
        NSLog(@"** fetchPostSession Error : %@",error);
        return nil;
    }
    
    return dic;
}

- (NSDictionary *) fixDictionaryForKCSession: (NSDictionary *)dict {
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject: dict forKey: @"ntspheader"];
    
    return param;
}

#pragma mark - PushNotificationDelegate
-(BOOL)didReceivePushNotification:(NSDictionary *)userInfo
{
    NSLog(@"^^ ** ^^ Receive Push Notification -- %@", userInfo);
//    if(_viewControllerId == VIEWCONTROLLER_NONE || _viewControllerId == VIEWCONTROLLER_LOGIN || _viewControllerId == VIEWCONTROLLER_LOADING)
//        return NO;
//    
//    isForgroundNotification = NO;

//    msgId = [userInfo objectForKey:@"msgid"];
//    messageType = [[userInfo objectForKey:@"messagetype"] integerValue];
//    
//    if (messageType == MessageType_Normal) {
//        if(news == nil) news = [[News alloc] init];
//
//        news.observer = self;
//        [news getDetailInfo:msgId];
//    } else if (messageType == MessageType_Control) {
//        Message *msg=[[Message alloc] init];
//        msg.receiveObjectID=VIEWCONTROLLER_VEHICLECONTROLHISTORY;
//        msg.commandID=MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
//        [self sendMessage:msg];
//    }
    
    return YES;
}

- (void) clearDataForUser {
    UserInformation = [[UserInformations alloc]init];
    self.UserInfo = UserInformation;
    
    ArrayForVehicletypes = [[NSArray alloc]initWithObjects:@"博越", @"帝豪GS", @"博瑞", nil];
    self.vehicletypes = ArrayForVehicletypes;
    
    ArrayForVehicletypesforKC = [[NSArray alloc]initWithObjects:@"博瑞", nil];
    self.vehicletypesforKC = ArrayForVehicletypesforKC;
    
    ViewsMan = [[ViewsManager alloc]init];
    self.ViewsManager = ViewsMan;
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
