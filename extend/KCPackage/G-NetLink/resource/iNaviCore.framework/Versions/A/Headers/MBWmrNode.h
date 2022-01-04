//
//  MBWmrNode.h
//  iNaviCore
//
//  Created by fanwei on 1/10/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"

/** @interface MBWmrNode
 *
 *  @brief Wmr结点信息
 */
@interface MBWmrNode : NSObject

/** @property   wmrObjId
 *
 *  @brief  当前节点id
 *  @note
 */
@property (nonatomic,assign) NSInteger nodeId;

/** @property   level
 *
 *  @brief  当前行政区划的级别, 0 是全国级, 1 是省/直辖市/自治区级, 2 是地市级
 *  @note
 */
@property (nonatomic,assign) NSInteger level;

/** @property   area
 *
 *  @brief  行政区划区域包络盒
 *  @note
 */
@property (nonatomic,assign) MBRect area;

/** @property   pos
 *
 *  @brief  行政区划的行政中心地理经纬度坐标
 *  @note
 */
@property (nonatomic,assign) MBPoint pos;

/** @property   chsName
 *
 *  @brief  行政区划汉语名称
 *  @note
 */
@property (nonatomic,retain) NSString *chsName;

/** @property   directoryName
 *
 *  @brief  行政区划所在路径
 *  @note
 */
@property (nonatomic,retain) NSString *directoryName;

/** @property   children
 *
 *  @brief  返回子节点
 */
@property (nonatomic,readonly) NSArray *children;

@property (nonatomic,retain) NSString* adminCode;
@property (nonatomic,readonly) BOOL isVirtualObj;

/**
 *
 *  @brief  初始化MBWmrNode对象
 *  @param  nodeId 节点id
 */
- (id) initWithNodeId:(NSInteger)nodeId;

+ (id) wmrNodeWithId:(NSInteger)nodeId;

/**
 *
 *  @brief  获取当前对象Id
 *  @return 当前对象Id
 */
- (NSInteger) getId;

/**
 *
 *  @brief  获取当前对象下一个兄弟节点的Id
 *  @return 兄弟节点Id
 */
- (NSInteger) getNextSiblingId;

/**
 *
 *  @brief  获取当前对象第一个子节点ID
 *  @return 第一个子节点ID
 */
- (NSInteger) getFirstChildId;

/**
 *
 *  @brief  获取当前对象的父亲节点ID
 *  @return 父亲节点ID
 */
- (NSInteger) getParentId;

/**
 *
 *  @brief  获取当前对象子节点总数
 *  @return 子节点总数
 */
- (NSInteger) getChildrenNumber;

@end
