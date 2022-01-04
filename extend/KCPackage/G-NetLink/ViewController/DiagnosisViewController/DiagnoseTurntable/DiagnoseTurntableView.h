//
//  DiagnoseTurntableView.h
//  TurntableTest
//
//  Created by 95190 on 14-2-14.
//  Copyright (c) 2014年 sunhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiagnoseTurntableViewDelegate.h"
@interface DiagnoseTurntableView : UIView
{
    
}
@property(nonatomic)BOOL isDoneShow;
@property(nonatomic,assign)id<DiagnoseTurntableViewDelegate> delegate;
-(id)initWithPoint:(CGPoint)point;
-(void)startAnimation;
-(void)stopAnimation;

@end
