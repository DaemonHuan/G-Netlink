//
//  RootView.m
//  TOYOTA_ZhijiaX
//
//  Created by jayden on 14-8-1.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "RootView.h"

@implementation RootView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];

    UIImage *image = [UIImage imageNamed:NSLocalizedStringFromTable(@"tab_bar_background",Res_Image,@"")];
    
    _tabBar = [[CustomTabBar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - image.size.height, self.bounds.size.width, image.size.height)];
    _tabBar.backgroundImageView.image = image;
    _tabBar.focusImageView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"tab_foucs",Res_Image,@"")];
    _tabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_tabBar];
    
    image = [UIImage imageNamed:NSLocalizedStringFromTable(@"tab_bar_home1",Res_Image,@"")];
    CustomTabBarItem *homeTabBarItem = [CustomTabBarItem buttonWithType:UIButtonTypeCustom];
    homeTabBarItem.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [homeTabBarItem setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:NSLocalizedStringFromTable(@"tab_bar_home2",Res_Image,@"")];
    [homeTabBarItem setBackgroundImage:image forState:UIControlStateSelected];
    [_tabBar addItem:homeTabBarItem];
    
    image = [UIImage imageNamed:NSLocalizedStringFromTable(@"tab_bar_vehiclecontrol1",Res_Image,@"")];
    CustomTabBarItem *navigationTabBarItem = [CustomTabBarItem buttonWithType:UIButtonTypeCustom];
    navigationTabBarItem.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [navigationTabBarItem setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:NSLocalizedStringFromTable(@"tab_bar_vehiclecontrol2",Res_Image,@"")];
    [navigationTabBarItem setBackgroundImage:image forState:UIControlStateSelected];
    [_tabBar addItem:navigationTabBarItem];
    
    image = [UIImage imageNamed:NSLocalizedStringFromTable(@"tab_bar_remotediagnosis1",Res_Image,@"")];
    CustomTabBarItem *serverTabBarItem = [CustomTabBarItem buttonWithType:UIButtonTypeCustom];
    serverTabBarItem.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [serverTabBarItem setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:NSLocalizedStringFromTable(@"tab_bar_remotediagnosis2",Res_Image,@"")];
    [serverTabBarItem setBackgroundImage:image forState:UIControlStateSelected];
    [_tabBar addItem:serverTabBarItem];
    
    image = [UIImage imageNamed:NSLocalizedStringFromTable(@"tab_bar_usermanagement1",Res_Image,@"")];
    CustomTabBarItem *meTabBarItem = [CustomTabBarItem buttonWithType:UIButtonTypeCustom];
    meTabBarItem.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [meTabBarItem setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:NSLocalizedStringFromTable(@"tab_bar_usermanagement2",Res_Image,@"")];
    [meTabBarItem setBackgroundImage:image forState:UIControlStateSelected];
    [_tabBar addItem:meTabBarItem];
    
    _tabBar.currentItemFocus = 0;
    [_tabBar reload];
    
    return self;
}

@end
