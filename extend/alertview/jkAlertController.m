//
//  jkAlertController.m
//
//  Created by jk on 11/23/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "jkAlertController.h"

#import "public.h"
#import "SCGIFImageView.h"

#define sizeTitleHeight 40.0f
#define sizeMsgHeight 80.0f
#define sizeAlertToSide 30.0f
#define sizeTwoButtonSide 30.0f
#define sizeSingleButtonSide 40.0f


@interface jkAlertController () {
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

@end

@implementation jkAlertController

@synthesize centerView;
@synthesize okBlock,exBlock;

- (id) initWithTitle:(NSString *) title CenterLabel:(NSString *)msg Enter:(NSString *)btOK Cancle:(NSString *)btEX {
    if (self = [super init]) {
        // config top
        popWidth = [UIScreen mainScreen].bounds.size.width;
        popHeight = [UIScreen mainScreen].bounds.size.height;
        alertViewWidth = popWidth - sizeAlertToSide * 2;
        
        UIImageView * bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vctl_alertview1"]];
        [bg setFrame:CGRectMake(0.0f, 0.0f, alertViewWidth, sizeMsgHeight + 60.0f + 8.0f * 3.0f)];
        [self addSubview: bg];

        // config Title
        self.layer.cornerRadius = 5.0f;
        [self setBackgroundColor: [UIColor colorWithHexString: BackGroudColor]];
        lb_Title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, sizeTitleHeight)];
        lb_Title.font = [UIFont boldSystemFontOfSize:27.0f];
        lb_Title.textColor = [UIColor whiteColor];
        [lb_Title setTextAlignment:NSTextAlignmentCenter];
        [lb_Title setText:title];
//        [self addSubview: lb_Title];

        // config Message
        [self setCenterMessage:msg];
        // config buttons
       if (btOK != nil && btEX == nil) {
           CGRect btnFrame01 = CGRectMake(sizeSingleButtonSide, CGRectGetHeight(lb_Message.bounds) + 30.0f, alertViewWidth - sizeSingleButtonSide * 2, 40.0f);
           bt_OK = [[UIButton alloc]initWithFrame:btnFrame01];
           [bt_OK.layer setCornerRadius:3.0f];
           [bt_OK.layer setBorderWidth:0.2f];
           CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
           CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
           [bt_OK.layer setBorderColor:colorref];
           [bt_OK setTitle:btOK forState:UIControlStateNormal];
           [bt_OK setTitleColor:[UIColor colorWithHexString: WordColor] forState:UIControlStateNormal];
           
           [bt_OK addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
           [self addSubview:bt_OK];
        }
        else if (btOK != nil && btEX != nil) {
            CGFloat ww = (alertViewWidth - sizeTwoButtonSide * 2 - 20.0f) * 0.5;
            CGRect btnFrame01 = CGRectMake(sizeTwoButtonSide, CGRectGetHeight(lb_Message.bounds) + 35.0f, ww, 40.0f);
            CGRect btnFrame02 = CGRectMake(sizeTwoButtonSide + ww + 20.0f,CGRectGetHeight(lb_Message.bounds) + 35.0f, ww, 40.0f);
            bt_OK = [[UIButton alloc]initWithFrame:btnFrame02];
//            [bt_OK.layer setCornerRadius:3.0f];
//            [bt_OK.layer setBorderWidth:0.2f];
//            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
//            [bt_OK.layer setBorderColor:colorref];
            [bt_OK setTitle:btOK forState:UIControlStateNormal];
            [bt_OK setTitleColor:[UIColor colorWithHexString: WordColor] forState:UIControlStateNormal];
            [bt_OK addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:bt_OK];
            bt_NO = [[UIButton alloc]initWithFrame:btnFrame01];
//            [bt_NO.layer setCornerRadius:3.0f];
//            [bt_NO.layer setBorderWidth:0.2f];
//            [bt_NO.layer setBorderColor:colorref];
            [bt_NO setTitle:btEX forState:UIControlStateNormal];
            [bt_NO setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bt_NO addTarget:self action:@selector(exBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:bt_NO];
        }
        alertViewHeight = sizeMsgHeight + 60.0f + 8.0f * 3.0;
    }
    return self;
}


- (id) initWitView:(NSString *)title CenterView:(UIView *)view Enter:(NSString *)btOK Cancle:(NSString *)btEX {
    if (self = [super init]) {
        // config top
        popWidth = [UIScreen mainScreen].bounds.size.width;
        popHeight = [UIScreen mainScreen].bounds.size.height;
        
        CGFloat centerViewWidth = CGRectGetWidth(view.bounds);
        CGFloat centerViewHeight = CGRectGetHeight(view.bounds);
        alertViewWidth = centerViewWidth + 16.0f;

        // config Title
        self.layer.cornerRadius = 5.0f;
        [self setBackgroundColor: [UIColor colorWithHexString: BackGroudColor]];
        lb_Title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, sizeTitleHeight)];
        lb_Title.font = [UIFont boldSystemFontOfSize:27.0f];
        lb_Title.textColor = [UIColor colorWithHexString: WordColor];
        [lb_Title setTextAlignment:NSTextAlignmentCenter];
        [lb_Title setText:title];
        [self addSubview: lb_Title];
        
        // config Views
        CGRect centerFrame = CGRectMake(8.0f, sizeTitleHeight + 8.0f, centerViewWidth, centerViewHeight);
        view.frame = centerFrame;
        [self addSubview: view];
        
        // config buttons
        if (btOK != nil && btEX == nil) {
            CGRect btnFrame01 = CGRectMake(sizeSingleButtonSide, sizeTitleHeight + CGRectGetHeight(view.bounds) + 16.0f, CGRectGetWidth(lb_Title.bounds) - sizeSingleButtonSide * 2, 40.0f);
            bt_OK = [[UIButton alloc]initWithFrame:btnFrame01];
            [bt_OK.layer setCornerRadius:3.0f];
            [bt_OK.layer setBorderWidth:0.2f];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
            [bt_OK.layer setBorderColor:colorref];
            [bt_OK setTitle:btOK forState:UIControlStateNormal];
            [bt_OK setTitleColor:[UIColor colorWithHexString: WordColor] forState:UIControlStateNormal];
            
            [bt_OK addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:bt_OK];
        }
        else if (btOK != nil && btEX != nil) {
            CGFloat ww = (alertViewWidth - sizeTwoButtonSide * 2 - 20.0f) * 0.5;
            CGRect btnFrame01 = CGRectMake(sizeTwoButtonSide, sizeTitleHeight + centerViewHeight + 16.0f, ww, 40.0f);
            CGRect btnFrame02 = CGRectMake(sizeTwoButtonSide + ww + 20.0f, sizeTitleHeight + centerViewHeight + 16.0f, ww, 40.0f);
            bt_OK = [[UIButton alloc]initWithFrame:btnFrame01];
            [bt_OK.layer setCornerRadius:3.0f];
            [bt_OK.layer setBorderWidth:0.2f];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
            [bt_OK.layer setBorderColor:colorref];
            [bt_OK setTitle:btOK forState:UIControlStateNormal];
            [bt_OK setTitleColor:[UIColor colorWithHexString: WordColor] forState:UIControlStateNormal];
            [bt_OK addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:bt_OK];
            bt_NO = [[UIButton alloc]initWithFrame:btnFrame02];
            [bt_NO.layer setCornerRadius:3.0f];
            [bt_NO.layer setBorderWidth:0.2f];
            [bt_NO.layer setBorderColor:colorref];
            [bt_NO setTitle:btEX forState:UIControlStateNormal];
            [bt_NO setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bt_NO addTarget:self action:@selector(exBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:bt_NO];
        }
        alertViewHeight = sizeTitleHeight + centerViewHeight + 40.0f + 8.0f * 3.0;
    }
    return self;
}

- (id) initWithOKButton:(NSString *)msg {
    if (self = [super init]) {
        // config top
        popWidth = [UIScreen mainScreen].bounds.size.width;
        popHeight = [UIScreen mainScreen].bounds.size.height;
        alertViewWidth = popWidth - sizeAlertToSide * 2;
        UIImageView * bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vctl_alertview2"]];
        [bg setFrame:CGRectMake(0.0f, 0.0f, alertViewWidth, sizeMsgHeight + 60.0f + 8.0f * 3.0f)];
        [self addSubview: bg];
        
        // config Message
        [self setCenterMessage:msg];
        
        // config OK Button
        CGRect btnFrame = CGRectMake(sizeSingleButtonSide, CGRectGetHeight(lb_Message.bounds) + 35.0f, alertViewWidth - sizeSingleButtonSide * 2, 40.0f);
        bt_OK = [[UIButton alloc]initWithFrame:btnFrame];
        //        [bt_OK.layer setCornerRadius:3.0f];
        //        [bt_OK.layer setBorderWidth:0.0f];
        //        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        //        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
        //        [bt_OK.layer setBorderColor:colorref];
        [bt_OK setTitle:@"确 定" forState:UIControlStateNormal];
        [bt_OK setTitleColor:[UIColor colorWithHexString: WordColor] forState:UIControlStateNormal];
        
        [bt_OK addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt_OK];
        
        alertViewHeight = sizeMsgHeight + 60.0f + 8.0f * 3.0;
    }
    return self;
}

- (id) initWithNOButton:(NSString *)msg {
    if (self = [super init]) {
        // config top
        popWidth = [UIScreen mainScreen].bounds.size.width;
        popHeight = [UIScreen mainScreen].bounds.size.height;
        alertViewWidth = popWidth - sizeAlertToSide * 2;
        self.layer.cornerRadius = 5.0f;
        [self setBackgroundColor: [UIColor colorWithHexString: BackGroudColor]];

        // config center message
        lb_Message = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 8.0f, alertViewWidth - 16.0f, sizeMsgHeight)];
        lb_Message.font = [UIFont systemFontOfSize:20.0f];
        lb_Message.textColor = [UIColor colorWithHexString: WordColor];
        [lb_Message setTextAlignment:NSTextAlignmentCenter];
        [lb_Message setText:msg];
        [lb_Message setLineBreakMode:NSLineBreakByWordWrapping];
        lb_Message.numberOfLines = 0;
        [self addSubview: lb_Message];
        
        alertViewHeight = CGRectGetHeight(lb_Message.bounds) + 16.0f;
        
        UITapGestureRecognizer * singleTouchUp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)];
        [self addGestureRecognizer:singleTouchUp];
    }
    return self;
}

- (id) initWithLoadingGif: (NSString *) msg {
    if (self = [super init]) {
        // config top
        popWidth = [UIScreen mainScreen].bounds.size.width;
        popHeight = [UIScreen mainScreen].bounds.size.height;
        alertViewWidth = popWidth - sizeAlertToSide * 2;
        self.layer.cornerRadius = 5.0f;
        self.backgroundColor = [UIColor colorWithHexString: BackGroudColor];
        
        // config center message
        lb_Message = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 20.0f, alertViewWidth - 16.0f, 50.0f)];
        lb_Message.font = [UIFont systemFontOfSize:20.0f];
        lb_Message.textColor = [UIColor whiteColor];
        [lb_Message setTextAlignment:NSTextAlignmentCenter];
        [lb_Message setText:msg];
        [lb_Message setLineBreakMode:NSLineBreakByWordWrapping];
        lb_Message.numberOfLines = 0;
        [self addSubview: lb_Message];
        
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"runline.gif" ofType:nil];
        SCGIFImageView* gifImageView = [[SCGIFImageView alloc] initWithGIFFile:filePath];
        gifImageView.frame = CGRectMake(45.0f, 90.0f, alertViewWidth - 90.0f, 30.0f);
        //    gifImageView.center = self.view.center;
        
        [self addSubview: gifImageView];
        
        alertViewHeight = sizeMsgHeight + 30.0f + 20.0f;
        
//        UITapGestureRecognizer * singleTouchUp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)];
//        [self addGestureRecognizer:singleTouchUp];
    }
    return self;
}

- (void) setCenterMessage:(NSString *)centerMsg {
    lb_Message = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 16.0f, alertViewWidth - 16.0f, sizeMsgHeight)];
    lb_Message.font = [UIFont systemFontOfSize:17.0f];
    lb_Message.textColor = [UIColor whiteColor];
    [lb_Message setTextAlignment:NSTextAlignmentCenter];
    [lb_Message setText:centerMsg];
    [lb_Message setLineBreakMode:NSLineBreakByWordWrapping];
    lb_Message.numberOfLines = 0;
    [self addSubview: lb_Message];
}

- (void)dealloc {
}
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
    self.frame = CGRectMake((popWidth - alertViewWidth) * 0.5, (popHeight - alertViewHeight) * 0.5, alertViewWidth, alertViewHeight);
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
