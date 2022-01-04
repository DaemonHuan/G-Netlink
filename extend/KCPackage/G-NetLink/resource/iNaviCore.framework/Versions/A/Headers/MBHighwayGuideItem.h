//
//  MBHighwayGuideItem.h
//  iNaviCore
//
//  Created by fanwei on 4/24/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBObject.h"
#import "MBNaviCoreTypes.h"
#import "MBObject.h"

/** @interface MBHighwayGuideItem
 *
 *  @brief 高速相关基本信息
 *  @note
 */
@interface MBHighwayGuideItem : MBObject

/** @property   type
 *
 *  @brief  行程信息类型：出口/高速连接线/服务区/收费站
 *  @note
 */
@property (nonatomic, assign) MBHighwayGuideType type;

/** @property   absDistance
 *
 *  @brief  从起点到这个信息点的绝对距离
 *  @note
 */
@property (nonatomic, assign) NSInteger absDistance;

/** @property   distance
 *
 *  @brief  相对距离，从当前自车位置到该行程信息所在地的距离，单位：米
 *  @note
 */
@property (nonatomic, assign) NSInteger distance;

/** @property   name
 *
 *  @brief  行程信息文字。如："天水大街;黄村"、"京开高速;西红门南桥;南五环"、"马驹桥服务区"等
 *  @note
 */
@property (nonatomic, retain) NSString *name;

/** @property   onRoute
 *
 *  @brief  是否在路线上，即：该行程信息所指向的方向是否就在路线上
 *  @note
 */
@property (nonatomic, assign) BOOL onRoute;
/**
 *  @brief 真实下标。
 即该行程信息在从自车位置起沿路线的行程信息序列中的下标。
 */
@property (nonatomic, assign) NSInteger actualIndex;

@end
