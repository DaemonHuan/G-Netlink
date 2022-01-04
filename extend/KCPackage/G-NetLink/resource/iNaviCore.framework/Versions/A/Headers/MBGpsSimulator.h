//
//  MBGpsSimulator.h
//  iNaviCore
//
//  Created by delon on 13-7-2.
//  Copyright (c) 2013年 Mapbar. All rights reserved.
//

#ifndef DISTRIBUTION

#import <Foundation/Foundation.h>

@interface MBGpsSimulator : NSObject

+ (MBGpsSimulator *)defaultGpsSimulator;

-(void)setRecordGPS:(BOOL)recordGPS;
-(void)setUseSimGPS:(BOOL)useSimGPS;
-(NSInteger)getCurMaxSimGPSIndex;
-(NSInteger)getCurSimGPSIndex;
-(void)setCurSimGPSIndex:(NSInteger)index;
-(float)getCurSimGPSSpeed;
-(void)setCurSimGPSSpeed:(float)speed;

@end

#endif
