//
//  MBPoiType.h
//  iNaviCore
//
//  Created by fanwei on 1/28/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

/** @interface MBPoiType
 *
 *  @brief POI类型对象，比如加油站
 *
 */
@interface MBPoiType : NSObject

/** @property   typeId
 *
 *  @brief  POI类型索引，取值范围是[0, POI类型对象总数 - 1]
 *  @note
 */
@property (nonatomic) NSInteger typeId;

/** @property   level
 *
 *  @brief  POI类型对象的层级
 *  @note
 */
@property (nonatomic) NSInteger level;

/** @property   name
 *
 *  @brief  POI类型的名称
 *  @note
 */
@property (nonatomic,retain) NSString *name;

/** @property   isFinal
 *
 *  @brief  此POI节点是否为最终层级
 *  @note   如果为最终层级，表示此节点不再有子节点，所以用户点击时不能进入下一层，而是选中该类型<br>true 表示为最终层级节点， false 表示为非最终层级节点
 */
@property (nonatomic) BOOL isFinal;

/** @property   naviInfoId
 *
 *  @brief  POI类型码
 *  @note   可能是{@link PoiTypeManager#ALL_TYPES}、{@link PoiTypeManager#ALL_SUB_TYPES} 这样的特殊值<br>也可能是POI的类型编码(产品提供的以四维图新类型编码为基础的一套编码)
 */
@property (nonatomic) NSInteger naviInfoId;

/** @property   score
 *
 *  @brief  POI类型的分值，目前没有使用
 *  @note
 */
@property (nonatomic) NSInteger score;

/** @property  parentPoiTypeObjectId
 *
 *  @brief  返回父节点Id
 *  @note
 */
@property(nonatomic,readonly) NSInteger parentPoiTypeObjectId;

/** @property   children
 *  @brief  返回子节点
 */
@property (nonatomic,readonly) NSArray *children;
/**
 *
 *  @brief  初始化MBPoiType对象
 *  @param  节点id
 */
- (id)initWithPoiTypeObjectId:(NSInteger)poiTypeObjectId;

@end
