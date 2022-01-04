//
//  MBGPSManager.h
//  iNaviCore
//
//  Created by fanyl on 13-8-13.
//  Copyright (c) 2013年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MBGpsInfo.h"

@protocol MBGpsLocationDelegate;

/** @protocol MBGpsManagerDelegate
 *
 *  @brief GPS管理代理,导航回调函数
 *
 */
@protocol MBGpsLocationDelegate <NSObject>
@optional
/**
 *
 *  @brief 更新GPS信息
 *  @note
 */
- (void) didGpsInfoUpdated:(MBGpsInfo*)info;
@end

@interface MBGpsLocation : NSObject
@property(nonatomic, assign) id<MBGpsLocationDelegate> delegate;
/**
 *
 *  @brief 打开GPS信息
 *  @note
 */
- (void)startUpdatingLocation;
/**
 *
 *  @brief 关闭GPS信息
 *  @note
 */
- (void)stopUpdatingLocation;
@end
