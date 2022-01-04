//
//  MBGpsDebug.h
//  GpsDebug
//
//  Created by fanyl on 13-9-9.
//  Copyright (c) 2013年 fanyl. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 设置Debugger的模式<br>
 * 使用引擎提供的调试模式，使用gps_log模拟真实导航模式
 */
@interface MBGpsDebugger : NSObject

@property (nonatomic, retain)NSString* fileName;
/**
 * 获取当前播放到哪一帧
 *
 * @return 返回当前帧
 */
-(int)getCurrentFrameIndex;
/**
 * 根据帧索引，设置帧位置
 */
-(void)setFrameByIndex:(int)index;
/**
 * 获取当前数据总帧数<br>
 * 也就是当前gps_log轨迹中的记录的gps点数
 *
 * @return 总帧数
 */
-(int)getFrameNumber;
/**
 * 获取当前帧率，即，每秒钟播放多少帧
 *
 * @return 帧率
 */
-(int)getSpeed;
/**
 * 设置播放速度，即，每秒钟播放多少帧数据
 */
-(void)setSpeed:(int)speed;
/**
 * 打开日志记录
 */
-(void)startLogging;
/**
 * 载入gps_log文件
 */
-(BOOL)load:(NSString*)filename;
/**
 * 卸载gps_log文件
 */
-(BOOL)unload;
/**
 * 开始播放
 */
-(void)play;
/**
 * 停止播放
 */
-(void)stop;
/**
 * 暂停播放
 */
-(void)pause;
@end
