//
//  CustomMapCalloutView.h
//  G-NetLink
//
//  Created by a95190 on 14-10-12.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBMapView.h>
#define EdgeInsetsWidth 20

@interface CustomMapCalloutView : UIView

@property(nonatomic,assign) MBPoint point;
@property (nonatomic,assign) CGFloat calloutHeight;
@property(nonatomic,strong) NSString *address;

-(id)initWithBackgroundImage:(UIImage*)backgroundImage;

@end
