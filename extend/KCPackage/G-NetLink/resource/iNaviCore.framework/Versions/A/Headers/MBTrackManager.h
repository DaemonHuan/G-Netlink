//
//  MBTrackManager.h
//  iNaviCore
//
//  Created by fanwei on 4/25/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MBTrackManagerErrorCode {
	MBETMEC_Succ,
	MBETMEC_NoGPSSignal,
	MBETMEC_AchiveIsFull,
	MBETMEC_IOError
} MBTrackManagerErrorCode;

/** @interface MBTrackManager
 *
 *  @brief 轨迹记录与查看相关的接口
 *  @note
 */
@interface MBTrackManager : NSObject

/**
 *
 *  @brief  初始化轨迹管理模块
 *  @return MBTrackManager
 *  @note   此方法必须在{@link TrackManager}的其他方法调用前调用，注意：不能重复调用，否则报错
 */
- (id) init;

/**
 *
 *  @brief  清理轨迹管理模块资源
 *  @return 空
 *  @note   
 */
- (void)cleanup;

/**
 *
 *  @brief  删除所有轨迹记录
 *  @return 空
 *  @note
 */
- (void)deleteAllTracks;

/**
 *
 *  @brief  删除指定的轨迹记录文件
 *  @param  fileName 轨迹记录文件名称
 *  @return 是否删除成功，成功返回true，否则返回false
 *  @note   
 */
-(BOOL)deleteTrack:(NSString*)fileName;

/**
 *
 *  @brief  是否正在记录轨迹
 *  @return 正在记录返回true，否则返回false
 *  @note
 */
-(BOOL)isRecording;

/**
 *
 *  @brief  停止记录轨迹
 *  @return 空
 *  @note
 */
- (void)stop;

/**
 *
 *  @brief  获取当前正在记录的轨迹文件名称
 *  @return 轨迹文件名称
 *  @note
 */
-(NSString*)getCurrentTrackName;

/**
 *
 *  @brief  生成一条新轨迹
 *  @return 空
 *  @note
 */
- (MBTrackManagerErrorCode)newTrack;

/**
 *
 *  @brief  获取当前所有已经存在的轨迹记录文件，并返回文件名数组
 *  @return 轨迹记录文件数组
 *  @note
 */
-(NSArray*)getAllTracks;

/**
 *
 *  @brief  设置保存轨迹的文件夹
 *  @param  path	文件夹路径
 *  @return 空
 *  @note
 */
- (void)setBaseFolder:(NSString*)path;
@end
