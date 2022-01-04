//
//  PointerOfTurntableLayers.m
//  TurntableTest
//
//  Created by 95190 on 14-2-17.
//  Copyright (c) 2014年 sunhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointerOfTurntableLayer.h"
#import "ResDefine.h"

@implementation PointerOfTurntableLayer

-(id)init
{
    self = [super init];
    self.backgroundColor = [[UIColor clearColor] CGColor];
    
    UIImage *backgroundImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnose_turntable_pointer",Res_Image,@"")];
    self.contents = (id)backgroundImage.CGImage;
    
    CGRect frame = self.frame;
    frame.size.width = backgroundImage.size.width;
    frame.size.height = backgroundImage.size.height;
    self.frame = frame;
    return self;
}
@end
