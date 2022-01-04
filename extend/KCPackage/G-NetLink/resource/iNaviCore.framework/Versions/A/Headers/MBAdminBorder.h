//
//  MBAdminBorder.h
//  iNaviCore
//
//  Created by fanyl on 14-6-10.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBNaviCoreTypes.h"

@class MBWmrNode;
/**
 * 行政区划边界
 */
@interface MBAdminBorder : NSObject
{
@public
    MBPoint** _p;
}
/**
 * 行政区划ID
 */
@property(nonatomic,assign) int nodeId;
/**
 *  每个多边形的点个数
 */
@property(nonatomic,assign) NSArray* polygonNum;
/**
 *  根据城市节点得到城市边界
 *
 *  @param node 城市节点
 *
 *  @return 城市边界
 */
-(id) initWithNode:(MBWmrNode*) node;

@end
