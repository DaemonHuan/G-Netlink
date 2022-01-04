//
//  MBBadDrivingDetector.h
//  iNaviCore
//
//  Created by fanyl on 14-6-10.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBObject.h"

@protocol MBBadDrivingDetectorDelegate <NSObject>

@optional
-(void)quickAccerlationBegin;
-(void)quickAccerlationEnd;
-(void)hardBrakingBegin;
-(void)hardBrakingEnd;
-(void)idleBegin;
-(void)idleEnd;
@end

@class MBBadDrivingDetectorResult;
@interface MBBadDrivingDetector : NSObject
@property(nonatomic,assign) id<MBBadDrivingDetectorDelegate> delegate;
-(MBBadDrivingDetectorResult*)getResult;
-(void)reset;
@end


@interface MBBadDrivingDetectorResult : MBObject
/**
 *  急加速次数
 */
@property(nonatomic,assign) NSInteger countOfQuickAcceleration;
/**
 *  急减次数
 */
@property(nonatomic,assign) NSInteger countOfHardBraking;
/**
 *  怠速次数
 */
@property(nonatomic,assign) NSInteger countOfIdleSpeed;
@end