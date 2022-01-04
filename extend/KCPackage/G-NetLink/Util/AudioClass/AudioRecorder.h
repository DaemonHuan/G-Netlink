//
//  AudioRecorder.h
//  Double
//
//  Created by KUN DONG on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioRecorder : NSObject
{
    NSString *_saveRecorderFilePath;
}
@property(nonatomic,readonly)NSString *saveRecorderFilePath;

-(void)startRecord:(NSString*)saveRecorderFilePath;
-(void)stopRecord;
-(BOOL)isRunning;
-(int)getCurSeconds;
@end
