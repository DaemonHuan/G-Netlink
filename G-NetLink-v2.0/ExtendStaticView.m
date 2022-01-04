//
//  ExtendStaticView.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/25/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "ExtendStaticView.h"
#import "public.h"

#define IS_DEMOVIEW_HEIGHT 30.0f
#define IS_DEMOVIEW_TEXT @"模拟运行"

@implementation ExtendStaticView


+ (UIView *) MarkDemoView {
    UIView * thisView = [[UIView alloc]init];
    thisView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_bg"]];
    CGFloat ax = [UIScreen mainScreen].bounds.size.height - IS_DEMOVIEW_HEIGHT;
    CGFloat wx = [UIScreen mainScreen].bounds.size.width;
    
    thisView.frame = CGRectMake(0, ax, wx, IS_DEMOVIEW_HEIGHT);
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, wx, 2.0f)];
    [image setImage: [UIImage imageNamed:@"public_seperateline01"]];
    [thisView addSubview: image];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(wx/2.0f - 45.0f, 5.0f, 70.0f, 20.0f)];
    [title setText: IS_DEMOVIEW_TEXT];
    [title setTextColor: [UIColor whiteColor]];
    title.textAlignment = NSTextAlignmentCenter;
    [title setFont: [UIFont fontWithName:FONT_XI size:17.0f]];
    [thisView addSubview: title];
    
    //    UIImageView * imageup = [[UIImageView alloc] initWithFrame:CGRectMake(wx/2.0f + 35.0f, 10.0f, 15.0f, 10.0f)];
    //    [imageup setImage: [UIImage imageNamed:@"home_up"]];
    //    [thisView addSubview: imageup];
    
    return thisView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
