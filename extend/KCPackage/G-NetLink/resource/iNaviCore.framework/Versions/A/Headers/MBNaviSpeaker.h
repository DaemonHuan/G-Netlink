//
//  MBNaviSpeaker.h
//  iNaviCore
//
//  Created by fanwei on 4/11/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviSessionData.h"

/** @interface MBNaviSpeaker
 *
 *  @brief 语音播报管理类
 *
 */
@interface MBNaviSpeaker : NSObject
/**
 * 强制播报语音
 */
+ (void)forcePlay;
/**
 * 强制停止播报语音，清空语音队列，该方法在导航过程中才有效，即- (void)takeRoute:(MBRouteBase*)route方法之后。
 */
+ (void)forceStop;
/**
 * 播报语音或媒体文件<br>
 * 支持播报*.mp3或*.wav
 *
 * @param str
 *            需要播报的语音字符串或媒体文件路径
 */
+ (void)enqueueWith:(NSString *)str;
/**
 * 语音是否正在播报中
 *
 * @return 如果正在播报中返回true，否则返回false
 */
+ (BOOL)isPlaying;
/**
 *  得到时间间隔
 *
 *  @return 时间间隔
 */
+(int)getInterval;
/**
 *  限速
 *
 *  @param level 限速大小
 *
 *  @return 是否成功
 */
+(int)getLimit:(int)level;
/**
 *  设置时间间隔
 *
 *  @param interval 时间间隔
 */
+(void)setInterval:(int) interval;
/**
 *  根据等级设置限速
 *
 *  @param level 等级
 *  @param limit 速度
 */
+(void)setLimit:(int) level limit:(int) limit;
/**
 * 启用后台语音播报
 */
+ (void)resignFirstAudioSession;
+ (void)enableBackgroundPlay:(BOOL)enable;
/**
 *  设置播报模式
 *
 *  @param mode 播报模式：精简模式，标准模式，安全模式
 */
+ (void)setGuidanceEngineMode:(int)mode;
/**
 *  播报模式
 *
 *  @return 播报模式
 */
+ (MBGuidanceMode)getGuidanceEngineMode;
/**
 *  开启/关闭到达目的地后的方向播报
 *
 *  @param enable 是否打开
 */
-(void)enableDestinationOrientation:(BOOL)enable;
/**
 *  到达目的地后的方向播报是否打开
 */
-(void)isDestinationOrientationEnabled;
@end
