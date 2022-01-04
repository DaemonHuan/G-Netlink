//
//  AudioRecorder.m
//  Double
//
//  Created by KUN DONG on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AudioRecorder.h"
#import "AQRecorder.h"

AQRecorder *recorder;

@implementation AudioRecorder
@synthesize saveRecorderFilePath = _saveRecorderFilePath;


-(id)init
{
    self = [super init];
    recorder = new AQRecorder();
    OSStatus error = AudioSessionInitialize(NULL, NULL, NULL, NULL);
    if (error) printf("ERROR INITIALIZING AUDIO SESSION! %d\n", (int)error);
	else 
	{
        UInt32 category = kAudioSessionCategory_PlayAndRecord;	
		error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute,
                                sizeof(audioRouteOverride), &audioRouteOverride);
		if (error) printf("couldn't set audio category!");
        
        error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, NULL, NULL);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %d\n", (int)error);
		UInt32 inputAvailable = 0;
		UInt32 size = sizeof(inputAvailable);
        
        // we do not want to allow recording if input is not available
		error = AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, &size, &inputAvailable);
        
        // we also need to listen to see if input availability changes
        error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, NULL, NULL);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %d\n", (int)error);
        
        error = AudioSessionSetActive(true); 
		if (error) printf("AudioSessionSetActive (true) failed");
        
        

    }

    return self;
}
-(int)getCurSeconds
{
    return recorder->curSeconds;
}
-(void)startRecord:(NSString*)saveRecorderFilePath
{
    _saveRecorderFilePath = [saveRecorderFilePath copy];
    recorder->StartRecord(saveRecorderFilePath);
}
- (void)stopRecord
{
    recorder->StopRecord();
}
-(BOOL)isRunning
{
    return recorder->IsRunning();
}
-(void)dealloc
{
    delete recorder;
}
@end
