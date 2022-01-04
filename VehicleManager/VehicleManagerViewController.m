//
//  VehicleManagerViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/1/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "VehicleManagerViewController.h"
#import "public.h"
#import "VehicleHelpViewController.h"
#import "VehicleStatus.h"
#import "VehicleCtrlListViewController.h"

#define COMMAND_CHECK_PIN @"正在验证 .."
#define COMMAND_SENDING @"命令下发中 .."
#define COMMAND_DOING @"命令执行中 .."

#define PINCODE_TIME_SPACE 600.0f

@interface VehicleManagerViewController () <DJRefreshDelegate>

@end

@implementation VehicleManagerViewController {
    PinEditorView * m_pinEditorView;
    DJRefresh * m_refrese;
    VehicleStatus * m_vehicle;
    
    // 根据车型选择车型图片和窗户图片
    NSString * m_vehicleTypeName;
    NSString * m_windowsTypeName;
    
    UIScrollView * m_scrollview;
    UIImageView * im_vehicle;
    UIImageView * im_winfl;
    UIImageView * im_winfr;
    UIImageView * im_winrl;
    UIImageView * im_winrr;
    UIImageView * im_windd;
    
    IBOutlet UIView * vi_status;
    IBOutlet UILabel * la_statuswindow;
    IBOutlet UILabel * la_statuslock;
    
    IBOutlet UIView * vi_controlForKC;
    IBOutlet UIButton * bt_ctrlwindowKC;    // code = 10
    IBOutlet UIButton * bt_ctrllockKC;      // code = 11
    
    IBOutlet UIView * vi_controlForNL;
//    IBOutlet UIButton * bt_ctrlwindow;
//    IBOutlet UIButton * bt_ctrllock;
//    IBOutlet UIButton * bt_ctrlboth;
    IBOutlet UIButton * bt_openw;       // code = 0
    IBOutlet UIButton * bt_closew;      // code = 1
    IBOutlet UIButton * bt_openl;       // code = 2
    IBOutlet UIButton * bt_closel;      // code = 3
    
    IBOutlet UIView * vi_controlForFE;
    IBOutlet UIButton * bt_fe_openw;
    IBOutlet UIButton * bt_fe_closew;
    IBOutlet UIButton * bt_fe_openl;
    IBOutlet UIButton * bt_fe_closel;
    
    
    NSInteger m_codeForCommand;
//    ProcessBoxView * m_loadingview;
    ProcessBoxCommandView * m_loadingview;
    
    NSDate * m_timeForIdentify;
    NSString * m_pinCode;
    BOOL flagForVehicleStatus;
    BOOL flagForVehicleCommand;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"车辆控制"];

    m_pinEditorView = [[PinEditorView alloc]init];
    [self.view addSubview: m_pinEditorView];
    [m_pinEditorView hideView];
    [m_pinEditorView.bt_OK addTarget:self action:@selector(doPinCodeViewclickedOK:) forControlEvents:UIControlEventTouchUpInside];
    [m_pinEditorView.bt_NO addTarget:self action:@selector(doPinCodeViewclickedNO:) forControlEvents:UIControlEventTouchUpInside];

    m_codeForCommand = -1;
    m_vehicle = [[VehicleStatus alloc] init];
    [m_vehicle clearAllStatus];
    
    // init scrollview
    CGFloat wx = [UIScreen mainScreen].bounds.size.width;
    CGFloat ax = ([UIScreen mainScreen].bounds.size.height - 64.0f) * 0.75f;
    m_scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, wx, ax)];
    m_scrollview.backgroundColor = [UIColor clearColor];
    m_scrollview.contentSize = CGSizeMake(wx, ax + 1.0f);
    m_scrollview.frame = CGRectMake(0.0f, 64.0f, wx, ax);
    m_scrollview.showsHorizontalScrollIndicator = NO;
    m_scrollview.directionalLockEnabled = YES;
    m_scrollview.autoresizesSubviews = NO;
    [self.view insertSubview:m_scrollview atIndex:0];
    
    //
    vi_status.frame = CGRectMake(0.0f, ax + 72.0f, wx, 24.0f);
    vi_status.backgroundColor = [UIColor clearColor];
    [self.view addSubview:vi_status];
    [la_statuswindow setText:@"车窗:已关闭"];
    [la_statuswindow setTextColor:[UIColor whiteColor]];
    [la_statuswindow setFont:[UIFont fontWithName:FONT_MM size:FONT_S_DETAIL]];
    la_statuswindow.adjustsFontSizeToFitWidth = YES;
    [la_statuslock setText:@"车锁:已关闭"];
    [la_statuslock setTextColor:[UIColor whiteColor]];
    [la_statuslock setFont:[UIFont fontWithName:FONT_MM size:FONT_S_DETAIL]];
    la_statuslock.adjustsFontSizeToFitWidth = YES;

    // 提示view
    UIView * vi_msg = [[UIView alloc]initWithFrame:CGRectMake(0.65f * wx, 2.0f, 0.35 * wx, 30.0f)];
    vi_msg.backgroundColor = [UIColor clearColor];
    
    UIImageView * imt_red = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vctl_red"]];
    [imt_red setFrame:CGRectMake(8.0f, 3.0f, 24.0f, 24.0f)];
    [vi_msg addSubview:imt_red];
    UILabel * la_msg = [[UILabel alloc]initWithFrame:CGRectMake(40.0f, 0.0f, 0.35 * wx - 40.0f, 30.0f)];
    [la_msg setFont:[UIFont fontWithName:FONT_MM size:16.0f]];
    [la_msg setTextAlignment:NSTextAlignmentLeft];
    [la_msg setTextColor:[UIColor whiteColor]];
    [la_msg setText:@"车窗开启"];
    [vi_msg addSubview:la_msg];
    [m_scrollview addSubview:vi_msg];
    
    // 根据默认车辆类型 选择车型图
    if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GS"]) {
        m_vehicleTypeName = @"fesc";
        m_windowsTypeName = @"fewc";
        
        vi_controlForFE.frame = CGRectMake(0.0f, ax + 104.0f, wx, [UIScreen mainScreen].bounds.size.height - ax - 104.0f);
        vi_controlForFE.backgroundColor = [UIColor clearColor];
        [self.view addSubview:vi_controlForFE];
        
    }
    else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GL"]) {
        m_vehicleTypeName = @"fev";
        m_windowsTypeName = @"fe5";
        
        vi_controlForFE.frame = CGRectMake(0.0f, ax + 104.0f, wx, [UIScreen mainScreen].bounds.size.height - ax - 104.0f);
        vi_controlForFE.backgroundColor = [UIColor clearColor];
        [self.view addSubview:vi_controlForFE];
        
    }
    else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博越"]) {
        m_vehicleTypeName = @"stsc";
        m_windowsTypeName = @"nlwc";
        
        UIView * vi_help = [[UIView alloc]initWithFrame:CGRectMake(8.0f, 2.0f, 0.35 * wx, 30.0f)];
        vi_help.backgroundColor = [UIColor clearColor];
        UIImageView * imt_help = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vctl_help"]];
        [imt_help setFrame:CGRectMake(12.0f, 7.0f, 16.0f, 16.0f)];
        [vi_help addSubview:imt_help];
        UILabel * la_help= [[UILabel alloc]initWithFrame:CGRectMake(40.0f, 0.0f, 0.35 * wx - 40.0f, 30.0f)];
        [la_help setFont:[UIFont fontWithName:FONT_MM size:16.0f]];
        [la_help setTextAlignment:NSTextAlignmentLeft];
        [la_help setTextColor: [UIColor colorWithHexString:@"00A0E9"]];
        [la_help setText:@"使用帮助"];
        [vi_help addSubview:la_help];
        UITapGestureRecognizer * singleTouchUp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doIntoHelp:)];
        [vi_help addGestureRecognizer:singleTouchUp];
        [m_scrollview addSubview:vi_help];
        
        vi_controlForNL.frame = CGRectMake(0.0f, ax + 104.0f, wx, [UIScreen mainScreen].bounds.size.height - ax - 104.0f);
        vi_controlForNL.backgroundColor = [UIColor clearColor];
        [self.view addSubview:vi_controlForNL];
    }
    else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博瑞"]) {
        m_vehicleTypeName = @"kcc";
        m_windowsTypeName = @"kcc";
        
        /*
        UIView * vi_help = [[UIView alloc]initWithFrame:CGRectMake(8.0f, 2.0f, 0.35 * wx, 30.0f)];
        vi_help.backgroundColor = [UIColor clearColor];
        UIImageView * imt_help = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vctl_help"]];
        [imt_help setFrame:CGRectMake(12.0f, 7.0f, 16.0f, 16.0f)];
        [vi_help addSubview:imt_help];
        UILabel * la_help= [[UILabel alloc]initWithFrame:CGRectMake(40.0f, 0.0f, 0.35 * wx - 40.0f, 30.0f)];
        [la_help setFont:[UIFont fontWithName:FONT_MM size:16.0f]];
        [la_help setTextAlignment:NSTextAlignmentLeft];
        [la_help setTextColor: [UIColor colorWithHexString:@"00A0E9"]];
        [la_help setText:@"使用帮助"];
        [vi_help addSubview:la_help];
        UITapGestureRecognizer * singleTouchUp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doIntoHelp:)];
        [vi_help addGestureRecognizer:singleTouchUp];
        [m_scrollview addSubview:vi_help];      */
        
        vi_controlForKC.frame = CGRectMake(0.0f, ax + 104.0f, wx, [UIScreen mainScreen].bounds.size.height - ax - 104.0f);
        vi_controlForKC.backgroundColor = [UIColor clearColor];
        [self.view addSubview:vi_controlForKC];
        
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"vctl_history"] style:UIBarButtonItemStylePlain target:self action: @selector(doIntoControlList:)];
        [rightItem setTintColor: [UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    //
    UIImageView * lineview = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, wx, 2.0f)];
    [lineview setImage: [UIImage imageNamed:@"public_seperateline02"]];
    [m_scrollview addSubview: lineview];
    
    CGRect imageframe = CGRectMake(0.0f, 0.0f, wx, ax - 2.0f);
    im_vehicle = [[UIImageView alloc] initWithFrame: imageframe];
    [im_vehicle setImage: [UIImage imageNamed:[NSString stringWithFormat:@"%@000000",m_vehicleTypeName]]];
    im_winfl = [[UIImageView alloc] initWithFrame: imageframe];
    [im_winfl setImage: [UIImage imageNamed:[m_windowsTypeName stringByAppendingString:@"1"]]];
    [im_winfl setHidden: YES];
    im_winfr = [[UIImageView alloc] initWithFrame: imageframe];
    [im_winfr setImage: [UIImage imageNamed:[m_windowsTypeName stringByAppendingString:@"2"]]];
    [im_winfr setHidden: YES];
    im_winrl = [[UIImageView alloc] initWithFrame: imageframe];
    [im_winrl setImage: [UIImage imageNamed:[m_windowsTypeName stringByAppendingString:@"3"]]];
    [im_winrl setHidden: YES];
    im_winrr = [[UIImageView alloc] initWithFrame: imageframe];
    [im_winrr setImage: [UIImage imageNamed:[m_windowsTypeName stringByAppendingString:@"4"]]];
    [im_winrr setHidden: YES];
    im_windd = [[UIImageView alloc] initWithFrame: imageframe];
    [im_windd setImage: [UIImage imageNamed:[m_windowsTypeName stringByAppendingString:@"t"]]];
    [im_windd setHidden: YES];
    [m_scrollview addSubview:im_vehicle];
    [m_scrollview addSubview:im_winfl];
    [m_scrollview addSubview:im_winfr];
    [m_scrollview addSubview:im_winrl];
    [m_scrollview addSubview:im_winrr];
    [m_scrollview addSubview:im_windd];
    
    [bt_closel setEnabled: NO];
    [bt_closew setEnabled: NO];
    [bt_openl setEnabled: NO];
    [bt_openw setEnabled: NO];
    
    [bt_fe_closel setEnabled: NO];
    [bt_fe_openl setEnabled: NO];
    [bt_fe_closew setEnabled: NO];
    [bt_fe_openw setEnabled: NO];
    [bt_ctrllockKC setEnabled: NO];
    [bt_ctrlwindowKC setEnabled: NO];
    
    m_refrese = [DJRefresh refreshWithScrollView: m_scrollview];
    m_refrese.delegate = self;
    m_refrese.topEnabled = YES;
    m_refrese.autoRefreshTop = YES;
    
    m_loadingview = [[ProcessBoxCommandView alloc]initWithMessage:@""];
    [m_loadingview setFrame:CGRectMake(0.0f, ax + 64.0f - 65.0f, wx, 65.0f)];
    [self.view addSubview:m_loadingview];
    [m_loadingview hideView];
    
    if ([self.UserInfo isRunDemo]) {
        [self.view addSubview: [ExtendStaticView MarkDemoView]];
    }
    
    //
    flagForVehicleStatus = NO;
    flagForVehicleCommand = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doClickedHomeToBackground:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doReturnToThis:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
    self.flagForViewHidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    self.flagForViewHidden = YES;
}

- (void) doClickedHomeToBackground:(NSNotification *)notification {
    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) doReturnToThis:(NSNotification *)notification {
//    [m_refrese startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void) refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (flagForVehicleStatus == YES) return;
        
        if (flagForVehicleCommand == YES) {
            [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
            return;
        }
        
        if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GS"]) {
            [self sendPostSessionForVehicleStatusONFE: NO];
        }
        else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GL"]) {
            [self sendPostSessionForVehicleStatusONFE: NO];
        }
        else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博越"]) {
            [self sendPostSessionForVehicleStatus: 3.0f];
        }
        else if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"博瑞"]) {
            [self sendPostSessionForKCVehicleStatus];
        }

    });
}

- (void) sendPostSessionForNewStatus {
    flagForVehicleCommand = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_loadingview setTitile: @"车况刷新中 ..."];
        [m_loadingview showView];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * code = nil;
        NSString * url = [NSString stringWithFormat:@"%@/api/sendVhlCtlStatusRequest", HTTP_GET_POST_ADDRESS];
        NSString * body = [NSString stringWithFormat:@"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
        NSDictionary * mdic = [self fetchPostSession:url Body:body];
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        
        NSLog(@"** sendVhlCtlStatusRequest %@",code);
        if (![code isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
                [alertview show];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        
        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_VEHICLESTATUS];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
        url = [NSString stringWithFormat:@"%@/api/getVhlCtlStatus", HTTP_GET_POST_ADDRESS];
        while (sp > 0.0f) {
            if (self.flagForViewHidden) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"self.view.isHidden For Vehicle Status ..");
                });
                return;
            }
            
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            mdic = [self fetchPostSession:url Body:body];
            code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
            NSLog(@"** get vehicle status - %f %@", sp, code);
            if ([code isEqualToString:@"200"]) break;
            
            // 暂停 2s
            [NSThread sleepForTimeInterval: 3.0f];
        }

        [NSThread sleepForTimeInterval: 7.0f];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_loadingview setTitile: @"数据获取中 ..."];
            [m_loadingview showView];
        });
        
        // New Status For Car After 7.0f
        code = nil;
        url = [NSString stringWithFormat:@"%@/api/sendVhlCtlStatusRequest", HTTP_GET_POST_ADDRESS];
        body = [NSString stringWithFormat:@"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
        mdic = [self fetchPostSession:url Body:body];
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        
        NSLog(@"** sendVhlCtlStatusRequest %@",code);
        if (![code isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
                [alertview show];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        
        sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_VEHICLESTATUS];
        sp = [sDate timeIntervalSinceDate:[NSDate date]];
        url = [NSString stringWithFormat:@"%@/api/getVhlCtlStatus", HTTP_GET_POST_ADDRESS];
        while (sp > 0.0f) {
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            mdic = [self fetchPostSession:url Body:body];
            code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
            NSLog(@"** get vehicle status - %f %@", sp, code);
            if ([code isEqualToString:@"200"]) break;
            
            // 暂停 2s
            [NSThread sleepForTimeInterval: 3.0f];
        }
        
        if (sp < 0.0f) { // Time out
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Vehicle Status Time Out ..");
                [m_loadingview hideView];
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:NETWORK_TIMEOUT];
                [alertview show];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_loadingview hideView];
            [self setObjectForVehicleStatus:mdic];
            
            flagForVehicleCommand = NO;
        });
    });
}

- (void) sendPostSessionForVehicleStatus:(CGFloat) timeSpace {
    flagForVehicleStatus = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * code = nil;
        NSString * url = [NSString stringWithFormat:@"%@/api/sendVhlCtlStatusRequest", HTTP_GET_POST_ADDRESS];
        NSString * body = [NSString stringWithFormat:@"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
        NSDictionary * mdic = [self fetchPostSession:url Body:body];
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        
        NSLog(@"** sendVhlCtlStatusRequest %@",code);
        if (![code isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_main_queue(), ^{

                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
                alertview.okBlock = ^(){
                    [m_loadingview hideView];
                    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                };
                [alertview show];
                
                flagForVehicleStatus = NO;
            });
            return;
        }
        
        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_VEHICLESTATUS];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
        url = [NSString stringWithFormat:@"%@/api/getVhlCtlStatus", HTTP_GET_POST_ADDRESS];
        while (sp > 0.0f) {
            if (self.flagForViewHidden) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"self.view.isHidden For Vehicle Status ..");
                });
                return;
            }
            
            sp = [sDate timeIntervalSinceDate:[NSDate date]];

            mdic = [self fetchPostSession:url Body:body];
            code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
            NSLog(@"** get vehicle status - %f %@", sp, code);
            if ([code isEqualToString:@"200"]) break;
            
            // 暂停 2s
            [NSThread sleepForTimeInterval: timeSpace];
        }
        
        if (sp < 0.0f) { // Time out
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Vehicle Status Time Out ..");
                [m_loadingview hideView];
                [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:NETWORK_TIMEOUT];
                [alertview show];
                
                flagForVehicleStatus = NO;
            });
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
            [m_loadingview hideView];
            [self setObjectForVehicleStatus:mdic];
            
            flagForVehicleStatus = NO;
        });
    });
}

- (void) sendPostSessionForVehicleStatusONFE:(BOOL) flag {
    flagForVehicleStatus = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * code = nil;
        NSString * url = [NSString stringWithFormat:@"%@/api/sendVhlCtlStatusRequest", HTTP_GET_POST_ADDRESS];
        NSString * body = [NSString stringWithFormat:@"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
        NSDictionary * mdic = [self fetchPostSession:url Body:body];
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        
        NSLog(@"** sendVhlCtlStatusRequest %@",code);
        if (![code isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
                alertview.okBlock = ^(){
                    [m_loadingview hideView];
                    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                };
                [alertview show];
                
                flagForVehicleStatus = NO;
            });
            return;
        }
        
        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_VEHICLESTATUS];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
        url = [NSString stringWithFormat:@"%@/api/getVhlCtlStatus", HTTP_GET_POST_ADDRESS];
        while (sp > 0.0f) {
            if (self.flagForViewHidden) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"self.view.isHidden For Vehicle Status ..");
                });
                return;
            }
            
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            mdic = [self fetchPostSession:url Body:body];
            code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
            NSLog(@"** get vehicle status - %f %@", sp, code);
            if ([code isEqualToString:@"200"]) break;
            
            // 暂停 2s
            [NSThread sleepForTimeInterval: 2.0f];
        }
        
        if (sp < 0.0f) { // Time out
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Vehicle Status Time Out ..");
                [m_loadingview hideView];
                [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:NETWORK_TIMEOUT];
                [alertview show];
                
                flagForVehicleStatus = NO;
            });
            return;
        }
        
        // 关窗操作后显示天窗未关闭提示
        if (flag) {
            // FE 刷车况间隔
            [NSThread sleepForTimeInterval: 10.0f];
            url = [NSString stringWithFormat:@"%@/api/sendVhlCtlStatusRequest", HTTP_GET_POST_ADDRESS];
            body = [NSString stringWithFormat:@"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
            mdic = [self fetchPostSession:url Body:body];
            code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
            
            NSLog(@"** sendVhlCtlStatusRequest %@",code);
            if (![code isEqualToString:@"200"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
                    alertview.okBlock = ^(){
                        [m_loadingview hideView];
                        [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                    };
                    [alertview show];
                    
                    flagForVehicleStatus = NO;
                });
                return;
            }
            
            sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_VEHICLESTATUS];
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            url = [NSString stringWithFormat:@"%@/api/getVhlCtlStatus", HTTP_GET_POST_ADDRESS];
            while (sp > 0.0f) {
                sp = [sDate timeIntervalSinceDate:[NSDate date]];
                
                mdic = [self fetchPostSession:url Body:body];
                code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
                NSLog(@"** get vehicle status - %f %@", sp, code);
                if ([code isEqualToString:@"200"]) break;
                
                // 暂停 2s
                [NSThread sleepForTimeInterval: 2.0f];
            }
            
            if (sp < 0.0f) { // Time out
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Post Session For Vehicle Status Time Out ..");
                    [m_loadingview hideView];
                    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                    
                    AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:NETWORK_TIMEOUT];
                    [alertview show];
                    
                    flagForVehicleStatus = NO;
                });
                return;
            }

            // 天窗开启 提示窗
            NSString * dormerStatus = [mdic objectForKey:@"dormerStatus"];
            if ([dormerStatus isEqualToString:@"1"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton: @"天窗开启，需要您手动关闭。"];
                    [alertview show];
                });
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
            [m_loadingview hideView];
            [self setObjectForVehicleStatus:mdic];
            
            flagForVehicleStatus = NO;
        });
    });
}

- (void) sendPostSessionForKCVehicleStatus {
    
    flagForVehicleStatus = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * code = nil;
        NSString * url = [NSString stringWithFormat:@"%@/system/condition/query11", HTTP_GET_POST_ADDRESS_KC];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
        [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
        [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
        [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
        NSDictionary * body = [self fixDictionaryForKCSession:dict];
        
        NSDictionary * mdic = nil;
        
        mdic = [self fetchPostSessionForKC:url Body:body];
        code = [[mdic objectForKey:@"errcode"] stringValue];
        NSString * lastTime = [[mdic objectForKey:@"data"]objectForKey:@"record_timestamp"];
        
        url = [NSString stringWithFormat:@"%@/system/command/send", HTTP_GET_POST_ADDRESS_KC];
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
        [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
        [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
        [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
        [param setObject:dict forKey:@"ntspheader"];
        [param setObject:@"" forKey:@"content"];
        [param setObject:@"1" forKey:@"isInstant"];
        [param setObject:@"RP-VEH-CON" forKey:@"type"];     // 重新上报车况
        [param setObject:APP_VERSION_CODE forKey:@"version"];
        mdic = [self fetchPostSessionForKC:url Body:param];
        code = [[mdic objectForKey:@"errcode"] stringValue];
        
        if (![code isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * str = [mdic objectForKey:@"errmsg"];
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:str];
                alertview.okBlock = ^(){
                    [m_loadingview hideView];
                    flagForVehicleStatus = NO;
                    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                };
                [alertview show];
            });
            return;
        }
        
        // 获取最新车况
        url = [NSString stringWithFormat:@"%@/system/condition/query11", HTTP_GET_POST_ADDRESS_KC];
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
        [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
        [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
        [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
        body = [self fixDictionaryForKCSession:dict];
        
//        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_VEHICLESTATUS];

        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow: 30.0f];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
        
        while (sp > 0.0f) {
            if (self.flagForViewHidden) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"self.view.isHidden For Vehicle Status ..");
                });
                return;
            }
            
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            mdic = [self fetchPostSessionForKC:url Body:body];
            code = [[mdic objectForKey:@"errcode"] stringValue];
            NSString * newTime = [[mdic objectForKey:@"data"]objectForKey:@"record_timestamp"];
            NSLog(@"** get vehicle status - %f %@", sp, code);
            if (![code isEqualToString:@"0"] && [mdic count] == 3) break;
            if (![newTime isEqualToString:lastTime]) break; // ok
            
            // 暂停 2s
            [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
        }
        
        if (![code isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * str = [mdic objectForKey:@"errmsg"];
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:str];
                alertview.okBlock = ^(){
                    [m_loadingview hideView];
                    [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                    flagForVehicleStatus = NO;
                };
                [alertview show];
            });
            return;
        }
        
        if (sp < 0.0f) { // Time out
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Vehicle Status Time Out ..");
                [m_loadingview hideView];
                [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:NETWORK_TIMEOUT];
                [alertview show];
                
                flagForVehicleStatus = NO;
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
            [m_loadingview hideView];
            [self setObjectForVehicleStatusForKC: [mdic objectForKey:@"data"]];
            
            flagForVehicleStatus = NO;
        });
    });
}

- (void) sendPostSessionForCommand {
    flagForVehicleCommand = YES;
    
    NSString * commandcode = nil;
    NSString * controls = nil;
    NSString * commandApiGet = nil;
    NSString * commandApi = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_loadingview setTitile: COMMAND_CHECK_PIN];
        [m_loadingview showView];
        
        // 控制按钮置灰且死锁
        [bt_closel setEnabled: NO];
        [bt_closel setImage:[UIImage imageNamed:@"vctl_closelocken"] forState:UIControlStateNormal];
        [bt_openl setEnabled: NO];
        [bt_openl setImage:[UIImage imageNamed:@"vctl_openlocken"] forState:UIControlStateNormal];
        [bt_closew setEnabled: NO];
        [bt_closew setImage:[UIImage imageNamed:@"vctl_closewindowen"] forState:UIControlStateNormal];
        [bt_openw setEnabled: NO];
        [bt_openw setImage:[UIImage imageNamed:@"vctl_openwindowen"] forState:UIControlStateNormal];

    });
    
    if (m_codeForCommand == 0) {
        commandcode = @"sendWindowLockCommand";
        controls = @"ControlWindowCommand=1";
        commandApi = @"getWindowLockResult";
        commandApiGet = @"windowResult";
    }
    else if (m_codeForCommand == 1) {
        commandcode = @"sendWindowLockCommand";
        controls = @"ControlWindowCommand=0";
        commandApi = @"getWindowLockResult";
        commandApiGet = @"windowResult";
    }
    else if (m_codeForCommand == 2) {
        commandcode = @"sendDoorLockCommand";
        controls = @"LockDoorCommand=1";
        commandApi = @"getDoorLockResult";
        commandApiGet = @"doorLockResult";
    }
    else if (m_codeForCommand == 3) {
        commandcode = @"sendDoorLockCommand";
        controls = @"LockDoorCommand=0";
        commandApi = @"getDoorLockResult";
        commandApiGet = @"doorLockResult";
    }
    else return;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 发送PIN
        if (m_codeForCommand == 2) {
            
        }
        NSString * code = nil;
        NSString * result = nil;
        NSString * url = [NSString stringWithFormat:@"%@/api/%@", HTTP_GET_POST_ADDRESS, commandcode];
        NSString * body = [NSString stringWithFormat:@"%@&vin=%@&%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin], controls];
        NSDictionary * mdic = [self fetchPostSession:url Body:body];
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        NSLog(@"** %@ %@", commandcode, code);
        
        if (![code isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
                [alertview show];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        
        // 发送命令查询
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_loadingview setTitile: COMMAND_SENDING];
            [m_loadingview showView];
        });
        url = [NSString stringWithFormat: @"%@/api/getAckInfo", HTTP_GET_POST_ADDRESS];
        body = [NSString stringWithFormat: @"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_COMMANDSTATUS];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];

        while (sp > 0.0f) {
            if (self.flagForViewHidden) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"self.view.isHidden For Vehicle Status ..");
                });
                return;
            }
            
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            mdic = [self fetchPostSession: url Body: body];
            code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
            result = [mdic objectForKey:@"ackInfoStatus"];
            NSLog(@"** get command ackinfo - %f %@", sp, code);
            if ([result isEqualToString:@"0"] && [code isEqualToString:@"200"]) break;
            
            // 程序暂停 2s
            [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
        }
        
        if (sp < 0.0f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Command Ackinfo Time Out ..");
                [m_loadingview hideView];
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton: NETWORK_TIMEOUT];
                [alertview show];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        
        // 发送命令执行结果查询
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_loadingview setTitile: COMMAND_DOING];
        });
        url = [NSString stringWithFormat:@"%@/api/%@", HTTP_GET_POST_ADDRESS, commandApi];
        body = [NSString stringWithFormat: @"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
        
        sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_COMMANDRESULT];
        sp = [sDate timeIntervalSinceDate:[NSDate date]];

        while (sp > 0.0f) {
            if (self.flagForViewHidden) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"self.view.isHidden For Vehicle Status ..");
                });
                return;
            }
            
            sp = [sDate timeIntervalSinceDate:[NSDate date]];

            mdic = [self fetchPostSession:url Body:body];
            code = [[mdic objectForKey: @"status"]objectForKey:@"code"];
            result = [mdic objectForKey:commandApiGet];
            NSLog(@"** get command result - %f %@", sp, result);
            
            if ([code isEqualToString:@"200"] && [result isEqualToString:@"1"]) break;
            if ([code isEqualToString:@"200"] && [result isEqualToString:@"2"]) break;
            if ([code isEqualToString:@"200"] && [result isEqualToString:@"0"]) break;
            
            // 暂停 2s
            [NSThread sleepForTimeInterval: POST_WHILE_SPACE];
        }
        
        if (sp < 0.0f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Command Ackinfo Time Out ..");
                [m_loadingview hideView];
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton: NETWORK_TIMEOUT];
                [alertview show];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        
        if ([result isEqualToString:@"1"]) {
            // 命令执行成功  5s刷新车况
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview setTitile: @"正在刷新车况"];
                [m_loadingview showView];
                
                // 车锁控制后，执行两次刷新车况
                if (m_codeForCommand ==3) {
                    [self sendPostSessionForNewStatus];
                }
                else {
                    [self sendPostSessionForVehicleStatus: 3.0f];
                }
//                [self sendPostSessionForVehicleStatus: 10.0f];
//                [NSThread sleepForTimeInterval:7.0f];
//                [self sendPostSessionForVehicleStatus: 3.0f];
//                [m_loadingview hideView];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        else if ([result isEqualToString:@"0"]) {
            // 命令执行失败
            NSLog(@"command Result : NO");
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"指令发送失败!"];
                [alert show];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        else if ([result isEqualToString:@"2"]) {
            // 控制失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"控制失败,\n您的车辆不符合控制条件!"];
                [alert show];
                
                flagForVehicleCommand = NO;
            });
            return;
        }

    });
}

- (void) sendPostSessionForCommandForFE {
    flagForVehicleCommand = YES;
    
    NSString * commandcode = nil;
    NSString * controls = nil;
    NSString * commandApiGet = nil;
    NSString * commandApi = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_loadingview setTitile: COMMAND_CHECK_PIN];
        [m_loadingview showView];
        
        // 控制按钮置灰且死锁
        [bt_fe_closel setEnabled: NO];
        [bt_fe_closel setImage:[UIImage imageNamed:@"vctl_closelocken"] forState:UIControlStateNormal];
        [bt_fe_openl setEnabled: NO];
        [bt_fe_openl setImage:[UIImage imageNamed:@"vctl_openlocken"] forState:UIControlStateNormal];
        [bt_fe_closew setEnabled: NO];
        [bt_fe_closew setImage:[UIImage imageNamed:@"vctl_closewindowen"] forState:UIControlStateNormal];
        [bt_fe_openw setEnabled: NO];
        [bt_fe_openw setImage:[UIImage imageNamed:@"vctl_openwindowen"] forState:UIControlStateNormal];
    });
    
    //
    
    
    if (m_codeForCommand == 0) {
        commandcode = @"sendWindowLockCommand";
        controls = @"ControlWindowCommand=1";
        commandApi = @"getWindowLockResult";
        commandApiGet = @"windowResult";
    }
    else if (m_codeForCommand == 1) {
        commandcode = @"sendWindowLockCommand";
        controls = @"ControlWindowCommand=0";
        commandApi = @"getWindowLockResult";
        commandApiGet = @"windowResult";
    }
    else if (m_codeForCommand == 2) {
        commandcode = @"sendDoorLockCommand";
        controls = @"LockDoorCommand=1";
        commandApi = @"getDoorLockResult";
        commandApiGet = @"doorLockResult";
    }
    else if (m_codeForCommand == 3) {
        commandcode = @"sendDoorLockCommand";
        controls = @"LockDoorCommand=0";
        commandApi = @"getDoorLockResult";
        commandApiGet = @"doorLockResult";
    }
    else return;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 发送PIN
        if (m_codeForCommand == 2) {
            
        }
        NSString * code = nil;
        NSString * result = nil;
        NSString * url = [NSString stringWithFormat:@"%@/api/%@", HTTP_GET_POST_ADDRESS, commandcode];
        NSString * body = [NSString stringWithFormat:@"%@&vin=%@&%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin], controls];
        NSDictionary * mdic = [self fetchPostSession:url Body:body];
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        NSLog(@"** %@ %@", commandcode, code);
        
        if (![code isEqualToString:@"200"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
                [alertview show];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        
        // 发送命令查询
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_loadingview setTitile: COMMAND_SENDING];
            [m_loadingview showView];
        });
        url = [NSString stringWithFormat: @"%@/api/getAckInfo", HTTP_GET_POST_ADDRESS];
        body = [NSString stringWithFormat: @"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_COMMANDSTATUS];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
        
        while (sp > 0.0f) {
            if (self.flagForViewHidden) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"self.view.isHidden For Vehicle Status ..");
                });
                return;
            }
            
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            mdic = [self fetchPostSession: url Body: body];
            code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
            result = [mdic objectForKey:@"ackInfoStatus"];
            NSLog(@"** get command ackinfo - %f %@", sp, code);
            if ([result isEqualToString:@"0"] && [code isEqualToString:@"200"]) break;
            
            // 程序暂停 2s
            [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
        }
        
        if (sp < 0.0f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Command Ackinfo Time Out ..");
                [m_loadingview hideView];
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton: NETWORK_TIMEOUT];
                [alertview show];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        
        // 发送命令执行结果查询
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_loadingview setTitile: COMMAND_DOING];
        });
        url = [NSString stringWithFormat:@"%@/api/%@", HTTP_GET_POST_ADDRESS, commandApi];
        body = [NSString stringWithFormat: @"%@&vin=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin]];
        
        sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_COMMANDRESULT];
        sp = [sDate timeIntervalSinceDate:[NSDate date]];
        
        while (sp > 0.0f) {
            if (self.flagForViewHidden) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"self.view.isHidden For Vehicle Status ..");
                });
                return;
            }
            
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            mdic = [self fetchPostSession:url Body:body];
            code = [[mdic objectForKey: @"status"]objectForKey:@"code"];
            result = [mdic objectForKey:commandApiGet];
            NSLog(@"** get command result - %f %@", sp, result);
            
            if ([code isEqualToString:@"200"] && [result isEqualToString:@"1"]) break;
            if ([code isEqualToString:@"200"] && [result isEqualToString:@"2"]) break;
            if ([code isEqualToString:@"200"] && [result isEqualToString:@"0"]) break;
            
            // 暂停 2s
            [NSThread sleepForTimeInterval: POST_WHILE_SPACE];
        }
        
        if (sp < 0.0f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Command Ackinfo Time Out ..");
                [m_loadingview hideView];
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton: NETWORK_TIMEOUT];
                [alertview show];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        
        if ([result isEqualToString:@"1"]) {
            // 命令执行成功  5s刷新车况
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview setTitile: @"正在刷新车况"];
                [m_loadingview showView];
                
                if (m_codeForCommand == 1) [self sendPostSessionForVehicleStatusONFE: YES];
                else [self sendPostSessionForVehicleStatusONFE: NO];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        else if ([result isEqualToString:@"0"]) {
            // 命令执行失败
            NSLog(@"command Result : NO");
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"指令发送失败!"];
                [alert show];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        else if ([result isEqualToString:@"2"]) {
            // 控制失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview hideView];
                AlertBoxView * alert = [[AlertBoxView alloc]initWithOKButton:@"控制失败,\n您的车辆不符合控制条件!"];
                [alert show];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
    });
}

- (void) sendPostSessionForCommandForKC: (NSInteger) commandCode {
    flagForVehicleCommand = YES;
    [m_loadingview setTitile: COMMAND_CHECK_PIN];
    [m_loadingview showView];
    
    // 控制按钮置灰且死锁
    [bt_ctrllockKC setEnabled:NO];
    [bt_ctrllockKC setImage:[UIImage imageNamed:@"vctl_closelocken"] forState:UIControlStateNormal];
    [bt_ctrlwindowKC setEnabled:NO];
    [bt_ctrlwindowKC setImage:[UIImage imageNamed:@"vctl_closewindowen"] forState:UIControlStateNormal];
    
    NSString * commandApi = nil;
    if (commandCode == 0) commandApi = @"CLOSE-WINDOW";
    if (commandCode == 1) commandApi = @"CLOSE-DOOR";
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * code = nil;
        NSString * result = nil;
        // send command - 1
        NSString * url = [NSString stringWithFormat:@"%@/system/command/send", HTTP_GET_POST_ADDRESS_KC];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject: [self.UserInfo gKCTuid] forKey:@"tuid"];
        [dict setObject: [self.UserInfo gTelePhoneNum] forKey:@"mobilenumber"];
        [dict setObject: [self.UserInfo gAccessToken] forKey:@"access_token"];
        [dict setObject: [self.UserInfo gKCUuid] forKey:@"uuid"];
        NSMutableDictionary * body = [[NSMutableDictionary alloc]init];
        [body setObject: dict forKey: @"ntspheader"];
        [body setObject: @"1" forKey: @"isInstant"];
        [body setObject: commandApi forKey: @"type"];
        [body setObject: APP_VERSION_CODE forKey: @"version"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_loadingview setTitile: COMMAND_SENDING];
            [m_loadingview showView];
        });
        
        NSDictionary * mdic = [self fetchPostSessionForKC:url Body:body];
        code = [[mdic objectForKey:@"errcode"] stringValue];
        result = [[mdic objectForKey: @"data"] objectForKey:@"msg_id"];
        if (![code isEqualToString:@"0"]) {
            // Error
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * str = [mdic objectForKey:@"errmsg"];
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:str];
                alertview.okBlock = ^(){
                    [m_loadingview hideView];
                    flagForVehicleCommand = NO;
                };
                [alertview show];
            });
            return;
        }
        
        // 关窗 ＋ 关天窗
        /*
        if (commandCode == 0) {
            body = [[NSMutableDictionary alloc]init];
            [body setObject: dict forKey: @"ntspheader"];
            [body setObject: @"1" forKey: @"isInstant"];
            [body setObject: @"CLOSE-DORMER" forKey: @"type"];
            [body setObject: APP_VERSION_CODE forKey: @"version"];
            
            mdic = [self fetchPostSessionForKC:url Body:body];
            code = [[mdic objectForKey:@"errcode"] stringValue];
            result = [[mdic objectForKey: @"data"] objectForKey:@"msg_id"];
            if (![code isEqualToString:@"0"]) {
                // Error
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString * str = [mdic objectForKey:@"errmsg"];
                    AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:str];
                    alertview.okBlock = ^(){
                        [m_loadingview hideView];
                        flagForVehicleCommand = NO;
                    };
                    [alertview show];
                });
                return;
            }
        } */

        // 命令执行结果
        url = [NSString stringWithFormat:@"%@/system/command/query11", HTTP_GET_POST_ADDRESS_KC];
        [body removeAllObjects];
        [body setObject: dict forKey: @"ntspheader"];
        [body setObject: @"0" forKey: @"start"];
        [body setObject: @"1" forKey: @"rows"];
        [body setObject: result forKey: @"msg_id"];
        
//        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow: POST_TIME_FOR_COMMANDSTATUS];
        NSDate * sDate = [NSDate dateWithTimeIntervalSinceNow: 30.0f];
        NSTimeInterval sp = [sDate timeIntervalSinceDate:[NSDate date]];
        
        NSDictionary * dicRes = nil;
        
        BOOL flag = NO;
        while (sp > 0.0f) {
            if (self.flagForViewHidden) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"self.view.isHidden For Vehicle Status ..");
                });
                return;
            }
            
            sp = [sDate timeIntervalSinceDate:[NSDate date]];
            
            mdic = [self fetchPostSessionForKC: url Body: body];
            code = [[mdic objectForKey:@"errcode"] stringValue];
            if (![code isEqualToString:@"0"]) break;
            
            // 发送结果 0:等待处理 1:等待发送 2:正在发送 5:发送成功 9:发送失败
            NSArray * list = [[mdic objectForKey:@"data"] objectForKey:@"cmd_list"];
            result = [[[list objectAtIndex:0] objectForKey: @"send_state"] stringValue];
            if ([result isEqualToString:@"9"]) {
                result = @"0";      // 发送失败
                break;
            }
            else if ([result isEqualToString:@"5"] && !flag) {
                // 下发成功
                flag = YES;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [m_loadingview setTitile: COMMAND_DOING];
                    [m_loadingview showView];
                });
            }
            
            // 执行结果 0:等待处理 1:执行成功 2:执行失败 3:命令超时
            dicRes = [list objectAtIndex:0];
            result = [[dicRes objectForKey: @"execute_state"] stringValue];
            if (![result isEqualToString:@"0"]) break;

            // 程序暂停 2s
            [NSThread sleepForTimeInterval:POST_WHILE_SPACE];
        }
        
        // ******************
        if (![code isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * str = [mdic objectForKey:@"errmsg"];
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:str];
                alertview.okBlock = ^(){
                    [m_loadingview hideView];
                    flagForVehicleCommand = NO;
                    
                    // 报错后放开操作按钮
                    [self setViewForVehicleStatus];
                };
                [alertview show];
            });
            return;
        }
        
        if (sp < 0.0f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Post Session For Command Ackinfo Time Out ..");
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton: NETWORK_TIMEOUT];
                alertview.okBlock = ^(){
                    [m_loadingview hideView];
                    flagForVehicleCommand = NO;
                    
                    // 报错后放开操作按钮
                    [self setViewForVehicleStatus];
                };
                [alertview show];
            });
            return;
        }

        if ([result isEqualToString:@"1"]) {
            // 命令执行成功
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_loadingview setTitile: @"正在刷新车况"];
                
                if (commandCode == 0) [NSThread sleepForTimeInterval: 7.0f];
                [self sendPostSessionForKCVehicleStatus];
                
                flagForVehicleCommand = NO;
            });
            return;
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * str = [dicRes objectForKey: @"execute_desc"];
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:str];
                alertview.okBlock = ^(){
                    [m_loadingview hideView];
                    flagForVehicleCommand = NO;
                    
                    // 报错后放开操作按钮
                    [self setViewForVehicleStatus];
                    
                };
                [alertview show];
            });
            return;
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//
- (void) setObjectForVehicleStatus:(NSDictionary *) dic {
    // 左前门
    [m_vehicle setFrontLDoorStatus: [self getObjectStatusForVehicle:[dic objectForKey:@"leftFrontDoorStatus"] Windows:[dic objectForKey:@"no1WindowStatus"]]];
    // 右前门
    [m_vehicle setFrontRDoorStatus: [self getObjectStatusForVehicle:[dic objectForKey:@"rightFrontDoorStatus"] Windows:[dic objectForKey:@"no2WindowStatus"]]];
    // 左后门
    [m_vehicle setRearLDoorStatus: [self getObjectStatusForVehicle:[dic objectForKey:@"leftRearDoorStatus"] Windows:[dic objectForKey:@"no3WindowStatus"]]];
    // 右后门
    [m_vehicle setRearRDoorStatus: [self getObjectStatusForVehicle:[dic objectForKey:@"rightRearDoorStatus"] Windows:[dic objectForKey:@"no4WindowStatus"]]];
    // 天窗
    [m_vehicle setDormerStatus: [[NSString stringWithString:[dic objectForKey:@"dormerStatus"]] intValue]];
    // 后备箱
    [m_vehicle setTrunkStatus: [[NSString stringWithString:[dic objectForKey:@"trunkStatus"]] intValue]];
    // 车锁
    if ([[dic objectForKey:@"doorLockState"] isEqualToString:@"1"]) [m_vehicle setLockStatus: 1];
    else [m_vehicle setLockStatus: 0];
    
    // 车窗
    NSInteger status = [[NSString stringWithString:[dic objectForKey:@"no1WindowStatus"]] intValue];
    status += [[NSString stringWithString:[dic objectForKey:@"no2WindowStatus"]] intValue];
    status += [[NSString stringWithString:[dic objectForKey:@"no3WindowStatus"]] intValue];
    status += [[NSString stringWithString:[dic objectForKey:@"no4WindowStatus"]] intValue];
    if (status == 0) [m_vehicle setWindowStatus: 0];
    else [m_vehicle setWindowStatus: 1];
    
    [m_vehicle showAllStatus];
    [self setViewForVehicleStatus];
}

- (void) setObjectForVehicleStatusForKC:(NSDictionary *) dic {
    // 左前门
    [m_vehicle setFrontLDoorStatus: [self getObjectStatusForVehicleForKC:[[dic objectForKey:@"doorand_trunk"] objectForKey:@"driver_door_status"] Windows:[[dic objectForKey:@"window"] objectForKey:@"driver_window_status"]]];
    // 右前门
    [m_vehicle setFrontRDoorStatus: [self getObjectStatusForVehicleForKC:[[dic objectForKey:@"doorand_trunk"] objectForKey:@"copilot_door_status"] Windows:[[dic objectForKey:@"window"] objectForKey:@"copilot_window_status"]]];
    // 左后门
    [m_vehicle setRearLDoorStatus: [self getObjectStatusForVehicleForKC:[[dic objectForKey:@"doorand_trunk"] objectForKey:@"real_left_door_status"] Windows:[[dic objectForKey:@"window"] objectForKey:@"rear_left_window_status"]]];
    // 右后门
    [m_vehicle setRearRDoorStatus: [self getObjectStatusForVehicleForKC:[[dic objectForKey:@"doorand_trunk"] objectForKey:@"real_right_door_status"] Windows:[[dic objectForKey:@"window"] objectForKey:@"rear_right_window_status"]]];
    // 天窗
    NSInteger value = [[[dic objectForKey:@"window"] objectForKey:@"sunroof_status"] intValue];
    [m_vehicle setDormerStatus: (value == 0 ? 0 : 1)];
    // 后备箱
    value = [[[dic objectForKey:@"doorand_trunk"] objectForKey:@"trunk_status"] intValue];
    [m_vehicle setTrunkStatus: (value == 0 ? 0 : 1)];
    // 车锁
    value = [[[dic objectForKey:@"doorand_trunk"] objectForKey:@"door_status"] intValue];
    [m_vehicle setLockStatus: (value == 0 ? 0 : 1)];
    
    // 车窗
    NSInteger status = [[[dic objectForKey:@"window"] objectForKey:@"copilot_window_status"] intValue];
    status += [[[dic objectForKey:@"window"] objectForKey:@"driver_window_status"] intValue];
    status += [[[dic objectForKey:@"window"] objectForKey:@"rear_left_window_status"] intValue];
    status += [[[dic objectForKey:@"window"] objectForKey:@"rear_right_window_status"] intValue];
    if (status == 0) [m_vehicle setWindowStatus: 0];
    else [m_vehicle setWindowStatus: 1];
    
    [m_vehicle showAllStatus];
    [self setViewForVehicleStatus];
}

- (void) setViewForVehicleStatus {
    // label & button status
    NSString * status = nil;
    if ([m_vehicle getLockStatus] == 0) {
        status = @"已关闭";
        [bt_openl setImage:[UIImage imageNamed:@"vctl_openlock"] forState:UIControlStateNormal];
        [bt_openl setEnabled:YES];
        [bt_closel setImage:[UIImage imageNamed:@"vctl_closelocken"] forState:UIControlStateNormal];
        [bt_closel setEnabled:NO];
        
        // fe
        [bt_fe_openl setImage:[UIImage imageNamed:@"vctl_openlock"] forState:UIControlStateNormal];
        [bt_fe_openl setEnabled:YES];
        [bt_fe_closel setImage:[UIImage imageNamed:@"vctl_closelocken"] forState:UIControlStateNormal];
        [bt_fe_closel setEnabled:NO];

        [bt_ctrllockKC setImage:[UIImage imageNamed:@"vctl_closelocken"] forState:UIControlStateNormal];
        [bt_ctrllockKC setEnabled: NO];          // test
    }
    else {
        status = @"已开启";
        [bt_openl setImage:[UIImage imageNamed:@"vctl_openlocken"] forState:UIControlStateNormal];
        [bt_openl setEnabled:NO];
        [bt_closel setImage:[UIImage imageNamed:@"vctl_closelock"] forState:UIControlStateNormal];
        [bt_closel setEnabled:YES];
        
        // fe
        [bt_fe_openl setImage:[UIImage imageNamed:@"vctl_openlocken"] forState:UIControlStateNormal];
        [bt_fe_openl setEnabled:NO];
        [bt_fe_closel setImage:[UIImage imageNamed:@"vctl_closelock"] forState:UIControlStateNormal];
        [bt_fe_closel setEnabled:YES];
        
        [bt_ctrllockKC setImage:[UIImage imageNamed:@"vctl_closelock"] forState:UIControlStateNormal];
        [bt_ctrllockKC setEnabled: YES];
    }
    [la_statuslock setText:[NSString stringWithFormat:@"车锁:%@", status]];
    
    if ([m_vehicle getWindowStatus] == 0 && [m_vehicle getDormerStatus] == 0) {
        status = @"已关闭";
        [bt_openw setImage:[UIImage imageNamed:@"vctl_openwindow"] forState:UIControlStateNormal];
        [bt_openw setEnabled: YES];
        [bt_closew setImage:[UIImage imageNamed:@"vctl_closewindowen"] forState:UIControlStateNormal];
        [bt_closew setEnabled: NO];
        
        //
        [bt_fe_openw setImage:[UIImage imageNamed:@"vctl_openwindow"] forState:UIControlStateNormal];
        [bt_fe_openw setEnabled: YES];
        [bt_fe_closew setImage:[UIImage imageNamed:@"vctl_closewindowen"] forState:UIControlStateNormal];
        [bt_fe_closew setEnabled: NO];
        
        [bt_ctrlwindowKC setImage:[UIImage imageNamed:@"vctl_closewindowen"] forState:UIControlStateNormal];
        [bt_ctrlwindowKC setEnabled: NO];
    }
    else if ([m_vehicle getWindowStatus] == 0 && [m_vehicle getDormerStatus] != 0) {
        status = @"已开启";
        [bt_openw setImage:[UIImage imageNamed:@"vctl_openwindowen"] forState:UIControlStateNormal];
        [bt_openw setEnabled: NO];
        [bt_closew setImage:[UIImage imageNamed:@"vctl_closewindow"] forState:UIControlStateNormal];
        [bt_closew setEnabled: YES];
        
        // fe
        if ([[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GS"] ||
            [[self.UserInfo gDefaultVehicleType]isEqualToString:@"帝豪GL"]) {
            status = @"已关闭";
        }
        [bt_fe_openw setImage:[UIImage imageNamed:@"vctl_openwindow"] forState:UIControlStateNormal];
        [bt_fe_openw setEnabled: YES];
        [bt_fe_closew setImage:[UIImage imageNamed:@"vctl_closewindowen"] forState:UIControlStateNormal];
        [bt_fe_closew setEnabled: NO];
        
        [bt_ctrlwindowKC setImage:[UIImage imageNamed:@"vctl_closewindow"] forState:UIControlStateNormal];
        [bt_ctrlwindowKC setEnabled: YES];
    }
    else {
        status = @"已开启";
        [bt_openw setImage:[UIImage imageNamed:@"vctl_openwindowen"] forState:UIControlStateNormal];
        [bt_openw setEnabled: NO];
        [bt_closew setImage:[UIImage imageNamed:@"vctl_closewindow"] forState:UIControlStateNormal];
        [bt_closew setEnabled: YES];
        
        // fe
        [bt_fe_openw setImage:[UIImage imageNamed:@"vctl_openwindowen"] forState:UIControlStateNormal];
        [bt_fe_openw setEnabled: NO];
        [bt_fe_closew setImage:[UIImage imageNamed:@"vctl_closewindow"] forState:UIControlStateNormal];
        [bt_fe_closew setEnabled: YES];
        
        // KC
        [bt_ctrlwindowKC setImage:[UIImage imageNamed:@"vctl_closewindow"] forState:UIControlStateNormal];
        [bt_ctrlwindowKC setEnabled: YES];
    }
    [la_statuswindow setText:[NSString stringWithFormat:@"车窗:%@", status]];
    
//    if ([m_vehicle getLockStatus] == 0 && [m_vehicle getWindowStatus] == 0 && [m_vehicle getDormerStatus] == 0) {
//        [bt_ctrlboth setImage:[UIImage imageNamed:@"vctl_closeall"] forState:UIControlStateNormal];
//        [bt_ctrlboth setEnabled:NO];
//    }
//    else {
//        [bt_ctrlboth setImage:[UIImage imageNamed:@"vctl_closeallen"] forState:UIControlStateNormal];
//        [bt_ctrlboth setEnabled: YES];
//    }
    
    // view status
    [im_windd setHidden: ([m_vehicle getDormerStatus] == 0) ? YES : NO];
    
    // 后备箱
    NSInteger value = [m_vehicle getTrunkStatus];
    NSString * imagename = @"0";
    if (value == 1) imagename = [imagename stringByAppendingString:@"1"];
    else imagename = [imagename stringByAppendingString:@"0"];
    
    value = [m_vehicle getFrontLDoorStatus];
    [im_winfl setHidden: (value % 2 == 0) ? YES : NO];
    if (value > 1) {
        // k m k c
        [im_winfl setImage:[UIImage imageNamed:[m_windowsTypeName stringByAppendingString:@"01"]]];
        imagename = [imagename stringByAppendingString:@"1"];
    }
    else {
        [im_winfl setImage:[UIImage imageNamed:[m_windowsTypeName stringByAppendingString:@"1"]]];
        imagename = [imagename stringByAppendingString:@"0"];
    }

    value = [m_vehicle getFrontRDoorStatus];
    [im_winfr setHidden: (value % 2 == 0) ? YES : NO];
    if (value > 1) {
        // k m k c
        [im_winfr setImage:[UIImage imageNamed:[m_windowsTypeName stringByAppendingString:@"02"]]];
        imagename = [imagename stringByAppendingString:@"1"];
    }
    else {
        [im_winfr setImage:[UIImage imageNamed:[m_windowsTypeName stringByAppendingString:@"2"]]];
        imagename = [imagename stringByAppendingString:@"0"];
    }
    
    value = [m_vehicle getRearLDoorStatus];
    [im_winrl setHidden: (value % 2 == 0) ? YES : NO];
    if (value > 1) {
        // k m k c
        [im_winrl setImage:[UIImage imageNamed:[m_windowsTypeName stringByAppendingString:@"03"]]];
        imagename = [imagename stringByAppendingString:@"1"];
    }
    else {
        [im_winrl setImage:[UIImage imageNamed:[m_windowsTypeName stringByAppendingString:@"3"]]];
        imagename = [imagename stringByAppendingString:@"0"];
    }
    
    value = [m_vehicle getRearRDoorStatus];
    [im_winrr setHidden: (value % 2 == 0) ? YES : NO];
    if (value > 1) {
        // k m k c
        [im_winrr setImage:[UIImage imageNamed:[m_windowsTypeName stringByAppendingString:@"04"]]];
        imagename = [imagename stringByAppendingString:@"1"];
    }
    else {
        [im_winrr setImage:[UIImage imageNamed:[m_windowsTypeName stringByAppendingString:@"4"]]];
        imagename = [imagename stringByAppendingString:@"0"];
    }
    
    NSLog(@"image : status %@", [m_vehicleTypeName stringByAppendingString:imagename]);
    [im_vehicle setImage: [UIImage imageNamed: [m_vehicleTypeName stringByAppendingString:imagename]]];
}

- (void) doPinCodeViewclickedOK:(id)sender {
    [self textfield_TouchDown:self];
    [m_pinEditorView hideView];
    
    m_pinCode = m_pinEditorView.code;
    NSLog(@"** PinCode: %@  IdentifyTime: %@", m_pinEditorView.code, m_timeForIdentify);
    [m_loadingview setTitile: COMMAND_CHECK_PIN];
    [m_loadingview showView];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * code = nil;
        NSString * url = [NSString stringWithFormat:@"%@/api/checkPin", HTTP_GET_POST_ADDRESS];
        NSString * body = [NSString stringWithFormat:@"%@&vin=%@&PIN=%@", self.userfixstr, [self.UserInfo gDefaultVehicleVin], m_pinCode];
        NSDictionary * mdic = [self fetchPostSession:url Body:body];
        code = [[mdic objectForKey:@"status"]objectForKey:@"code"];
        
        if ([code isEqualToString:@"200"]) {
            m_timeForIdentify = [NSDate date];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_refrese finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                [m_loadingview hideView];
                m_timeForIdentify = nil;
                
                AlertBoxView * alertview = [[AlertBoxView alloc] initWithOKButton:[ExtendStaticFunctions getServerErrorMessage:code]];
                [alertview show];
            });
            return;
        }

        // PIN 码正确执行指令
        [self sendPostSessionForCommand];
    });
}

- (void) doPinCodeViewclickedNO:(id)sender {
    [self textfield_TouchDown:self];
    m_timeForIdentify = nil;
    [m_pinEditorView hideView];
    NSLog(@"pin code : %@", m_pinEditorView.code);
}

- (IBAction) doIntoHelp:(id)sender {
    VehicleHelpViewController * view = [[VehicleHelpViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction) doIntoControlList:(id)sender {
    VehicleCtrlListViewController * view = [[VehicleCtrlListViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction) clickedWindowOpen:(id)sender {
    m_codeForCommand = 0;
    
    CGFloat timeSpace = [m_timeForIdentify timeIntervalSinceNow];
    NSLog(@"** Remand Time %f", timeSpace + PINCODE_TIME_SPACE);
    if (timeSpace + PINCODE_TIME_SPACE < 0.0f || timeSpace == 0.0f) {
        m_timeForIdentify = nil;
        m_pinCode = nil;
        [m_pinEditorView showView];
    }
    else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self sendPostSessionForCommand];
        });
    }
}

- (IBAction) clickedWindowClose:(id)sender {
    m_codeForCommand = 1;
    
//    CGFloat timeSpace = [m_timeForIdentify timeIntervalSinceNow];
//    NSLog(@"** Remand Time %f", timeSpace + PINCODE_TIME_SPACE);
//    if (timeSpace + PINCODE_TIME_SPACE < 0.0f || timeSpace == 0.0f) {
//        m_timeForIdentify = nil;
//        m_pinCode = nil;
//        [m_pinEditorView showView];
//    }
//    else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self sendPostSessionForCommand];
        });
//    }
}

- (IBAction) clickedLockOpen:(id)sender {
    m_codeForCommand = 2;
    
    CGFloat timeSpace = [m_timeForIdentify timeIntervalSinceNow];
    NSLog(@"** Remand Time %f", timeSpace + PINCODE_TIME_SPACE);
    if (timeSpace + PINCODE_TIME_SPACE < 0.0f || timeSpace == 0.0f) {
        m_timeForIdentify = nil;
        m_pinCode = nil;
        [m_pinEditorView showView];
    }
    else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self sendPostSessionForCommand];
        });
    }
}

- (IBAction) clickedLockClose:(id)sender {
    m_codeForCommand = 3;
    
//    CGFloat timeSpace = [m_timeForIdentify timeIntervalSinceNow];
//    NSLog(@"** Remand Time %f", timeSpace + PINCODE_TIME_SPACE);
//    if (timeSpace + PINCODE_TIME_SPACE < 0.0f || timeSpace == 0.0f) {
//        m_timeForIdentify = nil;
//        m_pinCode = nil;
//        [m_pinEditorView showView];
//    }
//    else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self sendPostSessionForCommand];
        });
//    }
}

// Control Command For FE
- (IBAction) clickedWindowOpenForFE:(id)sender {
    m_codeForCommand = 0;
    
    CGFloat timeSpace = [m_timeForIdentify timeIntervalSinceNow];
    NSLog(@"** Remand Time %f", timeSpace + PINCODE_TIME_SPACE);
    if (timeSpace + PINCODE_TIME_SPACE < 0.0f || timeSpace == 0.0f) {
        m_timeForIdentify = nil;
        m_pinCode = nil;
        [m_pinEditorView showView];
    }
    else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self sendPostSessionForCommandForFE];
        });
    }
}

- (IBAction) clickedWindowCloseForFE:(id)sender {
    m_codeForCommand = 1;
    
//    CGFloat timeSpace = [m_timeForIdentify timeIntervalSinceNow];
//    NSLog(@"** Remand Time %f", timeSpace + PINCODE_TIME_SPACE);
//    if (timeSpace + PINCODE_TIME_SPACE < 0.0f || timeSpace == 0.0f) {
//        m_timeForIdentify = nil;
//        m_pinCode = nil;
//        [m_pinEditorView showView];
//    }
//    else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self sendPostSessionForCommandForFE];
        });
//    }
}

- (IBAction) clickedLockOpenForFE:(id)sender {
    m_codeForCommand = 2;
    
    CGFloat timeSpace = [m_timeForIdentify timeIntervalSinceNow];
    NSLog(@"** Remand Time %f", timeSpace + PINCODE_TIME_SPACE);
    if (timeSpace + PINCODE_TIME_SPACE < 0.0f || timeSpace == 0.0f) {
        m_timeForIdentify = nil;
        m_pinCode = nil;
        [m_pinEditorView showView];
    }
    else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self sendPostSessionForCommandForFE];
        });
    }
}

- (IBAction) clickedLockCloseForFE:(id)sender {
    m_codeForCommand = 3;
    
//    CGFloat timeSpace = [m_timeForIdentify timeIntervalSinceNow];
//    NSLog(@"** Remand Time %f", timeSpace + PINCODE_TIME_SPACE);
//    if (timeSpace + PINCODE_TIME_SPACE < 0.0f || timeSpace == 0.0f) {
//        m_timeForIdentify = nil;
//        m_pinCode = nil;
//        [m_pinEditorView showView];
//    }
//    else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self sendPostSessionForCommandForFE];
        });
//    }
}

//- (IBAction) clickedBothCtrl:(id)sender {
//    m_codeForCommand = 2;
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self sendPostSessionForCommand];
//    });

//    CGFloat timeSpace = [m_timeForIdentify timeIntervalSinceNow];
//    if (timeSpace + PINCODE_TIME_SPACE < 0.0f || timeSpace == 0.0f) {
//        m_timeForIdentify = nil;
//        m_pinCode = nil;
//        [m_pinEditorView showView];
//    }
//    else {
//
//    }
//}

- (IBAction) clickedWindowCtrlKC:(id)sender {
//    m_codeForCommand = 3;
//    [m_pinEditorView showView];
    
    [self sendPostSessionForCommandForKC: 0];
}

- (IBAction) clickedLockCtrlKC:(id)sender {
//    m_codeForCommand = 4;
//    [m_pinEditorView showView];
    
    [self sendPostSessionForCommandForKC: 1];
}



- (NSInteger) getObjectStatusForVehicle:(NSString *)DoorStatus Windows:(NSString *)WindowStatus {
    NSInteger resStatus = 0;
    if ([DoorStatus intValue] > 0) resStatus = 2;
    resStatus += [WindowStatus intValue];
    
    return resStatus;
}

- (NSInteger) getObjectStatusForVehicleForKC:(NSString *)DoorStatus Windows:(NSString *)WindowStatus {
    NSInteger resStatus = 0;
    if ([DoorStatus intValue] != 0 && [DoorStatus intValue] != 1) resStatus = 2;
    if ([WindowStatus intValue] != 0) resStatus += 1;
    
    return resStatus;
}

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
