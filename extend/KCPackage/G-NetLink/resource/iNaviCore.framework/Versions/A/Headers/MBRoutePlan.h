//
//  MBRoutePlan.h
//  iNaviCore
//
//  Created by fanwei on 2/22/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"
#import "MBPoiFavorite.h"


/** @interface MBRoutePlan
 *
 *  @brief 路线的查询方案
 *  @note
 */
@interface MBRoutePlan : NSObject

/**
 * @brief      目的点集合
 */
@property(nonatomic,readonly) NSArray *destinationPoiObjects;
/**
 *  是否使用tmc
 */
@property(nonatomic,assign) BOOL useTmc;
+(void)routePlanCopyTo:(MBRoutePlan*)newPlan from:(MBRoutePlan*)oldPlan;
/**
 *
 *  @brief      初始化
 *  @return     self
 *  @note
 */
- (id) init;

/**
 *
 *  @brief      初始化路线查询方案
 *  @param      plan 路线计划
 *  @return     self
 *  @note
 */
- (id) initWithRoutePlan:(id)plan;

/**
 *
 *  @brief      获取路线方案
 *  @return     plan 路线计划
 *  @note
 */
- (void*) getRoutePlan;

/**
 *
 *  @brief      设置路线规划起点方向角
 *  @param      ori 起点方向角
 *  @return     空
 *  @note
 */
- (void)setOrigionOrientation:(NSInteger)ori;

/**
 *
 *  @brief      返回路线规划起点方向角
 *  @return     当前起点的方向角
 *  @note
 */
- (NSInteger)getOrigionOrientation;

/**
 *
 *  @brief      设置算路规则
 *  @param      rule 具体的路线规划规则
 *  @return     空
 *  @note
 */
- (void)setRule:(MBRouteRule)rule;

/**
 *
 *  @brief      获取当前路线规划规则
 *  @return     当前的路线规划规则
 *  @note
 */
- (NSInteger)getRule;

/**
 *
 *  @brief      设置路线规划避让
 *  @param      avoidRoadType 具体的路线规划避让
 *  @return     空
 *  @note
 */
- (void)setAvoidRoadType:(MBAvoidRoadType)avoidRoadType;

/**
 *
 *  @brief      获取路线规划避让
 *  @return     当前的路线规划避让
 *  @note
 */
- (MBAvoidRoadType)getAvoidRoadType;

/**
 *
 *  @brief      获取目的点数组中的点个数
 *  @return     当前路线规划方式中目的点个数
 *  @note
 */
- (NSInteger)getDestinationNum;

/**
 *
 *  @brief      根据索引值获取当前路线规划中的POI信息
 *  @param      index	索引值
 *  @return     指定索引值的目POI点信息
 *  @note
 */
-(MBPoiFavorite *)getDestination:(NSInteger)index;

/**
 *
 *  @brief      设置路线规划中的指定索引值的POI点信息，用于算路
 *  @param      index	索引值
 *  @param      fav	需要指定的POI信息
 *  @return     空
 *  @note       使用此方法将覆盖原本索引值所在的POI点信息
 */
- (void)setDestination:(NSInteger)index favorite:(MBPoiFavorite *)fav;

/**
 *
 *  @brief      在指定索引的位置插入POI点
 *  @param
 *  @return     空
 *  @note       插入之后，此索引位置以后的点都向后移动
 */
- (void)insertDestination:(NSInteger)index favorite:(MBPoiFavorite *)fav;

/**
 *
 *  @brief      在指定索引的位置插入POI点
 *  @param
 *  @return     空
 *  @note       插入之后，此索引位置以后的点都向后移动
 */
- (void)addDestination:(MBPoiFavorite *)fav;

/**
 *
 *  @brief      删除指定索引值的目标POI点
 *  @param      index	索引值
 *  @return     空
 *  @note
 */
- (void)removeDestination:(NSInteger)index;

/**
 *
 *  @brief      清楚所有目标点
 *  @return     空
 *  @note
 */
- (void)clearDestinations;

/**
 *
 *  @brief      设置途经点，使用此方法将替换原本设置过的途经点，途经点最多只能有三个
 *  @param      index	途经点所在下标，取值范围：[0, 2]
 *  @param      fav	途经点Poi对象
 *  @return     如果设置成功则返回YES，否则返回NO
 *  @note       一般失败的原因是没有设置终点或起点，或者设置的索引超过了2
 */
- (void)swapDestinations:(NSInteger)index1 index2:(NSInteger)index2;

/**	@brief RoutePlan 是否已满
 @memberof RoutePlan
 @details
 RoutePlan 中最多只有有5个点: 起点、终点和3个途经点.
 
 @deprecated
 A deprecated hard limit. New RoutePlan uses vector storage, so there is no hard limit.
 */
- (BOOL)isFull;

/**
 *
 *  @brief      验证当前坐标点是否有效
 *  @param      index 点的下标
 *  @return     错误枚举MBErrorCode
 *  @note
 */
- (MBErrorCode)verify:(NSInteger)index;

/**
 *
 *  @brief      将错误枚举转换为字符串
 *  @param      err	枚举代码 ErrorCode
 *  @return     错误字符串
 *  @note
 */
- (NSString *)errCodeToString:(MBErrorCode)err;

/**
 *
 *  @brief      通过GPS更新起点坐标
 *  @return     空
 *  @note
 */
- (void)updateStartPointByGps;

/**
 *
 *  @brief      保存路线规划文件
 *  @param      fileName	文件路径
 *  @return     保存成功返回YES，否则返回NO
 *  @note
 */
- (BOOL)save:(NSString*)fileName;

/**
 *
 *  @brief      载入上次保存的路径
 *  @param      fileName	文件路径
 *  @return     载入成功返回YES，否则返回NO
 *  @note
 */
- (BOOL)load:(NSString*)fileName;

/**
 *
 *  @brief      设置起点
 *  @param      fav	起点的Poi对象
 *  @return     空
 *  @note
 */
- (void)setStartPoint:(MBPoiFavorite *)fav;

/**
 *
 *  @brief      设置终点
 *  @param      fav	终点Poi对象
 *  @return     是否正确设置终点，YES为正确设置终点，可以导航，NO为设置错误，一般起点未设置的问题
 *  @note
 */
- (BOOL)setEndPoint:(MBPoiFavorite *)fav;

/**
 *
 *  @brief      添加途经点，顺序添加，途经点最多只能有三个
 *  @param      fav	途经点Poi对象
 *  @return     如果设置成功返回YES，否则返回NO
 *  @note       失败的原因一般是没有设置起点终点，或者途经点个数超过了3个
 */
- (BOOL)addWayPoint:(MBPoiFavorite *)fav;

/**
 *
 *  @brief      设置途经点，使用此方法将替换原本设置过的途经点，途经点最多只能有三个
 *  @param      index       途经点所在下标，取值范围：[0, 2]
 *  @param      favorite    途经点Poi对象
 *  @return     如果设置成功则返回YES，否则返回NO
 *  @note       一般失败的原因是没有设置终点或起点，或者设置的索引超过了2
 */
- (BOOL)setWayPoint:(NSInteger)index favorite:(MBPoiFavorite *)fav;

/**
 *
 *  @brief      获取途经点数量
 *  @return     途经点数量
 *  @note       
 */
- (NSInteger)getWayPointNumber;

/**
 *
 *  @brief      移除指定索引的途经点对象
 *  @param      index	途经点索引
 *  @return     如果移除成功，返回true，否则返回false
 *  @note       一般来说，移除失败主要是索引值不对
 */
- (BOOL)removeWayPoint:(NSInteger)index;

/**
 *
 *  @brief      移除所有途经点
 *  @return     空
 *  @note
 */
- (void) removeAllWayPoint;
@end
