//
//  AppLoadingView.m
//  ZhiJiaAnX
//
//  Created by wei.xu.95190 on 13-8-15.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "AppLoadingView.h"
#import "ResDefine.h"

@implementation AppLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        frame.origin.y = 0;
        self.imageView = [[UIImageView alloc]initWithFrame:frame];
        [self addSubview:self.imageView];
        
        if([UIScreen mainScreen].applicationFrame.size.height > 480)
            self.imageView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"welcome_loading_iphone5", Res_Image, @"")];
        else
            self.imageView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"welcome_loading", Res_Image, @"")];
    }
    return self;
}


@end
