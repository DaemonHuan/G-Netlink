//
//  MBPoiTypeObject.h
//  iNaviCore
//
//  Created by fanwei on 1/28/13.
//  Revise by chendl@mapbar.com on 2013-04-16
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

/** @interface MBPoiTypeObject
 *
 *  @brief POI类型对象
 *
 */
@interface MBPoiTypeObject : NSObject

/** @property  parentPoiTypeObjectId
 *
 *  @brief  返回父节点Id
 *  @note
 */
@property(nonatomic,readonly) NSInteger parentPoiTypeObjectId;

/** @property   poiTypeObjectId
 *
 *  @brief  POI类型索引，取值范围是[0, POI类型对象总数 - 1]
 *  @note
 */
@property (nonatomic,readonly) NSInteger poiTypeObjectId;

/** @property   level
 *
 *  @brief  POI类型对象的层级
 *  @note
 */
@property (nonatomic,readonly) NSInteger level;

/** @property   name
 *
 *  @brief  POI类型的名称
 *  @note
 */
@property (nonatomic,readonly) NSString *name;

/** @property   finally
 *
 *  @brief  此POI节点是否为最终层级
 *  @note   如果为最终层级，表示此节点不再有子节点，所以用户点击时不能进入下一层，而是选中该类型<br>true 表示为最终层级节点， false 表示为非最终层级节点
 */
@property (nonatomic,readonly) BOOL finally;

/** @property   naviInfoId
 *
 *  @brief  POI类型码
 *  @note   可能是{@link PoiTypeManager#ALL_TYPES}、{@link PoiTypeManager#ALL_SUB_TYPES} 这样的特殊值<br>也可能是POI的类型编码(产品提供的以四维图新类型编码为基础的一套编码)
 */
@property (nonatomic,readonly) NSInteger naviInfoId;

/** @property   score
 *
 *  @brief  POI类型的分值，目前没有使用
 *  @note
 */
@property (nonatomic,readonly) NSInteger score;

/** @property   children
 *  @brief  返回子节点
 */
@property (nonatomic,readonly) NSArray *children;

/**
 *
 *  @brief  初始化MBPoiTypeObject对象
 *  @param  节点id
 */
- (id)initWithPoiTypeObjectId:(NSInteger)poiTypeObjectId;

@end
