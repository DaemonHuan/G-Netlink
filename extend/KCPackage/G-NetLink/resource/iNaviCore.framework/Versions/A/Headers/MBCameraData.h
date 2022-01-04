//
//  MBCameraData.h
//  iNaviCore
//
//  Created by fanwei on 4/12/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBObject.h"
#import "MBNaviCoreTypes.h"

@interface MBCameraData : MBObject

@property (assign,nonatomic) MBPoint            position;                      //< 电子眼所在位置的经纬度坐标
@property (assign,nonatomic) MBCameraType		type;               //< 电子眼的类型
@property (assign,nonatomic) NSInteger			absDistance;        //< 从路线起点到该电子眼的距离，单位：米
@property (assign,nonatomic) NSInteger			angle;              //< 电子眼角度
@property (assign,nonatomic) NSInteger			speedLimit;         //< 电子眼的限速值，单位：公里/小时。如果没有限速值，则为 0
@property (assign,nonatomic) BOOL               isDanger;//< 是否为违章高发电子眼
@property (assign,nonatomic) NSInteger			distance;			//< 当前电子眼到车的距离
@property (assign,nonatomic) BOOL               isUserCamera;
@property (assign,nonatomic) NSInteger			broadcastedTimes;	//< 当前电子眼播报过的次数
@property (assign,nonatomic) NSInteger			unChecked;			//< 在前方区域内, 未检测到此摄像头的次数
@property (assign,nonatomic) NSInteger			reportDistance;		//< 播报时的距离,主要用来计算进度条
@property (assign,nonatomic) NSInteger			priority;			//< 数据的优先级, 数据排序时使用
@end
