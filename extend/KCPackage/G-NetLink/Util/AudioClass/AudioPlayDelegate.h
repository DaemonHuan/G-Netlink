//
//  AudioPlayDelegate.h
//  ZhiJiaX
//
//  Created by 95190 on 13-5-6.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AudioPlayDelegate <NSObject>
-(void)didAudioPlayStop;
-(void)didAudioPlayFinish;
@end
