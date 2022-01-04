//
//  VehicleManagerViewController.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/11/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "VehicleManagerViewController.h"
#import "MainNavigationController.h"
#import "DJRefresh.h"
#import "public.h"
#import "GNLUserInfo.h"
#import "VehicleStatus.h"

#import "GetPostSessionData.h"
#import "jkAlertController.h"
#import "SCGIFImageView.h"
#import "VehicleHelpViewController.h"

#define COMMAND_CHECK_PIN @"正在验证 .."
#define COMMAND_SENDING @"命令下发中 .."
#define COMMAND_DOING @"命令执行中 .."


@interface VehicleManagerViewController () <DJRefreshDelegate, UIGestureRecognizerDelegate>

@end

@implementation VehicleManagerViewController {
    IBOutlet UIScrollView * m_centerview;
    IBOutlet UILabel * la_statusforwindows;
    IBOutlet UILabel * la_statusforlockers;
    IBOutlet UIView * vi_statusmsg;
    UILabel * la_commandstatus;
    IBOutlet UIView * vi_pin;
    IBOutlet UITextField * tf_pin;
    
    IBOutlet UIButton * bt_windowsclose;
    IBOutlet UIButton * bt_windowsopen;
    IBOutlet UIButton * bt_doorclose;
    IBOutlet UIButton * bt_dooropen;
    
    UIButton * bt_help;
    BOOL isHelp;
    
    
    UIImageView * im_vehicle;
    UIImageView * im_winfl;
    UIImageView * im_winfr;
    UIImageView * im_winrl;
    UIImageView * im_winrr;
    UIImageView * im_windd;
    
    DJRefresh * m_refrese;
//    GetPostSessionData * PostSession;
    VehicleStatus * m_vehiclestatus;
    NSString * m_strPIN;
    NSInteger m_commandcode;  // 1001:开锁 1002:关锁 1003:开窗 1004:关窗
    BOOL isPIN;
    BOOL isGetingStatus;
    BOOL isSendCommand;
    
    BOOL isTimeOut;
    
    // 根据车型选择车型图片和窗户图片
    NSString * m_cartypeName;
    NSString * m_windtypeName;
    
    NSTimer * m_timer;
    
    // 刷新车况标志
    BOOL flagForVehicleStatus;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    
    self.navigationItem.title = @"车辆控制";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_menuicon"] style: UIBarButtonItemStylePlain target:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 向右滑动显示菜单
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:(MainNavigationController *)self.navigationController action:@selector(leftItemClicked)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    recognizer.delegate = self;
    [[self view] addGestureRecognizer:recognizer];
    
    // init the views above the scrollview for centerview
    CGFloat ax = [UIScreen mainScreen].bounds.size.width * 7.0f / 6.0f;
    CGFloat wx = [UIScreen mainScreen].bounds.size.width;
    NSLog(@"%lf %lf", m_centerview.bounds.size.height, m_centerview.bounds.size.width);
    m_centerview.contentSize = CGSizeMake(wx, ax);
    m_centerview.frame = CGRectMake(0.0f, 64.0f, wx, ax);
    m_centerview.showsHorizontalScrollIndicator = NO;
    m_centerview.directionalLockEnabled = YES;
    m_centerview.autoresizesSubviews = NO;
    
    if ([[GNLUserInfo defaultCarType] containsString:@"博越"]) {
        m_cartypeName = @"stsc";
        m_windtypeName = @"nlwc";
    }
    
    if ([[GNLUserInfo defaultCarType]isEqualToString:@"帝豪GS"]) {
        m_cartypeName = @"fesc";
        m_windtypeName = @"fewc";
    }

    UIImageView * lineview = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, wx, 2.0f)];
    [lineview setImage: [UIImage imageNamed:@"public_seperateline02"]];
    [m_centerview addSubview: lineview];
    
    CGRect imageframe = CGRectMake(0.0f, 0.2f, wx, ax - 2.0f);
    im_vehicle = [[UIImageView alloc] initWithFrame: imageframe];
    
    [im_vehicle setImage: [UIImage imageNamed:[NSString stringWithFormat:@"%@000000", m_cartypeName]]];
    
    im_winfl = [[UIImageView alloc] initWithFrame: imageframe];
    [im_winfl setImage: [UIImage imageNamed:[m_windtypeName stringByAppendingString:@"1"]]];
    [im_winfl setHidden: YES];
    im_winfr = [[UIImageView alloc] initWithFrame: imageframe];
    [im_winfr setImage: [UIImage imageNamed:[m_windtypeName stringByAppendingString:@"2"]]];
    [im_winfr setHidden: YES];
    im_winrl = [[UIImageView alloc] initWithFrame: imageframe];
    [im_winrl setImage: [UIImage imageNamed:[m_windtypeName stringByAppendingString:@"3"]]];
    [im_winrl setHidden: YES];
    im_winrr = [[UIImageView alloc] initWithFrame: imageframe];
    [im_winrr setImage: [UIImage imageNamed:[m_windtypeName stringByAppendingString:@"4"]]];
    [im_winrr setHidden: YES];
    im_windd = [[UIImageView alloc] initWithFrame: imageframe];
    [im_windd setImage: [UIImage imageNamed:[m_windtypeName stringByAppendingString:@"t"]]];
    [im_windd setHidden: YES];
    
    [m_centerview addSubview:im_vehicle];
    [m_centerview addSubview:im_winfl];
    [m_centerview addSubview:im_winfr];
    [m_centerview addSubview:im_winrl];
    [m_centerview addSubview:im_winrr];
    [m_centerview addSubview:im_windd];
    
    UIView * vi_help = [[UIView alloc]initWithFrame:CGRectMake(0.65 * wx, 2.0f, 0.35 * wx, 40.0f)];
    vi_help.backgroundColor = [UIColor clearColor];
    UIImageView * imt_help = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vctl_help"]];
    [imt_help setFrame:CGRectMake(8.0f, 8.0f, 24.0f, 24.0f)];
    [vi_help addSubview:imt_help];
    bt_help = [[UIButton alloc]initWithFrame:CGRectMake(40.0f, 5.0f, 0.35 * wx - 40.0f, 30.0f)];
    [bt_help.titleLabel setFont:[UIFont fontWithName:FONT_MM size:20.0f]];
    [bt_help.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [bt_help setTitleColor:[UIColor colorWithHexString:@"00A0E9"] forState:UIControlStateNormal];
    [bt_help setTitle:@"使用帮助" forState:UIControlStateNormal];
    [bt_help addTarget:self action:@selector(doIntoHelp:) forControlEvents:UIControlEventTouchUpInside];
    [vi_help addSubview:bt_help];
    [m_centerview addSubview:vi_help];
    
//    init the views above the scrollview for centerview ---- END
//    PostSession = [[GetPostSessionData alloc] init];
//    PostSession.delegate = self;
    
    m_vehiclestatus = [[VehicleStatus alloc] init];
    [m_vehiclestatus clearAllStatus];
    
    //
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"runline.gif" ofType:nil];
    SCGIFImageView* gifImageView = [[SCGIFImageView alloc] initWithGIFFile:filePath];
    gifImageView.frame = CGRectMake(wx * 0.125f + 20.0f, CGRectGetHeight([UIScreen mainScreen].bounds)/2, wx * 0.75f - 40.0f, 30.0f);
    [vi_statusmsg addSubview: gifImageView];
    la_commandstatus = [[UILabel alloc] initWithFrame:CGRectMake(wx * 0.15f, CGRectGetHeight([UIScreen mainScreen].bounds)/2 - 100.0f, wx * 0.7f, 30.0f)];
    [la_commandstatus setTextAlignment: NSTextAlignmentCenter];
    [la_commandstatus setText:@""];
    [la_commandstatus setTextColor: [UIColor whiteColor]];
    [la_commandstatus setFont: [UIFont fontWithName:FONT_MM size:18.0f]];
    [vi_statusmsg addSubview: la_commandstatus];
    
    [vi_statusmsg setHidden: YES];
    [vi_pin setHidden: YES];
    isPIN = NO;
    isGetingStatus = NO;
    
    [la_statusforlockers setTextColor: [UIColor whiteColor]];
    [la_statusforlockers setFont: [UIFont fontWithName:FONT_XI size:15.0f]];
    [la_statusforwindows setTextColor: [UIColor whiteColor]];
    [la_statusforwindows setFont: [UIFont fontWithName:FONT_XI size:15.0f]];
    
    flagForVehicleStatus = NO;
    // tableview refrese
    m_refrese = [DJRefresh refreshWithScrollView: m_centerview];
    m_refrese.delegate=self;
    m_refrese.topEnabled=YES;
    m_refrese.autoRefreshTop=YES;
//    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
    
    if ([GNLUserInfo isDemo]) {
        [self.view addSubview: [ServicesPro loadMarkDemoView]];
    }
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doClickedHomeToBackground:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doReturnToThis:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
//    [self docheckVehicleStatus];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    if (isHelp) {
        isHelp = NO;
        return;
    }
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

//- (void) viewDidDisappear:(BOOL)animated {
//    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
//}


- (void) doClickedHomeToBackground:(NSNotification *)notification {
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) doReturnToThis:(NSNotification *)notification {
    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    [bt_doorclose setEnabled:NO];
    [bt_dooropen setEnabled:NO];
    [bt_windowsclose setEnabled:NO];
    [bt_windowsopen setEnabled:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (flagForVehicleStatus == NO) {
            [self docheckVehicleStatus];
        }
        else return;
    });
}

- (void) doshowAlertView:(NSInteger)value {
    NSLog(@"alert value - %ld", value);
    NSString * str = NETWORK_ERROR;
    if (value == 204) {
        str = NETWORK_ERROR;
    }
    else if (value == 402) {
        str = @"当前账户登录时效已过期,\n请重新登录";
    }
    else if (value == 500) {
        str = @"Pin 码验证错误,\n请重新输入";
    }
    else if (value == 201) {
        str = @"连接服务器失败";
    }

    jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:str];
    [alert show];
}

// 车辆状态查询请求
- (NSInteger) sendPostSessionForStatusRequest {
    // 同步 POST 请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/sendVhlCtlStatusRequest", HTTP_GET_POST_ADDRESS]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
    //设置请求方式为POST
    [request setHTTPMethod:@"POST"];
    // 设置参数
    NSString * body = [NSString stringWithFormat:@"vin=%@&accessToken=%@&username=%@&isdemo=%@", [GNLUserInfo defaultCarVin], [GNLUserInfo accessToken], [GNLUserInfo userID], [GNLUserInfo isDemo] ? @"true" : @"false"];
    NSData * data = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: nil];
    if (dic == nil) return 0;
    NSLog(@"Request: %@", dic);
    
    NSString * code = [[dic objectForKey:@"status"]objectForKey:@"code"];
    if ([code isEqualToString:@""] || code == nil) {
        return 0;
    }
    else {
        return [code integerValue];
    }
}

// 车辆状态查询
- (NSDictionary *) sendPostSessionForStatus {
    // 同步 POST 请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/getVhlCtlStatus", HTTP_GET_POST_ADDRESS]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
    //设置请求方式为POST
    [request setHTTPMethod:@"POST"];
    // 设置参数
    NSString * body = [NSString stringWithFormat:@"vin=%@&accessToken=%@&username=%@&isdemo=%@", [GNLUserInfo defaultCarVin], [GNLUserInfo accessToken], [GNLUserInfo userID], [GNLUserInfo isDemo] ? @"true" : @"false"];
    NSData * data = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: nil];
    NSLog(@"Request: %@", dic);
    
    return dic;
}

- (void) docheckVehicleStatus {
    [bt_doorclose setEnabled:NO];
    [bt_dooropen setEnabled:NO];
    [bt_windowsclose setEnabled:NO];
    [bt_windowsopen setEnabled:NO];
    flagForVehicleStatus = YES;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger status = [self sendPostSessionForStatusRequest];
        if (status != 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [bt_doorclose setEnabled:YES];
                [bt_dooropen setEnabled:YES];
                [bt_windowsclose setEnabled:YES];
                [bt_windowsopen setEnabled:YES];
                [self doshowAlertView:status];
                [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                flagForVehicleStatus = NO;
            });
            return;
        }
        
        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow:90.0f];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
        NSDictionary * dicstatus;
        while (sp > 0.0f) {
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            // 暂停 2s
            [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
            
            dicstatus = [self sendPostSessionForStatus];
            
            NSString * res = [[dicstatus objectForKey:@"status"]objectForKey:@"code"];
            NSLog(@"** get vehicle status - %f %@", sp, res);
            if ([res isEqualToString:@"200"]) break;
        }
        
        if (sp < 0.0f) {
            NSLog( @"time out ..");
            dispatch_async(dispatch_get_main_queue(), ^{
                [bt_doorclose setEnabled:YES];
                [bt_dooropen setEnabled:YES];
                [bt_windowsclose setEnabled:YES];
                [bt_windowsopen setEnabled:YES];
                jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:NETWORK_TIMEOUT];
                [alert show];
               [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                flagForVehicleStatus = NO;
            });
            return;
        }
        
        [self performSelectorOnMainThread:@selector(doresetVehicleStatus:) withObject: dicstatus waitUntilDone:YES];
        flagForVehicleStatus = NO;
    });
    
    
}

- (void) doresetVehicleStatus:(NSDictionary *) dic {
    NSArray * keys = [dic allKeys];
    if ([keys containsObject:@"doorLockState"] && [keys containsObject:@"dormerStatus"] && [keys containsObject:@"trunkStatus"]) {
        
        [m_vehiclestatus setFrontLDoorStatus: [self getObjectStatusForVehicle:[dic objectForKey:@"leftFrontDoorStatus"] Windows:[dic objectForKey:@"no1WindowStatus"]]];
        [m_vehiclestatus setFrontRDoorStatus: [self getObjectStatusForVehicle:[dic objectForKey:@"rightFrontDoorStatus"] Windows:[dic objectForKey:@"no2WindowStatus"]]];
        [m_vehiclestatus setRearLDoorStatus: [self getObjectStatusForVehicle:[dic objectForKey:@"leftRearDoorStatus"] Windows:[dic objectForKey:@"no3WindowStatus"]]];
        [m_vehiclestatus setRearRDoorStatus: [self getObjectStatusForVehicle:[dic objectForKey:@"rightRearDoorStatus"] Windows:[dic objectForKey:@"no4WindowStatus"]]];
        [m_vehiclestatus setDormerStatus: [[NSString stringWithString:[dic objectForKey:@"dormerStatus"]] intValue]];
        [m_vehiclestatus setTrunkStatus: [[NSString stringWithString:[dic objectForKey:@"trunkStatus"]] intValue]];
        
        // set label for current status
        if ([[dic objectForKey:@"doorLockState"] isEqualToString:@"1"]) {
            [la_statusforlockers setText:@"车锁: 已开启"];
            [bt_dooropen setEnabled: NO];
            [bt_dooropen setBackgroundImage:[UIImage imageNamed:@"vctl_openlock1"] forState:UIControlStateNormal];
            [bt_doorclose setEnabled:YES];
            [bt_doorclose setBackgroundImage:[UIImage imageNamed:@"vctl_closelock"] forState:UIControlStateNormal];
        }
        else {
            [la_statusforlockers setText:@"车锁: 已关闭"];
            [bt_dooropen setEnabled: YES];
            [bt_dooropen setBackgroundImage:[UIImage imageNamed:@"vctl_openlock"] forState:UIControlStateNormal];
            [bt_doorclose setEnabled:NO];
            [bt_doorclose setBackgroundImage:[UIImage imageNamed:@"vctl_closelock1"] forState:UIControlStateNormal];
        }
        
        NSInteger windowsstatus = [[NSString stringWithString:[dic objectForKey:@"no1WindowStatus"]] intValue]
        + [[NSString stringWithString:[dic objectForKey:@"no2WindowStatus"]] intValue]
        + [[NSString stringWithString:[dic objectForKey:@"no3WindowStatus"]] intValue]
        + [[NSString stringWithString:[dic objectForKey:@"no4WindowStatus"]] intValue];
        if (windowsstatus == 4) {
            [la_statusforwindows setText: @"车窗: 已开启"];
            [bt_windowsopen setEnabled: NO];
            [bt_windowsopen setBackgroundImage:[UIImage imageNamed:@"vctl_openwin1"] forState:UIControlStateNormal];
            [bt_windowsclose setEnabled: YES];
            [bt_windowsclose setBackgroundImage:[UIImage imageNamed:@"vctl_closewin"] forState:UIControlStateNormal];
        }
        else if(windowsstatus == 0 && [m_vehiclestatus getDormerStatus] == 0) {
            [la_statusforwindows setText:@"车窗: 已关闭"];
            [bt_windowsopen setEnabled: YES];
            [bt_windowsopen setBackgroundImage:[UIImage imageNamed:@"vctl_openwin"] forState:UIControlStateNormal];
            [bt_windowsclose setEnabled: NO];
            [bt_windowsclose setBackgroundImage:[UIImage imageNamed:@"vctl_closewin1"] forState:UIControlStateNormal];
        }
        else {
            [la_statusforwindows setText: @"车窗: 已开启"];
            [bt_windowsopen setEnabled: YES];
            [bt_windowsopen setBackgroundImage:[UIImage imageNamed:@"vctl_openwin"] forState:UIControlStateNormal];
            [bt_windowsclose setEnabled: YES];
            [bt_windowsclose setBackgroundImage:[UIImage imageNamed:@"vctl_closewin"] forState:UIControlStateNormal];
        }
        
        [m_vehiclestatus showAllStatus];
        [self resetVehicleViewForStatus];
        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
    }
}

- (void) docheckCommand: (NSString *) pin {
    NSInteger result = 0;
    // 发送PIN CODE
    result = [self sendPostSessionForNotifyPIN:pin];
    
    if (result == 402) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MainNavigationController * ctl = (MainNavigationController *) self.navigationController;
            [ctl turntoLoginForOut];
        });
        return;
    }
    
    if (result != 200) {
        [self doshowAlertView:result];
        [vi_statusmsg setHidden: YES];
        
        [vi_pin setHidden: NO];
        [tf_pin setText:nil];
        return;
    }

    // 发送控制命令

//    [la_commandstatus setText:COMMAND_SENDING];
    [self performSelectorOnMainThread:@selector(exchangestatus:) withObject:COMMAND_SENDING waitUntilDone:YES];
    result = [self sendPostSessionForCommand];
    if (result != 200) {
        [self doshowAlertView:result];
        [vi_statusmsg setHidden: YES];
        return;
    }
    // 发送命令查询
    NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow:90.0f];
    NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
    NSDictionary * dicstatus;
    while (sp > 0.0f) {
        sp = [sDate timeIntervalSinceDate:[NSDate date]];
        // 程序暂停 2s
        [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
        dicstatus = [self sendPostSessionForAckInfo];
        NSString * res = [dicstatus objectForKey:@"ackInfoStatus"];
        NSLog(@"** get command ackinfo - %f %@", sp, res);
        if ([res isEqualToString:@"0"] && [[[dicstatus objectForKey:@"status"]objectForKey:@"code"]isEqualToString:@"200"]) break;
    }
    
    if (sp < 0.0f) {
        NSLog( @"time out ..");
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:NETWORK_TIMEOUT];
        [alert show];
        [vi_statusmsg setHidden: YES];
        return;
    }
    // 发送命令执行结果查询
    [self performSelectorOnMainThread:@selector(exchangestatus:) withObject:COMMAND_DOING waitUntilDone:YES];
    sDate = [NSDate dateWithTimeIntervalSinceNow:60.0f];
    sp = [sDate timeIntervalSinceDate:[NSDate date]];
    NSString * commandApi = @"";
    if (m_commandcode == 1001 || m_commandcode == 1002 ) {
        commandApi = @"windowResult";
    }
    else if (m_commandcode == 1003 || m_commandcode == 1004) {
        commandApi = @"doorLockResult";
    }
    while (sp > 0.0f) {
        sp = [sDate timeIntervalSinceDate:[NSDate date]];
        
        // 暂停 2s
        [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
        dicstatus = [self sendPostSessionForCommandResult];
        NSString * res = [[dicstatus objectForKey:@"status"]objectForKey:@"code"];
        NSLog(@"** get command result - %f %@", sp, res);

        if ([res isEqualToString:@"200"] && [[dicstatus objectForKey:commandApi]isEqualToString:@"1"]) break;
        if ([res isEqualToString:@"200"] && [[dicstatus objectForKey:commandApi]isEqualToString:@"2"]) break;
        if ([res isEqualToString:@"200"] && [[dicstatus objectForKey:commandApi]isEqualToString:@"0"]) break;
    }
    
    if (sp < 0.0f) {
        NSLog( @"time out ..");
        jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:NETWORK_TIMEOUT];
        [alert show];
        [vi_statusmsg setHidden: YES];
        return;
    }
    
    if ([[dicstatus objectForKey:commandApi]isEqualToString:@"1"]) {
        // 命令执行成功  5s刷新车况
        NSLog(@"command Result ::::: OK");
//        [self performSelectorOnMainThread:@selector(exchangestatus:) withObject:@"执行成功" waitUntilDone:YES];
//        
//        [NSThread sleepForTimeInterval:1.5];
        [self performSelectorOnMainThread:@selector(exchangestatus:) withObject:@"正在刷新车况" waitUntilDone:YES];
        
        [NSThread sleepForTimeInterval:5.0];
        
        [self docheckVehicleStatus];
        
    }
    else if ([[dicstatus objectForKey:commandApi]isEqualToString:@"0"]) {
        // 命令执行失败
        NSLog(@"command Result ::::: NO");
        dispatch_async(dispatch_get_main_queue(), ^{
            jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"指令发送失败!"];
            [alert show];
            [vi_statusmsg setHidden: YES];
        });
        return;
        
    }
    else if ([[dicstatus objectForKey:commandApi]isEqualToString:@"2"]) {
        // 控制失败
        NSLog(@"command Result ::::: NO");
        dispatch_async(dispatch_get_main_queue(), ^{
            jkAlertController * alert = [[jkAlertController alloc]initWithOKButton:@"控制失败,\n您的车辆不符合控制条件!"];
            [alert show];
            [vi_statusmsg setHidden: YES];
        });
        return;
    }
    [NSThread sleepForTimeInterval:1.5];
    [vi_statusmsg setHidden: YES];
}

- (void) exchangestatus:(NSString *) value {
    [la_commandstatus setText:value];
}

// Notify Pin Code
- (NSInteger) sendPostSessionForNotifyPIN:(NSString *)code {
    // 同步 POST 请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/checkPin", HTTP_GET_POST_ADDRESS]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
    //设置请求方式为POST
    [request setHTTPMethod:@"POST"];
    // 设置参数
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&username=%@&vin=%@&PIN=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo userID], [GNLUserInfo defaultCarVin], code, [GNLUserInfo isDemo] ? @"true" : @"false"];
    NSData * data = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: nil];
    if (dic == nil) return 0;
    NSLog(@"PIN Request: %@", dic);
    
    NSString * res = [[dic objectForKey:@"status"]objectForKey:@"code"];
    if ([res isEqualToString:@""] || code == nil) {
        return 0;
    }
    else {
        return [res integerValue];
    }
}

- (NSInteger) sendPostSessionForCommand{
    NSLog(@"command .. %ld", m_commandcode);

    NSString * commandcode = @"";
    NSString * controls = @"";
    if (m_commandcode == 1001) {
        commandcode = @"sendWindowLockCommand";
        controls = @"ControlWindowCommand=1";
        
    }
    else if (m_commandcode == 1002) {
        commandcode = @"sendWindowLockCommand";
        controls = @"ControlWindowCommand=0";
    }
    else if (m_commandcode == 1003) {
        commandcode = @"sendDoorLockCommand";
        controls = @"LockDoorCommand=1";
    }
    else if (m_commandcode == 1004) {
        commandcode = @"sendDoorLockCommand";
        controls = @"LockDoorCommand=0";
    }
    
    // 同步 POST 请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/%@", HTTP_GET_POST_ADDRESS, commandcode]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
    //设置请求方式为POST
    [request setHTTPMethod:@"POST"];
    // 设置参数
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&username=%@&vin=%@&%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo userID], [GNLUserInfo defaultCarVin], controls, [GNLUserInfo isDemo] ? @"true" : @"false"];
    NSLog(@"****** %@", body);
    NSData * data = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: nil];
    if (dic == nil) return 0;
    NSLog(@"Command Request: %@", dic);
    
    NSString * code = [[dic objectForKey:@"status"]objectForKey:@"code"];
    if ([code isEqualToString:@""] || code == nil) {
        return 0;
    }
    else {
        return [code integerValue];
    }
}

- (NSDictionary *) sendPostSessionForAckInfo {
    // 同步 POST 请求 username
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/getAckInfo", HTTP_GET_POST_ADDRESS]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
    //设置请求方式为POST
    [request setHTTPMethod:@"POST"];
    // 设置参数

    NSString * body = [NSString stringWithFormat:@"accessToken=%@&username=%@&vin=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo userID], [GNLUserInfo defaultCarVin],  [GNLUserInfo isDemo] ? @"true" : @"false"];;
    NSData * data = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: nil];
    
    NSLog(@"Command s Request: %@", dic);
    return dic;
}

- (NSDictionary *) sendPostSessionForCommandResult {
    NSString * commandApi;
    
    if (m_commandcode == 1001 || m_commandcode == 1002 ) {
        commandApi = @"getWindowLockResult";
    }
    else if (m_commandcode == 1003 || m_commandcode == 1004) {
        commandApi = @"getDoorLockResult";
    }
    else return nil;
    
    // 同步 POST 请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/%@", HTTP_GET_POST_ADDRESS, commandApi]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:POST_TIME_OUT];
    //设置请求方式为POST
    [request setHTTPMethod:@"POST"];
    // 设置参数
    
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&username=%@&vin=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo userID], [GNLUserInfo defaultCarVin], [GNLUserInfo isDemo] ? @"true" : @"false"];
    NSData * data = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData: received options: NSJSONReadingMutableContainers error: nil];
    if (dic == nil) return 0;
    NSLog(@"Request: %@", dic);
    
    return dic;
}

- (NSInteger) getObjectStatusForVehicle:(NSString *)DoorStatus Windows:(NSString *)WindowStatus {
    NSInteger resStatus = 0;
    if ([DoorStatus intValue] > 0) {
        resStatus = 2;
    }
    resStatus += [WindowStatus intValue];
    return resStatus;
}

- (void) resetVehicleViewForStatus {
    [im_windd setHidden: ([m_vehiclestatus getDormerStatus] == 0) ? YES : NO];
    
    // remove imageview
    [im_winfl setHidden:YES];
    [im_winfr setHidden:YES];
    [im_winrl setHidden:YES];
    [im_winrr setHidden:YES];
    
    NSInteger status = [m_vehiclestatus getFrontLDoorStatus];
    if (status%2 != 0) {
        if (status > 1) {
            // k m k c
            [im_winfl setImage:[UIImage imageNamed:[m_windtypeName stringByAppendingString:@"01"]]];
            [im_winfl setHidden:NO];
        }
        else {
            [im_winfl setImage:[UIImage imageNamed:[m_windtypeName stringByAppendingString:@"1"]]];
            [im_winfl setHidden:NO];
        }
    }

    status = [m_vehiclestatus getFrontRDoorStatus];
    if (status%2 != 0) {
        if (status > 1) {
            // k m k c
            [im_winfr setImage:[UIImage imageNamed:[m_windtypeName stringByAppendingString:@"02"]]];
            [im_winfr setHidden:NO];
        }
        else {
            [im_winfr setImage:[UIImage imageNamed:[m_windtypeName stringByAppendingString:@"2"]]];
            [im_winfr setHidden:NO];
        }
    }
    
    status = [m_vehiclestatus getRearLDoorStatus];
    if (status%2 != 0) {
        if (status > 1) {
            // k m k c
            [im_winrl setImage:[UIImage imageNamed:[m_windtypeName stringByAppendingString:@"03"]]];
            [im_winrl setHidden:NO];
        }
        else {
            [im_winrl setImage:[UIImage imageNamed:[m_windtypeName stringByAppendingString:@"3"]]];
            [im_winrl setHidden:NO];
        }
    }
    
    status = [m_vehiclestatus getRearRDoorStatus];
    if (status%2 != 0) {
        if (status > 1) {
            // k m k c
            [im_winrr setImage:[UIImage imageNamed:[m_windtypeName stringByAppendingString:@"04"]]];
            [im_winrr setHidden:NO];
        }
        else {
            [im_winrr setImage:[UIImage imageNamed:[m_windtypeName stringByAppendingString:@"4"]]];
            [im_winrr setHidden:NO];
        }
    }
    
    NSString * imagename = @"0";
    if ([m_vehiclestatus getTrunkStatus] == 1) {
        imagename = [imagename stringByAppendingString:@"1"];
    }
    else {
        imagename = [imagename stringByAppendingString:@"0"];
    }
    
    if ([m_vehiclestatus getFrontLDoorStatus] > 1) {
        imagename = [imagename stringByAppendingString:@"1"];
    }
    else {
        imagename = [imagename stringByAppendingString:@"0"];
    }
    
    if ([m_vehiclestatus getFrontRDoorStatus] > 1) {
        imagename = [imagename stringByAppendingString:@"1"];
    }
    else {
        imagename = [imagename stringByAppendingString:@"0"];
    }
    
    if ([m_vehiclestatus getRearLDoorStatus] > 1) {
        imagename = [imagename stringByAppendingString:@"1"];
    }
    else {
        imagename = [imagename stringByAppendingString:@"0"];
    }
    
    if ([m_vehiclestatus getRearRDoorStatus] > 1) {
        imagename = [imagename stringByAppendingString:@"1"];
    }
    else {
        imagename = [imagename stringByAppendingString:@"0"];
    }
    
    NSLog(@"image : status %@", [m_cartypeName stringByAppendingString:imagename]);
    [im_vehicle setImage: [UIImage imageNamed: [m_cartypeName stringByAppendingString:imagename]]];

}

// Actions

- (IBAction) doOpenWindows:(id)sender {
    [vi_pin setHidden: NO];
    [tf_pin setText:nil];
    m_commandcode = 1001;
    isSendCommand = YES;
}

- (IBAction) doCloseWindows:(id)sender {
    [vi_pin setHidden: NO];
    [tf_pin setText:nil];
    m_commandcode = 1002;
    isSendCommand = YES;
}

- (IBAction) doOpenLock:(id)sender {
    [vi_pin setHidden: NO];
    [tf_pin setText:nil];
    m_commandcode = 1003;
    isSendCommand = YES;
}

- (IBAction) doCloseLock:(id)sender {
    [vi_pin setHidden: NO];
    [tf_pin setText:nil];
    m_commandcode = 1004;
    isSendCommand = YES;
}

- (IBAction) doNotifyPinOK:(id)sender {
    m_strPIN = [NSString stringWithString:tf_pin.text];
    
    // 隐藏PIN码窗口
    [vi_pin setHidden: YES];
    [self textfield_TouchDown:self];
    [vi_statusmsg setHidden: NO];
    [la_commandstatus setText:COMMAND_CHECK_PIN];
    
    
    [NSThread detachNewThreadSelector:@selector(docheckCommand:) toTarget:self withObject:tf_pin.text];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self docheckCommand:tf_pin.text];
//    });
    
}

- (IBAction) doNotifyPinCancel:(id)sender {
    [self textfield_TouchDown:self];
    [vi_pin setHidden: YES];
}

- (IBAction) doIntoHelp:(id)sender {
    VehicleHelpViewController * view = [[VehicleHelpViewController alloc]init];
    isHelp = YES;
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction) textfield_didEdit:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction) textfield_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
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
