//
//  MBNaviLaneCollection.h
//  iNaviCore
//
//  Created by fanyl on 14-5-22.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import "MBObject.h"

/**
 单条车道的类型
 */
typedef enum MBNaviLaneType
{
	MBNaviLaneType_normal = 0,
	MBNaviLaneType_leftAdditional = 1,
	MBNaviLaneType_rightAdditional = 2,
}MBNaviLaneType;

/**
 车道牌子中的转弯方向，若干该类型数值进行按位或的结果用来标示车道箭头图标
 */
typedef enum MBNaviLaneDirection
{
	MBNaviLaneDirection_none = 0,
	MBNaviLaneDirection_straight = 1,
	MBNaviLaneDirection_right = 2,
	MBNaviLaneDirection_uTurn = 4,
	MBNaviLaneDirection_left = 8
} MBNaviLaneDirection;

/**
 车道牌子中的转弯方向，若干该类型数值进行按位或的结果用来标示车道箭头图标
 */
typedef enum {
	MBTrafficDirection_rightHand = 0, /// 靠右行驶
	MBTrafficDirection_leftHand = 1   /// 靠左行驶
} MBTrafficDirection;

@interface MBNaviLaneCollection : MBObject

@property(nonatomic,retain) NSArray* lanes;
@property(nonatomic,assign) NSInteger leftAdditionalLaneNum;
@property(nonatomic,assign) NSInteger rightAdditionalLaneNum;
@property(nonatomic,assign) MBTrafficDirection trafficDirection;
@property(nonatomic,assign) NSInteger distanceToJunction;

@end

/**
 *  车道信息
 */
@interface MBNaviLane : MBObject

/**
 *  车道方向类型 MBNaviLaneDirection，其值为 MBNaviLaneDirection 中类型的按位或的结果
 */
@property(nonatomic,assign) MBNaviLaneType type;
/**
 *  车道信息背板类型 MBNaviLaneType
 */
@property(nonatomic,assign) MBNaviLaneDirection iconId;
/**
 *  是否在航线上
 */
@property(nonatomic,assign) BOOL enroute;

@end