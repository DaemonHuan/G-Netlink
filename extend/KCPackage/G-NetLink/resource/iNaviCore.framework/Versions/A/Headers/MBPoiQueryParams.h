//
//  MBPoiQueryParams.h
//  iNaviCore
//
//  Created by fanwei on 1/28/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

/** @interface MBPoiQueryParams
 *
 *  @brief 初始化POI查询需要的基本初始化项
 *      
 */
@interface MBPoiQueryParams : NSObject

/** @property   maxResultNumber
 *
 *  @brief  搜索结果的个数限制
 *  @note
 */
@property (nonatomic, assign) NSInteger maxResultNumber;
 
/** @property   searchRange
 *
 *  @brief  周边搜索的距离，单位：米
 *  @note
 */
@property (nonatomic, assign) NSInteger searchRange;

@end
