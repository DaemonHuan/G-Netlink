//
//  AudioPlay.m
//  Double
//
//  Created by KUN DONG on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AudioPlay.h"
#import "AQPlayer.h"


@interface AudioPlay()
{
    AQPlayer*	player;
}
@end

@implementation AudioPlay
@synthesize playFilePath = _playFilePath;

-(id)init
{
    self = [super init];
	player = new AQPlayer();
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish:) name:NotificationName_AQPlayer_Play_Finish object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStop:) name:NotificationName_AQPlayer_Play_Stop object:nil];
    
    return self;
}
-(void)playStop:(NSNotification *)noti
{
    if(self.observer!=nil)
        [self.observer didAudioPlayStop];
}
-(void)playFinish:(NSNotification *)noti
{
    if(self.observer!=nil)
        [self.observer didAudioPlayFinish];
}
-(void)startPlay:(NSString*)playFilePath
{
    _playFilePath = [playFilePath copy];
    player->DisposeQueue(true);
    player->CreateQueueForFile((__bridge CFStringRef)_playFilePath);
    player->StartQueue(false);
}
-(void)stopPlayQueue
{
    player->StopQueue();
}
-(void)pausePlayQueue
{
    player->PauseQueue();
}
-(BOOL)isRunning
{
    return player->IsRunning();
}
-(int)getTotalDuration
{
    return player->TotalTimer;
}
-(int)getCurSeconds
{
    return player->curSeconds;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationName_AQPlayer_Play_Finish object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationName_AQPlayer_Play_Stop object:nil];
    delete player;
}
@end
