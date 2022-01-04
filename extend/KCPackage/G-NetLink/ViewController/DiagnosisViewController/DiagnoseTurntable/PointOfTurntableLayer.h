//
//  PointOfTurntableLayer.h
//  TurntableTest
//
//  Created by 95190 on 14-2-17.
//  Copyright (c) 2014年 sunhao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PointOfTurntableLayer : CALayer
{
@protected
    UIImage *_backgroundImage;
}
@property(nonatomic,strong)UIImage *backgroundImage;
@end
