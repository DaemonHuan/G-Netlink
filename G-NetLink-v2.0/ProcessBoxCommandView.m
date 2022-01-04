//
//  ProcessBoxCommandView.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/27/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "ProcessBoxCommandView.h"
#import "SCGIFImageView.h"
#import "UIColor+Hex.h"

@implementation ProcessBoxCommandView {
    UILabel * la_title;
    UIImageView * imv_process;
}

- (id)initWithMessage:(NSString *)title {
    if (self = [super init]) {
        CGFloat wx = [UIScreen mainScreen].bounds.size.width;
        CGFloat hy = [UIScreen mainScreen].bounds.size.height;
        
        CGFloat tw = wx;
        CGFloat th = 65.0f;
        self.backgroundColor = [UIColor colorWithHexString:@"11A8ED"];
//        self.layer.cornerRadius = 5.0f;
        [self setFrame:CGRectMake((wx - tw) * 0.5f, (hy - th) * 0.5f, tw, th)];
        
//        UIView * bg = [[UIView alloc]init];
//        bg.backgroundColor = [UIColor clearColor];
//        [bg setFrame:CGRectMake(0.0f, 64.0f, wx, hy - 64.0f)];
//        [self addSubview:bg];
        
//        UIImageView * bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_alertview"]];
//        [bg setFrame:CGRectMake(0.0f, 0.0f, tw, th)];
//        [self addSubview: bg];
        
        la_title = [[UILabel alloc]initWithFrame:CGRectMake(32.0f, 8.0f, tw - 64.0f, 30.0f)];
        [self addSubview:la_title];
        [la_title setTextColor: [UIColor whiteColor]];
        [la_title setText:title];
        [la_title setFont:[UIFont fontWithName:@"FZLanTingHei-M-GBK" size:18.0f]];
        [la_title setTextAlignment:NSTextAlignmentLeft];
//        [la_title setLineBreakMode:NSLineBreakByWordWrapping];
//        la_title.numberOfLines = 0;
        
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"commandrun.gif" ofType:nil];
        SCGIFImageView* gifImageView = [[SCGIFImageView alloc] initWithGIFFile:filePath];
        gifImageView.frame = CGRectMake(32.0f, 40.0f, tw - 64.0f, 7.0f);
        [self addSubview: gifImageView];
    }
    return self;
}

- (void) showView {
    [self setHidden:NO];
}

- (void) hideView {
    [self setHidden:YES];
}

- (void) setTitile:(NSString *)titile {
    [la_title setText:titile];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
