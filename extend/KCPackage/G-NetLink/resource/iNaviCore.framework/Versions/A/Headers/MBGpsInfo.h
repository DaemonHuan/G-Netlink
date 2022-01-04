//
//  MBGpsInfo.h
//  iNaviCore
//
//  Created by fanwei on 4/1/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"
#import "MBSatellite.h"



/** @interface MBGpsInfo
 *
 *  @brief GPS基本信息
 *
 */
@interface MBGpsInfo : NSObject

/** @property   valid
 *
 *  @brief  是否有效
 *  @note
 */
@property (nonatomic, assign) BOOL valid;

/** @property   dateTime
 *
 *  @brief  时间
 *  @note
 */
@property (nonatomic, assign) MBDateTime dateTime;

/** @property   pos
 *
 *  @brief  坐标
 *  @note
 */
@property (nonatomic, assign) MBPoint pos;

/** @property   altitude
 *
 *  @brief  海拔
 *  @note
 */
@property (nonatomic, assign) NSInteger	altitude;

/** @property   ori
 *
 *  @brief  方向
 *  @note
 */
@property (nonatomic, assign) NSInteger	ori;

/** @property   speed
 *
 *  @brief  速度
 *  @note
 */
@property (nonatomic, assign) NSInteger	speed;
/** @property   speed
 *
 *  @brief  速度 float型
 *  @note
 */
@property (nonatomic, assign) float	fSpeed;
/** @property   latString
 *
 *  @brief  纬度
 *  @note
 */
@property (nonatomic, retain) NSString*	latString;

/** @property   lonString
 *
 *  @brief  经度
 *  @note
 */
@property (nonatomic, retain) NSString*	lonString;

/** @property   quality3D
 *
 *  @brief  POI名称
 *  @note
 */
@property (nonatomic, assign) BOOL quality3D;

/** @property   hdop
 *
 *  @brief  hdop
 *  @note
 */
@property (nonatomic, assign) NSInteger	hdop;

/** @property   pdop
 *
 *  @brief  pdop
 *  @note
 */
@property (nonatomic, assign) NSInteger	pdop;

/** @property   vdop
 *
 *  @brief  vdop
 *  @note
 */
@property (nonatomic, assign) NSInteger vdop;

/** @property   satInViewNum
 *
 *  @brief  
 *  @note
 */
@property (nonatomic, assign) NSInteger satInViewNum;

/** @property   satNum
 *
 *  @brief  卫星数量
 *  @note
 */
@property (nonatomic, assign) NSInteger	satNum;

/** @property   satellites
 *
 *  @brief  卫星信息
 *  @note
 */
@property (nonatomic, retain) NSMutableArray*  satellites;

/** @property   stamp
 *
 *  @brief  邮编
 *  @note
 */
@property (nonatomic, assign) NSInteger stamp;

/** @property   angle
 *
 *  @brief  角度
 *  @note
 */
@property (nonatomic, assign) NSInteger	angle;

@end
