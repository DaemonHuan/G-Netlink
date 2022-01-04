//
//  HelpViewController.m
//  G-NetLink-v1.0
//
//  Created by jk on 1/19/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "HelpViewController.h"
#import "public.h"

#define SPACE_XX 12.0f

@interface HelpViewController ()

@end

@implementation HelpViewController {
    IBOutlet UIScrollView * m_centorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"使用帮助";
    
    CGFloat wx = [UIScreen mainScreen].bounds.size.width;
    CGFloat appendY = 0.0f;
    CGFloat yy = 0.0f;
    UILabel * one = [self newTitleLable:@"系统操作"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 80.0f)];
    [m_centorView addSubview: one];
    yy += 80.0f;
    
    one = [self newNameLable:@"登录"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;

    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t您可以在登录页面输入账号、密码并选择车型，完成登录操作。\n\t注：您可以在登录时选择“记住密码”，在下次登录时，无需再次输入账号、密码；您也可以选择“自动登录”，在下次登录时，点击桌面图标自动完成登录操作。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"找回密码"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;

    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t当您忘记密码，可点击“找回密码”，进入修改密码页面，通过验证码鉴权后，可直接设置新密码。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newTitleLable:@"常规操作"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - 24.0f, 80.0f)];
    [m_centorView addSubview: one];
    yy += 80.0f;
    
    one = [self newNameLable:@"首页"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t登录成功后，您可以在首页直接查看车门车窗和车锁的详细状态、可续航里程和告警信息，还可以通过“一键服务”直接拨叫服务中心，尽享体贴、便捷的人工服务。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"车辆控制"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t在车辆熄火的状态下，您可以通过“车辆控制”，对车锁、车窗进行远程控制。\n\t远程控制前请您先输入Pin码。\n\t车锁控制时车辆需处于车门关闭、车辆熄火、档位为P/N档的状态；车窗控制时车辆需处于熄火、档位为P/N档状态。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"车辆位置"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t您可以在“车辆位置”页随时查看车辆位置，寻找爱车。\n您也可以通过发送“闪灯鸣笛”指令寻找爱车。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"发送目的地"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t您可以通过G-NetLink中“发送目的地”功能，在手机APP中设置目的地并一键下发至爱车，为您提前做好出行安排。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"行车日志"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t“行车日志”为您记录每一段行程、每一段与吉利汽车的点点滴滴。\n\t行车日志默认打开最近7天的记录，可通过筛选功能查看任意时间的行车日志，筛选的最长区间为一个月。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"仪表台"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t安放在您手机中的仪表台，一切尽在您的掌控之中。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"告警"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\tG-NetLink支持360°诊断爱车，让您随时随地了解爱车的“健康”状况。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"一键服务"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t您可以一键拨叫服务中心，享受贴心的话务员服务，让车联网一路随行、无处不在。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"切换车辆"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t如您拥有多辆同一车型吉利汽车，可通过对车辆的切换，了解各辆爱车的相关信息。\n\t如您拥有不同款吉利汽车，需注销登录，在登录时重新选择车型。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY;
    
    m_centorView.contentSize = CGSizeMake(wx, yy + 100.0f);
}

- (UILabel *) newTitleLable:(NSString *)title {
    UILabel * label = [[UILabel alloc]init];
    [label setTextColor:[UIColor colorWithHexString:WORD_COLOR]];
    [label setFont: [UIFont fontWithName:FONT_MM size:20.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:title];
    
    return label;
}

- (UILabel *) newNameLable:(NSString *)title {
    UILabel * label = [[UILabel alloc]init];
    [label setFont: [UIFont fontWithName:FONT_MM size:18.0f]];
    [label setTextColor:[UIColor colorWithHexString:@"00A0E9"]];
    [label setText:title];
    
    return label;
}

- (UILabel *) newContextLable:(CGFloat)xx Y:(CGFloat)yy Title:(NSString *)title {
    UILabel * label = [[UILabel alloc]init];
    [label setFont: [UIFont fontWithName:FONT_MM size:17.0f]];
    [label setTextColor:[UIColor whiteColor]];
    [label setLineBreakMode:NSLineBreakByCharWrapping];
    [label setNumberOfLines:0];
    [label setText:title];
    CGSize size = [label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - (2 * SPACE_XX), 1000.0f)];
    [label setFrame:CGRectMake(xx, yy, size.width, size.height + 20.0f)];

    return label;
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
