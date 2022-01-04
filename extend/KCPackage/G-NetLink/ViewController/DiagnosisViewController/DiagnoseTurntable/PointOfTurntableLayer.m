//
//  PointOfTurntableLayer.m
//  TurntableTest
//
//  Created by 95190 on 14-2-17.
//  Copyright (c) 2014年 sunhao. All rights reserved.
//

#import "PointOfTurntableLayer.h"

@implementation PointOfTurntableLayer
@synthesize backgroundImage = _backgroundImage;


-(id)init
{
    self = [super init];
    self.backgroundColor = [[UIColor clearColor] CGColor];
    return self;
}
-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.contents = (id)backgroundImage.CGImage;
    
    CGRect frame = self.frame;
    frame.size.width = backgroundImage.size.width;
    frame.size.height = backgroundImage.size.height;
    self.frame = frame;
}
@end
