//
//  MBMapState.h
//  iNaviCore
//
//  Created by fanyl on 14-3-4.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"
@interface MBMapState : NSObject
/**
 *  地图中心点
 */
@property (nonatomic,assign) MBPoint worldCenter;
/**
 *  方向
 */
@property (nonatomic,assign) CGFloat heading;
/**
 *  缩放
 */
@property (nonatomic,assign) CGFloat zoomLevel;
/**
 *  仰角
 */
@property (nonatomic,assign) CGFloat elevation;
@property (nonatomic,assign) MBRect viewport;
@property (nonatomic,assign) CGFloat viewShiftX;//Default value: 0
@property (nonatomic,assign) CGFloat viewShiftY;//i.e. previous viewShift, Default value: 0
@property (nonatomic,assign) CGFloat dpiFactor;
@end
