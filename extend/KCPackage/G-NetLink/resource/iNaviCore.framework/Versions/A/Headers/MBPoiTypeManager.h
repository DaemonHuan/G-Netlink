//
//  MBPoiTypeManager.h
//  iNaviCore
//
//  Created by fanwei on 1/28/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBPoiType.h"

/** @interface MBPoiTypeManager
 *
 *  @brief POI类型管理类
 *
 */
@interface MBPoiTypeManager : NSObject
/**
 *
 *  @brief  返回默认的PoiTypeManager,需要先初始化MBPoiQuery和MBWorldManager。
 */
+ (MBPoiTypeManager *)defaultPoiTypeManager;

/**
 *
 *  @brief  返回表示"周边快捷类型"的POI类型对象，即，整个POI类型树的根节点
 *  @return POI类型树的根节点对象
 *  @note
 */
- (MBPoiType *)rootPoiTypeObject;

/**
 *
 *  @brief  返回表示"周边更多类型"的POI类型对象
 *  @return POI类型对象
 *  @note
 */
- (MBPoiType *)rootKeyQueryPoiTypeObject;
/**
 *
 *  @brief  返回表示"周边快捷类型"的POI类型索引值，即，整个POI类型树的根节点
 *  @return POI类型树的根节点ID
 *  @note
 */
- (NSInteger) getRoot;

/**
 *
 *  @brief  获取POI类型树中指定节点的第一个子节点Id
 *  @param  index    指定POI节点ID
 *  @return 第一个子节点ID
 *  @note
 */
- (NSInteger) getFirstChildId:(NSInteger)index;

/**
 *
 *  @brief  获取类型树中指定节点的下一个兄弟节点
 *  @param  index    指定POI节点ID
 *  @return 兄弟节点ID
 *  @note
 */
- (NSInteger) getNextSibling:(NSInteger)index;

/**
 *
 *  @brief  获取POI类型树中指定节点的父节点
 *  @param  index    指定POI节点ID
 *  @return 父节点ID
 *  @note
 */
- (NSInteger) getParent:(NSInteger)index;

/**
 *
 *  @brief  根据POI类型索引获取POI类型对象
 *  @param  typeId  POI类型ID(索引)
 *  @return POI类型对象
 *  @note
 */
- (MBPoiType *) getObjectById:(NSInteger)typeId;

/**
 *
 *  @brief  获取POI类型树中的节点总数
 *  @return 获取到无效结果，则返回-1
 *  @note
 */
- (NSInteger) getObjectNumber;


/**
 *
 *  @brief  返回POI类型树中具有指定名称的节点ID
 *  @param  name        类型名称
 *  @return POI类型ID
 *  @note   由于不同数据中的类型名称会有所差异，所以最好不要使用这个方法
 */
- (NSInteger) getIndexByName:(NSString *)name;

/**
 *
 *  @brief  返回表示"周边更多类型"的POI类型索引
 *  @return POI类型索引
 *  @note
 */
- (NSInteger) getKeyQueryTypeRoot;

/**
 *
 *  @brief  获取指定的POI类型码在类型树"周边更多类型"节点之下对应的节点索引
 *  @param  type 指定的POI类型码
 *  @return POI类型索引
 *  @note
 */
- (NSInteger) getIndexByType:(NSInteger)type;


@end
