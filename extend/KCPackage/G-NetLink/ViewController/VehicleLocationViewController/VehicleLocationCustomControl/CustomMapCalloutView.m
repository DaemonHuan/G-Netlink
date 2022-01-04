//
//  CustomMapCalloutView.m
//  G-NetLink
//
//  Created by a95190 on 14-10-12.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "CustomMapCalloutView.h"
#import "ResDefine.h"

@interface CustomMapCalloutView()
{
    UIButton *vehicleCalloutBtn;
}

@end

@implementation CustomMapCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithBackgroundImage:(UIImage *)backgroundImage
{
    if(backgroundImage==nil)
        return nil;
    
    UIImage *image = [UIImage imageNamed:NSLocalizedStringFromTable(@"navigation_map_annotation",Res_Image,@"")];
    CGRect frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height+image.size.height);
    self = [super initWithFrame:frame];
    
    vehicleCalloutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vehicleCalloutBtn.userInteractionEnabled = NO;
    [vehicleCalloutBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    vehicleCalloutBtn.contentMode = UIViewContentModeScaleToFill;
    
    [vehicleCalloutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    vehicleCalloutBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    vehicleCalloutBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    vehicleCalloutBtn.titleLabel.numberOfLines = 0;
    
    [self addSubview:vehicleCalloutBtn];
    
    return self;
}

-(void)setAddress:(NSString *)address
{
     CGSize textSize = [address sizeWithFont:[UIFont boldSystemFontOfSize:18]
    constrainedToSize:CGSizeMake(vehicleCalloutBtn.currentBackgroundImage.size.width, MAXFLOAT)
    lineBreakMode:NSLineBreakByWordWrapping];
    [vehicleCalloutBtn setTitle:address forState:UIControlStateNormal];
    vehicleCalloutBtn.contentEdgeInsets = UIEdgeInsetsMake(EdgeInsetsWidth - 6, EdgeInsetsWidth, EdgeInsetsWidth, EdgeInsetsWidth);
    vehicleCalloutBtn.frame = CGRectMake(0, 0, vehicleCalloutBtn.currentBackgroundImage.size.width, textSize.height + EdgeInsetsWidth * 2);
    
    _calloutHeight = textSize.height + EdgeInsetsWidth * 2;
    
    // 生成可以拉伸指定位置的图片
    UIImage *newImage = [vehicleCalloutBtn.currentBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

    [vehicleCalloutBtn setBackgroundImage:newImage forState:UIControlStateNormal];
}

@end
