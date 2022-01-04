//
//  CustomTabBar.m
//  TOYOTA_ZhijiaX
//
//  Created by jayden on 14-8-1.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "CustomTabBar.h"

@interface CustomTabBar()
{
    double tabItemWidth;
}
-(void)itemOnClick:(id)sender;
@end

@implementation CustomTabBar
@synthesize tabItems = _tabItems;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _tabItems = [[NSMutableArray alloc] init];
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _backgroundImageView.userInteractionEnabled = YES;
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_backgroundImageView];
        
        _currentItemFocus = 0;
    }
    return self;
}
-(void)addItem:(CustomTabBarItem*)item
{
    [_tabItems addObject:item];
}
-(void)reload
{
    double x = 0;
    
    if(_tabItems.count>0)
    {
        tabItemWidth = self.bounds.size.width/_tabItems.count;
        _focusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tabItemWidth, self.bounds.size.height)];
    }
    
    for(int n=0;n<_tabItems.count;n++)
    {
        CustomTabBarItem *item = [_tabItems objectAtIndex:n];
        item.tag = n;
        [item addTarget:self action:@selector(itemOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect itemFrame = item.frame;
        itemFrame.origin.x = x+tabItemWidth/2-item.bounds.size.width/2;
        itemFrame.origin.y = self.bounds.size.height/2-item.bounds.size.height/2;
        item.frame = itemFrame;
        
        x+=tabItemWidth;
        [self addSubview:item];
    }
}
-(void)setCurrentItemFocus:(int)currentItemFocus
{
    if(_tabItems.count<=currentItemFocus)
        return;
    CustomTabBarItem *item = [_tabItems objectAtIndex:_currentItemFocus];
    item.selected = NO;
    _currentItemFocus = currentItemFocus;
    item = [_tabItems objectAtIndex:_currentItemFocus];
    item.selected = YES;
    
    CGRect focusImageViewFrame = _focusImageView.frame;
    focusImageViewFrame.origin.x = currentItemFocus*tabItemWidth;
    _focusImageView.frame = focusImageViewFrame;
    
    if(![_focusImageView isDescendantOfView:self])
        [self insertSubview:_focusImageView belowSubview:item];
}
-(void)itemOnClick:(id)sender
{
    if(self.delegate!=nil)
    {
        [self.delegate tabBar:self didSelectTabAtIndex:((CustomTabBarItem*)sender).tag];
    }
}
@end
