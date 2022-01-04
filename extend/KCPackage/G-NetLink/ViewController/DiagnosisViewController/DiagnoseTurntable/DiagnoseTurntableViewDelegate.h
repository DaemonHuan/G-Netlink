//
//  DiagnoseTurntableViewDelegate.h
//  ZhiJiaXNew
//
//  Created by 95190 on 14-2-20.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DiagnoseTurntableViewDelegate <NSObject>
-(void)diagnoseTurntableViewAnimationDidStop;
@optional
-(void)diagnoseTurntableViewAnimationToRight;
@end
