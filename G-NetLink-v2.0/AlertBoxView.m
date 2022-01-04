//
//  AlertBoxView.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/18/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "AlertBoxView.h"
#import "public.h"

#define sizeTitleHeight 40.0f
#define sizeMsgHeight 120.0f
#define sizeAlertToSide 30.0f
#define sizeTwoButtonSide 30.0f
#define sizeSingleButtonSide 40.0f

@implementation AlertBoxView {
    UILabel * lb_Title;
    UILabel * lb_Message;
    UIButton * bt_OK;
    UIButton * bt_NO;
    
    UIView * backBroudView;
    
    CGFloat popWidth;
    CGFloat popHeight;
    CGFloat alertViewHeight;
    CGFloat alertViewWidth;
}

@synthesize centerView;
@synthesize okBlock,exBlock;

- (id) initWithTitle:(NSString *)msg Enter:(NSString *)btOK Cancle:(NSString *)btEX {
    if (self = [super init]) {
        // config top
        CGFloat wx = [UIScreen mainScreen].bounds.size.width;
        CGFloat hy = [UIScreen mainScreen].bounds.size.height;
        
        CGFloat tw = wx * 0.8f;
        CGFloat th = (hy - 64.0f) * 0.3f;
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5.0f;
        [self setFrame:CGRectMake((wx - tw) * 0.5f, (hy - th) * 0.5f, tw, th)];
        
        UIImageView * bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_alertview1"]];
        [bg setFrame:CGRectMake(0.0f, 0.0f, tw, th)];
        [self addSubview: bg];
        
        // config Message
        lb_Message = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 8.0f, tw - 16.0f, sizeMsgHeight)];
        lb_Message.textColor = [UIColor whiteColor];
        [lb_Message setTextAlignment:NSTextAlignmentCenter];
        [lb_Message setText: msg];
        [lb_Message setFont: [UIFont fontWithName:FONT_XI size: 17.0f]];
        [lb_Message setLineBreakMode:NSLineBreakByWordWrapping];
        lb_Message.numberOfLines = 0;
        [self addSubview: lb_Message];
        
        // config buttons
        CGFloat btw = (tw - 16.0f * 4.0f) * 0.5f;
        CGRect btnFrame01 = CGRectMake(16.0f, th - 50.0f, btw, 40.0f);
        CGRect btnFrame02 = CGRectMake(btw + 48.0f,th - 50.0f, btw, 40.0f);
        bt_OK = [[UIButton alloc]initWithFrame:btnFrame02];
        [bt_OK setTitle:btOK forState:UIControlStateNormal];
        [bt_OK.titleLabel setFont:[UIFont fontWithName:FONT_MM size:20.0f]];
                [bt_OK setTitleColor:[UIColor colorWithHexString: WORD_COLOR_GLODEN] forState:UIControlStateNormal];
        [bt_OK addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt_OK];
        
        bt_NO = [[UIButton alloc]initWithFrame:btnFrame01];
        [bt_NO setTitle:btEX forState:UIControlStateNormal];
        [bt_NO.titleLabel setFont:[UIFont fontWithName:FONT_MM size:20.0f]];
        [bt_NO setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bt_NO addTarget:self action:@selector(exBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt_NO];
    }
    return self;
}

- (id) initWithOKButton:(NSString *)msg {
    if (self = [super init]) {
        // config top
        CGFloat wx = [UIScreen mainScreen].bounds.size.width;
        CGFloat hy = [UIScreen mainScreen].bounds.size.height;
        
        CGFloat tw = wx * 0.8f;
        CGFloat th = (hy - 64.0f) * 0.3f;
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5.0f;
        [self setFrame:CGRectMake((wx - tw) * 0.5f, (hy - th) * 0.5f, tw, th)];
        
        UIImageView * bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_alertview2"]];
        [bg setFrame:CGRectMake(0.0f, 0.0f, tw, th)];
        [self addSubview: bg];
        
        // config Message
        lb_Message = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 8.0f, tw - 16.0f, sizeMsgHeight)];
        lb_Message.textColor = [UIColor whiteColor];
        [lb_Message setTextAlignment:NSTextAlignmentCenter];
        [lb_Message setText: msg];
        [lb_Message setFont:[UIFont fontWithName:FONT_MM size:20.0f]];
        [lb_Message setLineBreakMode:NSLineBreakByWordWrapping];
        lb_Message.numberOfLines = 0;
        [self addSubview: lb_Message];
        
        // config OK Button
        CGRect btnFrame = CGRectMake( 8.0f, th - 50.0f, tw - 16.0f, 30.0f);
        bt_OK = [[UIButton alloc]initWithFrame:btnFrame];
        [bt_OK setTitle:@"确 定" forState:UIControlStateNormal];
        [bt_OK.titleLabel setFont:[UIFont fontWithName:FONT_MM size: 17.0f]];
        [bt_OK setTitleColor:[UIColor colorWithHexString: WORD_COLOR_GLODEN] forState:UIControlStateNormal];
        
        [bt_OK addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt_OK];
        
        alertViewHeight = sizeMsgHeight + 60.0f + 8.0f * 3.0;
    }
    return self;
}

- (void) dealloc { }

- (void) okBtnClicked:(id)sender
{
    __strong __typeof(self) strongSelf = self;
    [strongSelf dismissAlert];
    if (strongSelf.okBlock != nil) {
        strongSelf.okBlock();
    }
}

- (void) exBtnClicked:(id)sender
{
    __strong __typeof(self) strongSelf = self;
    [strongSelf dismissAlert];
    if (strongSelf.exBlock) {
        strongSelf.exBlock();
    }
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    [topVC.view addSubview:self];
}

- (void) close {
    [self dismissAlert];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!backBroudView) {
        backBroudView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        backBroudView.backgroundColor = [UIColor blackColor];
        backBroudView.alpha = 0.5f;
        backBroudView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview: backBroudView];
    //    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.2);
    //    CGRect afterFrame = CGRectMake((popWidth - alertViewWidth) * 0.5, (popHeight - alertViewHeight) * 0.5, alertViewWidth, alertViewHeight);
    
    //    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    ////        self.transform = CGAffineTransformMakeRotation(0);
    ////        self.frame = afterFrame;
    //    } completion:^(BOOL finished) {
    //    }];
    [super willMoveToSuperview: newSuperview];
}

- (void)removeFromSuperview
{
    [backBroudView removeFromSuperview];
    backBroudView = nil;
    //    CGRect afterFrame = CGRectMake((popWidth - alertViewWidth) * 0.5, popHeight + alertViewHeight, alertViewWidth, alertViewHeight);
    //    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    //        self.frame = afterFrame;
    //        self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
    //    } completion:^(BOOL finished) {
    //        [super removeFromSuperview];
    //    }];
    [super removeFromSuperview];
}

@end
