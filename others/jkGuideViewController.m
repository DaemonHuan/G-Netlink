//
//  jkGuideViewController.m
//  jk-Test-For-Demo
//
//  Created by jk on 1/19/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "jkGuideViewController.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface jkGuideViewController ()

@end

@implementation jkGuideViewController

@synthesize animating = _animating;

@synthesize pageScroll = _pageScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -

- (CGRect)onscreenFrame
{
    return [UIScreen mainScreen].bounds;
}

- (CGRect)offscreenFrame
{
    CGRect frame = [self onscreenFrame];
    switch ([UIApplication sharedApplication].statusBarOrientation)
    {
        case UIInterfaceOrientationPortrait:
            frame.origin.y = frame.size.height;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            frame.origin.y = -frame.size.height;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            frame.origin.x = frame.size.width;
            break;
        case UIInterfaceOrientationLandscapeRight:
            frame.origin.x = -frame.size.width;
            break;
    }
    return frame;
}

- (void)showGuide
{
    if (!_animating && self.view.superview == nil)
    {
        [jkGuideViewController sharedGuide].view.frame = [self offscreenFrame];
        [[self mainWindow] addSubview:[jkGuideViewController sharedGuide].view];
        
        _animating = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(guideShown)];
        [jkGuideViewController sharedGuide].view.frame = [self onscreenFrame];
        [UIView commitAnimations];
    }
}

- (void)guideShown
{
    _animating = NO;
}

- (void)hideGuide
{
    if (!_animating && self.view.superview != nil)
    {
        _animating = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(guideHidden)];
        [jkGuideViewController sharedGuide].view.frame = [self offscreenFrame];
        [UIView commitAnimations];
    }
}

- (void)guideHidden
{
    _animating = NO;
    [[[jkGuideViewController sharedGuide] view] removeFromSuperview];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

+ (void)show
{
    [[jkGuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
    [[jkGuideViewController sharedGuide] showGuide];
}

+ (void)hide
{
    [[jkGuideViewController sharedGuide] hideGuide];
}

#pragma mark -

+ (jkGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static jkGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

- (void)pressCheckButton:(UIButton *)checkButton
{
    [checkButton setSelected:!checkButton.selected];
}

- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *imageNameArray = [NSArray arrayWithObjects:@"guide01", @"guide02", @"guide03", @"guide04", nil];
    CGFloat wx = [UIScreen mainScreen].bounds.size.width;
    CGFloat ax = [UIScreen mainScreen].bounds.size.height;
    [m_pageScroll setPagingEnabled:YES];
    [m_pageScroll setContentSize:CGSizeMake(wx * imageNameArray.count, ax)];

//    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, wx, ax)];
//    self.pageScroll.pagingEnabled = YES;
//    self.pageScroll.contentSize = CGSizeMake();
//    [self.view addSubview:self.pageScroll];
    
    NSString *imgName = nil;
    UIView *view;
    for (int i = 0; i < imageNameArray.count; i++) {
        imgName = [imageNameArray objectAtIndex:i];
        view = [[UIView alloc] initWithFrame:CGRectMake((wx * i), 0.0f, wx, ax)];

        UIImageView * imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[imageNameArray objectAtIndex:i]]];
        [imageview setFrame:CGRectMake(0.0f, 0.0f, wx, ax)];
        [view addSubview:imageview];
        [m_pageScroll addSubview:view];
        
        if (i == imageNameArray.count - 1) {
            UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, wx, ax)];
            [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:enterButton];
        }
    }
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
