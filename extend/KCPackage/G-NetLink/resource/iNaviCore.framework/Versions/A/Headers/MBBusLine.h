//
//  MBBusLine.h
//  iNaviCore
//
//  Created by fanyl on 14-5-28.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import "MBObject.h"
#import "MBNaviCoreTypes.h"
#import "MBBus.h"

/**
 * 公交线路信息
 */
@interface MBBusLine : MBObject
/*
 * 公交线路id</br> 用准确名称当id，比如"1路上行(靛厂新村-四惠枢纽站)"
 */
@property(nonatomic,retain) NSString* busId;
/**
 * 公交线路名称</br> 是简称，和id不同，用于显示，比如"1路"
 */
@property(nonatomic,retain) NSString* name;
/**
 * 路线类型
 *
 * @see BusLine.Type
 */
@property(nonatomic,assign) MBBusLineType type;
/**
 * 反向路线id</br> 比如"1路下行(四惠枢纽站-靛厂新村)"
 */
@property(nonatomic,retain) NSString* oppositeLineId;
/**
 * 起点名称
 */
@property(nonatomic,retain) NSString* startStation;
/**
 * 终点名称
 */
@property(nonatomic,retain) NSString* endStation;
/**
 * 路线长度，单位：千米
 */
@property(nonatomic,retain) NSString* length;
/**
 * 刷卡信息
 */
@property(nonatomic,retain) NSString* card;
/**
 * 票制
 */
@property(nonatomic,retain) NSString* rule;
/**
 * 全程票价，单位：元
 */
@property(nonatomic,retain) NSString* price;
/**
 * 起点站首末班车时间
 */
@property(nonatomic,retain) NSString* origTimeSpan;
/**
 * 终点站首末班车时间
 */
@property(nonatomic,retain) NSString* destTimeSpan;
/**
 * 所属公司
 */
@property(nonatomic,retain) NSString* company;
/**
 * 发车间隔
 */
@property(nonatomic,retain) NSString* interval;
/**
 * 高峰发车间隔
 */
@property(nonatomic,retain) NSString* rushTimeInterval;
/**
 * 月票是否有效
 */
@property(nonatomic,retain) NSString* monthTicket;
/**
 * 是否为空调车
 */
@property(nonatomic,retain) NSString* airConditioner;
/**
 * 该公交线路所有公交站数目
 */
@property(nonatomic,assign) NSInteger stationNum;
/**
 * 该公交线路所有公交站id集合
 */
@property(nonatomic,retain) NSArray* stationIds;
/**
 * 该公交线路所有公交站名称集合，与id集合对应
 */
@property(nonatomic,retain) NSArray* stationNames;
/**
 * 点列表，绘图用
 */
@property(nonatomic,assign) MBPoint* stationPositions;
/**
 * 点列表个数，绘图用
 */
@property(nonatomic,assign) NSInteger pointNum;
/**
 * 获取公交线路id，id为准确名称，比如"1路上行(靛厂新村-四惠枢纽站)"
 */
@property(nonatomic,assign) MBPoint* points;

@end
