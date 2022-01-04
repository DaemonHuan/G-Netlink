//
//  jkProcessView.m
//  G-NetLink-v1.0
//
//  Created by jk on 2/25/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "jkProcessView.h"
#import "SCGIFImageView.h"
#import "public.h"

@implementation jkProcessView {
    UILabel * la_title;
    UIImageView * imv_process;
}

- (id)initWithMessage:(NSString *)title {
    if (self = [super init]) {
        CGFloat wx = [UIScreen mainScreen].bounds.size.width;
        CGFloat hy = [UIScreen mainScreen].bounds.size.height;
        
        CGFloat tw = wx * 0.7f;
        CGFloat th = (hy - 64.0f) * 0.3f;
        self.backgroundColor = [UIColor colorWithHexString:@"4F5660"];
        self.layer.cornerRadius = 5.0f;
        [self setFrame:CGRectMake((wx - tw) * 0.5f, (hy - th) * 0.5f, tw, th)];
        
        la_title = [[UILabel alloc]initWithFrame:CGRectMake(8.0f, 8.0f, tw - 16.0f, th * 0.7f)];
        [self addSubview:la_title];
        [la_title setTextColor: [UIColor whiteColor]];
        [la_title setText:title];
        [la_title setFont:[UIFont fontWithName:FONT_MM size:17.0f]];
        [la_title setTextAlignment:NSTextAlignmentCenter];
        [la_title setLineBreakMode:NSLineBreakByWordWrapping];
        la_title.numberOfLines = 0;
        
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"runline.gif" ofType:nil];
        SCGIFImageView* gifImageView = [[SCGIFImageView alloc] initWithGIFFile:filePath];
        gifImageView.frame = CGRectMake(40.0f, th - 50.0f, tw - 80.0f, 30.0f);
        [self addSubview: gifImageView];
    }
    return self;
}

- (void) toshow {
    [self setHidden:NO];
}

- (void) tohide {
    [self setHidden:YES];
}

- (void) setTitile:(NSString *)titile {
    [la_title setText:titile];
}

@end


