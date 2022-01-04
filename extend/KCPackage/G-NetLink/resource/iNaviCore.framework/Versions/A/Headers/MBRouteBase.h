//
//  MBRouteBase.h
//  iNaviCore
//
//  Created by fanwei on 2/26/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"
#import "MBRoutePlan.h"
#import "MBRouteDescriptionItem.h"

struct RouteArrowData ;
typedef struct RouteArrowData  RouteArrowData;

struct RouteArrowData
{
    MBPoint *pts;
    int lenght;
};

typedef enum MBRerouteReaseon
{
	MBRerouteReaseon_unknown = 0,
	MBRerouteReaseon_tmcHeavy = 1,
	MBRerouteReaseon_tmcBlock = 2
}MBRerouteReaseon;

/** @interface MBRouteBase
 *
 *  @brief 路线的基本信息
 *  @note
 */
@interface MBRouteBase : NSObject

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
 *  @param      base 路线
 *  @return     self
 *  @note
 */
- (id) initWithRouteBase:(void*)base;

/**
 *
 *  @brief      获取路线
 *  @return     base 路线
 *  @note
 */
- (void*)getRouteBase;

/** 
 *
 *  @brief      获取当前路线类型为在线还是离线
 *  @return     返回MBRouteType类型的结果
 *  @note
 */
- (MBRouteType)getType;

/** 
 *
 *  @brief      获取当前路线长度，单位：米
 *  @return     返回路线长度
 *  @note
 */
- (NSInteger)getLength;

/**
 *
 * @brief      获取当前路线的描述信息
 * @return     返回路线的描述信息
 * @note
 */
- (NSString *)getDescription;

/**
 *
 *  @brief      获取当前路线是否有收费
 *  @return     返回判断值YES表示有
 *  @note
 */
- (BOOL)hasToll;
/**
 *
 *  @brief      获取当前路线是否有轮渡
 *  @return     返回判断值YES表示有
 *  @note
 */
- (BOOL)hasSailing;

/**
 *
 *  @brief      根据当前所行驶的距离和车速，获取路线上的剩余时间，单位：秒
 *  @param      travelledDistance	已经走过的距离
 *  @param      speed	当前车速
 *  @return     路线上所剩下的时间
 *  @note
 */
- (NSInteger)getRemainingTime:(NSInteger)travelledDistance speed:(float)speed;

/**
 *
 *  @brief      路线全程所需时间，单位：秒
 *  @return     全程所需时间
 *  @note
 */
- (NSInteger)getEstimatedTime;

/**
 *
 *  @brief      获取路线规划对象
 *  @return     MBRoutePlan 当前道路的路线规划对象
 *  @note
 */
- (MBRoutePlan *)getPlan;

/**
 *
 *  @brief      路线的开始方向，单位：度
 *  @return     起始路线方向
 *  @note
 */
- (NSInteger)getStartDirection;

/**
 *
 *  @brief      获取当前路线的包络盒
 *  @return     当前路线包络盒
 *  @note
 */
- (MBRect)getBoundingBox;

/**
 *
 *  @brief      获取路线上的第一个形状点
 *  @return     路线上的第一个形状点
 *  @note
 */
- (MBPoint)getFirstShapePoint;

/**
 *
 *  @brief      获取路线上最后一个形状点
 *  @return     路线上最后一个形状点
 *  @note
 */
- (MBPoint)getLastShapePoint;

/**
 *
 *  @brief      设置路线详情的显示方式
 *  @param      RouteBase.DirectionsFlag
 *  @return     空
 *  @see        RouteBase.DirectionsFlag
 *  @see        getCurrentIndexInDescriptions
 *  @see        getDescriptionNumber
 *  @see        getDescriptionItem
 *  @note
 */
- (void)setDirectionsFlag:(NSInteger)flag;

/**
 *
 *  @brief      返回当前车所在路线上的位置所对应的路线详情下标
 *  @param      curDistance	当前路线起点距离车的距离
 *  @return     当前所在位置位于路线详情中的下标
 *  @note
 */
- (NSInteger)getCurrentIndexInDescriptions:(NSInteger)curDistance;

/**
 *
 *  @brief      返回路线详情中路线说明的个数,区别于Segment（路段）个数。
 *  @return     路线说明的个数
 *  @note
 */
- (NSInteger)getDescriptionNumber;

/**
 *
 *  @brief      获取路线说明实例
 *  @param      index	指定要获取的第index个路线说明，包含途经点
 *  @param      curDistance	但前车所在路线上的位置，若不用此参数，则设置为NO_USE_CURRENT_DISTANCE
 *  @return     路线说明实例，如果存在则返回RouteDescriptionItem类型实例，如果不存在，返回nil
 *  @note
 */
- (MBRouteDescriptionItem*)getDescriptionItem:(NSInteger)index curDistance:(NSInteger)curDistance;

/**
 *
 *  @brief      获取当前路线共有多少个Segment路段
 *  @return     路线上Segment的个数
 *  @note
 */
- (NSInteger) getSegmentNumber;



/**
 *  @brief 比较是否同一条路径
 *  @return 是否相同
 *  @note
 */

- (BOOL)isEqualRouteBase:(MBRouteBase *)route;

/**
 *
 *  @brief      获取Segment的形状点
 *  @param      index	Segment索引
                num[out] 返回MBPoint的个数
 *  @return     返回点的数组
 *  @note       该方法使用完后需要客户端释放MBPoint的内存。
 */
-(MBPoint*)getSegmentFinePoints:(NSInteger)index withPointNum:(NSInteger*)num;
/**
 @brief 获取tmc柱状图
 @memberof RouteBase
 @param [in] maxPixelNum
 柱状图的长度(以像素为单位)，这个值也是pixels和states这两个数组的最大长度
 @param [out] pixels
 每个值表示一个区间，每个区间的起点是上一个区间的终点或0   [)
 e.g:
 pixels[1] = 10
 pixels[2] = 30
 则柱状图中第10个像素到第29个像素用state[2]的状态填充
 @param [out] states
 每个区间对应的tmc状态
 @return
 实际返回的区间个数
 */
- (NSInteger) getTmcSections:(NSInteger)maxSection pixels:(NSMutableArray *)pixels tmcStates:(NSMutableArray *)tmcStates;
/**
 *  获取描述路线的路况信息
 *
 *  @param index 描述路段索引
 *
 *  @return 描述路段对应TMC信息MBTmcSection的数组
 */
- (NSInteger)getDescriptionItemTmcSection:(NSInteger)index rates:(NSMutableArray*)rates tmcStates:(NSMutableArray*)tmcStates;
/**
 *  是否打开Tmc蚯蚓路,默认：false，不显示TMC信息。
 *
 *  @param enable YES打开，NO关闭。
 */
-(void) enableTmcColors:(BOOL)enable;
/**
 *  Tmc蚯蚓路状态
 *
 *  @return YES打开，NO关闭。
 */
-(BOOL) isTmcColorsEnabled;
/**
 *  判断当前路线是否支持TMC绘制,针对在线算路来说永远返回true，而针对离线情况，老数据会返回false，新数据会返回true
 *
 *  @return YES表示支持。
 */
-(BOOL) isTmcSupported;
/**
 *  更新Tmc。
 */
-(void)updateTmc;
/**
 *  获取TMC信息更新时间字符串
 *
 *  @return 时间字符串
 */
-(NSString*)getTmcTime;
/**
 *  获取路线上指定路段的路况信息
 *
 *  @param index 路段索引
 *
 *  @return Tmc状态
 */
-(MBTmcState)getSegmentTmc:(int)index;
/**
 *  获取实时路况(TMC)模式样式,默认：RouteBase.TmcStyle.normal
 */
@property(nonatomic,assign) MBRouteTmcStyle style;

/**
 * @brief  导出handle
 *
 */
-(void *) handle;
/**
 *@brief  获取转向箭头数据
 *
 *
 */
-(RouteArrowData*) getArrowPointsByIndex:(NSInteger)index;
/**
 @brief 返回TMC重算路的原因
 @memberof RouteBase
 @param [in] o
 指定的路线。
 */
-(MBRerouteReaseon)getRerouteReason;
@end

@interface MBDSegment : NSObject

@property (readonly) NSString* name;
@property (readonly) int pointNumber;
-(const MBPoint*) getShapePoints;
@end

@interface MBRouteEngine : NSObject
-(MBDSegment*) grabSegmentsByPoint:(MBPoint*)pos;
@end
