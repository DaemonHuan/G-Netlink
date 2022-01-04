//
//  AudioPlay.h
//  Double
//
//  Created by KUN DONG on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioPlayDelegate.h"

@interface AudioPlay : NSObject
{
    NSString *_playFilePath;
}
@property(nonatomic,readonly)NSString *playFilePath;
@property(nonatomic,assign)id<AudioPlayDelegate> observer;
-(void)startPlay:(NSString*)playFilePath;
-(void)stopPlayQueue;
-(void)pausePlayQueue;
-(BOOL)isRunning;
-(int)getTotalDuration;
-(int)getCurSeconds;
@end
