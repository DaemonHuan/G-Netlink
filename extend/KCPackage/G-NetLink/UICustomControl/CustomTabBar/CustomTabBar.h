//
//  CustomTabBar.h
//  TOYOTA_ZhijiaX
//
//  Created by jayden on 14-8-1.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarItem.h"

@class CustomTabBar;

@protocol CustomTabBarDelegate <NSObject>
@required
- (void)tabBar:(CustomTabBar *)tabBar didSelectTabAtIndex:(NSInteger)index;
@end

@interface CustomTabBar : UIView
{
@protected
    NSMutableArray *_tabItems;
}
@property(nonatomic,readonly)NSArray *tabItems;
@property(nonatomic,assign) id<CustomTabBarDelegate> delegate;
@property(nonatomic,readonly)UIImageView *backgroundImageView;
@property(nonatomic,readonly)UIImageView *focusImageView;
@property(nonatomic)int currentItemFocus;

-(void)addItem:(CustomTabBarItem*)item;
-(void)reload;

@end
