//
//  MBTmcReporter.h
//  iNaviCore
//
//  Created by fanyl on 14-1-14.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"
typedef enum _MBTmcReporterMode {
	MBTmcReporterMode_manual = 0,		///< 手动模式，需客户端自己实现播报逻辑，调用TmcReporter_speakNow播报
	MBTmcReporterMode_standard = 1,	///< 自动模式，按照引擎内部实现的逻辑播报
} _MBTmcReporterMode;

#ifndef MBTmcReporterMode
#define MBTmcReporterMode _MBTmcReporterMode
#endif

/**
 *  Tmc播报项目类
 */
@interface MBTmcReportItem : NSObject
/**
 *  播报状态
 */
@property(nonatomic,assign) MBTmcState state;
/**
 *  道路名字
 */
@property(nonatomic,retain) NSString* roadName;
/**
 *  道路路况，与 MBTmcState 对应
 */
@property(nonatomic,retain) NSString* roadStatus;
/**
 *  方向，自xx向xx，或xx桥至xx桥
 */
@property(nonatomic,retain) NSString* roadDirection;
/**
 *  是否已播报
 */
@property(nonatomic,assign) BOOL isReported;

-(id)initWithTmcReportItem:(id)item;

@end

@interface MBTmcReporter : NSObject
/**
 @brief 立即停止Tmc播报
 */
+(void)forceStop;
/**
 @brief 立即播报
 */
+(void)speakNow;
/**
 @brief 设置播报模式，默认为标准模式
 */
+(void)setMode:(MBTmcReporterMode)mode;

@end
