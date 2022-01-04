//
//  RootViewController.m
//  TOYOTA_ZhijiaX
//
//  Created by jayden on 14-8-1.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "RootViewController.h"
#import "RootView.h"

@interface RootViewController ()
{
    
}
@end

@implementation RootViewController
{
    RootView *tabBarView;
}

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if(!self)
        return nil;
    
    
    return self;
}

- (id)initWithControllerIDs:(NSArray*)ids
{
    if (self=[self init]) {
        _viewControllerIDs=ids;
    }
    
    return self;
}

-(void)receiveMessage:(Message *)message
{
    RootView *rootView = (RootView*)self.view;
    if(message.commandID == MC_TABBAR_0)
        rootView.tabBar.currentItemFocus = 0;
    else if(message.commandID == MC_TABBAR_1)
        rootView.tabBar.currentItemFocus = 1;
    else if(message.commandID == MC_TABBAR_2)
        rootView.tabBar.currentItemFocus = 2;
    else if(message.commandID == MC_TABBAR_3)
        rootView.tabBar.currentItemFocus = 3;
}

- (void)loadView
{
    double height = [UIScreen mainScreen].applicationFrame.size.height;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        height = [UIScreen mainScreen].bounds.size.height;
    
    if([UIApplication sharedApplication].statusBarFrame.size.height>20)
        height-=20;
    
    tabBarView = [[RootView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
    
    tabBarView.tabBar.delegate = self;
    
    self.view = tabBarView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - CustomTabBarDelegate代理方法
- (void)tabBar:(CustomTabBar *)tabBar didSelectTabAtIndex:(NSInteger)index
{
    if(tabBar.currentItemFocus == index)
        return;
    tabBar.currentItemFocus = index;
    int viewControllerID = [[_viewControllerIDs objectAtIndex:index] intValue];
    
    Message *message = [[Message alloc] init];
    message.receiveObjectID = viewControllerID;
    message.commandID = MC_CREATE_NORML_VIEWCONTROLLER;
    [self sendMessage:message];
}
@end
