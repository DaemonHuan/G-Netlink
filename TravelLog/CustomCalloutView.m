//
//  CustomCalloutView.m
//  Category_demo2D
//
//  Created by xiaoming han on 13-5-22.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomCalloutView.h"
#import <QuartzCore/QuartzCore.h>
#import "public.h"

#define kArrorHeight        10
#define kPortraitMargin     8.0
#define kSpaceToSide        12.0f
#define kPortraitWidth      70
#define kPortraitHeight     50

#define kTitleWidth         150
#define kTitleHeight        20

@implementation CustomCalloutView {
    UILabel *subtitleLabel;
    UILabel *titleLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView * bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"travellog_anno"]];
        bg.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
        [bg setAlpha: 0.4f];
        [self addSubview: bg];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0f, kPortraitMargin+ kSpaceToSide, kTitleWidth, kTitleHeight)];
        titleLabel.font = [UIFont fontWithName:FONT_MM size: 14.0f];
        titleLabel.textColor = [UIColor whiteColor];
//        titleLabel.text = @"途径点";
        [self addSubview: titleLabel];

        subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0f, kPortraitMargin * 2.f + kTitleHeight + kSpaceToSide, kTitleWidth, kTitleHeight * 2.0f)];
        subtitleLabel.font = [UIFont fontWithName:FONT_XI size: 12.0f];
        subtitleLabel.textColor = [UIColor whiteColor];
        [subtitleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [subtitleLabel setNumberOfLines:0];
        [self addSubview: subtitleLabel];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    [titleLabel setText: title];
}

- (void) setSubTitle:(NSString *)subtitle {
    [subtitleLabel setText: subtitle];
}

#pragma mark - draw rect

- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    // 设置窗体背景透明
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.0].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

@end
