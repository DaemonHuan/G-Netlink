//
//  MBGpsTracker.h
//  iNaviCore
//
//  Created by fanwei on 4/1/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBGpsInfo.h"

/** @protocol MBGpsManagerDelegate
 *
 *  @brief GPS管理代理
 *
 */
@protocol MBGpsManagerDelegate;

/** @interface MBGpsTracker
 *
 *  @brief GPS管理类
 *
 */
@interface MBGpsTracker : NSObject

@property(nonatomic, assign) id<MBGpsManagerDelegate> delegate;

// 获取搜索的单例对象
+(MBGpsTracker *)sharedGpsTracker;
@property(nonatomic,assign)BOOL hasReportConnected;
@property(nonatomic,assign)BOOL isFirestReport;
@property(nonatomic,retain)MBGpsInfo* currentGPSInfo;
+(BOOL) getMBGPS_STATE;
+(void) setMBGPS_STATE:(BOOL)state;
- (void)cleanup;
- (void)unregister;
- (BOOL)isRegistered;
/**
 *  获取gps链接状态，断开，链接中，已连接
 *
 *  @return 链接状态
 */
+ (MBGpsDeviceState) getDeviceState;
- (void)enableUpdateGps:(BOOL)enable;
@end

/** @protocol MBGpsManagerDelegate
 *
 *  @brief 导航回调函数
 *
 */
@protocol MBGpsManagerDelegate <NSObject>

@optional
/**
 *
 *  @brief 更新GPS信息
 *  @note
 */
- (void) didGpsInfoUpdated:(MBGpsInfo*)info;

/**
 *
 *  @brief GPS连接成功
 *  @note
 */
- (void) didGpsConnected;

/**
 *
 *  @brief GPS连接失败
 *  @note
 */
- (void) didGpsDisconnected;

@end