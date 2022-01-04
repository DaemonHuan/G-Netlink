//
//  MBUserCameraData.h
//  iNaviCore
//
//  Created by fanwei on 5/8/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBObject.h"
#import "MBCameraData.h"

/** @interface MBUserCameraData
 *
 *  @brief 摄像头基本数据
 *  @note
 */
@interface MBUserCameraData : MBObject

/** @property   cameraData
 *
 *  @brief  摄像头数据
 *  @note
 */
@property (retain,nonatomic) MBCameraData* cameraData;

/** @property   name
 *
 *  @brief  摄像头名称
 *  @note
 */
@property (retain,nonatomic) NSString* name;
@property (assign,nonatomic) int userCameraId;
@property (retain,nonatomic) NSString* userData;
@end
