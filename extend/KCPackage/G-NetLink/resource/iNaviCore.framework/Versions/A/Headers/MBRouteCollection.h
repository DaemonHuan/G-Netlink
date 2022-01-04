//
//  MBRouteCollection.h
//  iNaviCore
//
//  Created by fanwei on 3/8/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBRouteBase;
/** @interface MBRouteCollection
 *
 *  @brief 路线集合
 *
 */
@interface MBRouteCollection : NSObject<NSCopying ,NSMutableCopying>

/**
 *
 *  @brief      初始化
 *  @return     self
 *  @note
 */
-(id)init;

/** @property   num
 *
 *  @brief  路线条数
 *  @note
 */
@property(assign,nonatomic)NSInteger num;

/** @property   routeBases
 *
 *  @brief  路线
 *  @note
 */
@property(retain,nonatomic)NSMutableArray *routeBases;
/**
 *@brief 清空路线
 *
 */
- (void) removeALL;

/**
 *@brief 加入路线
 *
 *
 */
-(void) addRoute:(MBRouteBase*) route;
@end
