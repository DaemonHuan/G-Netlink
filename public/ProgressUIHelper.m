//
//  ProgressUIHelper.m
//  G-Netlink-beta0.2
//
//  Created by Walker Liu on 11/4/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "ProgressUIHelper.h"

@implementation ProgressUIHelper


+ (void)showToast:(NSString*)text view:(UIView*)v seconds:(NSInteger)sec {
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:v];
    [v addSubview:HUD];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    //    HUD.yOffset = 100.0f;
    //    HUD.xOffset = 100.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep((unsigned int)sec);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

@end
