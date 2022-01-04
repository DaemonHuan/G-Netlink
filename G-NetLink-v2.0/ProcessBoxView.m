//
//  ProcessBoxView.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/18/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "ProcessBoxView.h"
#import "SCGIFImageView.h"
#import "UIColor+Hex.h"

@implementation ProcessBoxView {
    UILabel * la_title;
    UIImageView * imv_process;
}

- (id)initWithMessage:(NSString *)title {
    if (self = [super init]) {
        CGFloat wx = [UIScreen mainScreen].bounds.size.width;
        CGFloat hy = [UIScreen mainScreen].bounds.size.height;

        CGFloat tw = wx * 0.8f;
        CGFloat th = (hy - 64.0f) * 0.3f;
        self.backgroundColor = [UIColor clearColor];
//        self.layer.cornerRadius = 5.0f;
        [self setFrame:CGRectMake(0.0f, 64.0f, wx, hy - 64.0f)];
        
        UIView * centerView = [[UIView alloc]init];
        centerView.backgroundColor = [UIColor clearColor];
        centerView.layer.cornerRadius = 5.0f;
        [centerView setFrame:CGRectMake((wx - tw) * 0.5f, (hy - th) * 0.5f - 64.0f, tw, th)];
        [self addSubview:centerView];
        
        UIImageView * bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_alertview"]];
        [bg setFrame:CGRectMake(0.0f, 0.0f, tw, th)];
        [centerView addSubview: bg];
        
        la_title = [[UILabel alloc]initWithFrame:CGRectMake(8.0f, 8.0f, tw - 16.0f, th * 0.7f)];
        [centerView addSubview:la_title];
        [la_title setTextColor: [UIColor whiteColor]];
        [la_title setText:title];
        [la_title setFont:[UIFont fontWithName:@"FZLanTingHei-M-GBK" size:18.0f]];
        [la_title setTextAlignment:NSTextAlignmentCenter];
        [la_title setLineBreakMode:NSLineBreakByWordWrapping];
        la_title.numberOfLines = 0;
        
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"runline.gif" ofType:nil];
        SCGIFImageView* gifImageView = [[SCGIFImageView alloc] initWithGIFFile:filePath];
        gifImageView.frame = CGRectMake(32.0f, th - 50.0f, tw - 64.0f, 30.0f);
        [centerView addSubview: gifImageView];
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

@end

