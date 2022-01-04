//
//  MBNaviSessionData.h
//  iNaviCore
//
//  Created by fanwei on 3/8/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"
#import "MBRouteBase.h"

@class MBCameraData;

/** @interface MBNaviSessionData
 *
 *  @brief 导航数据
 *
 */
@interface MBNaviSessionData : NSObject

/**
 *
 *  @brief      当前自车的位置，经纬度坐标。
 *  @note
 */
@property (assign,nonatomic)MBPoint carPos;

/** @property   carOri
 *
 *  @brief      当前车头所朝方向<br>
 *              当前自车的行驶方向，单位：度。正东为 0，逆时针方向为正，即：正北为：90，正西为：180，正南为：270。<br>
 *              <font color="red">注意：当绘制小车时，图标使用的0度为正北方向，逆时针为正。</font> Current
 *              orientation of car
 *  @note
 */
@property (assign,nonatomic)NSInteger carOri;

/** @property   speed
 *
 *  @brief      车当前速度，类型为定点数，需要speed >> 7得到浮点值使用，单位：米/秒<br>
 *              Current speed of car.[type = fixpt]
 *  @note
 */
@property (assign,nonatomic)NSInteger speed;

/** @property   roadName
 *
 *  @brief      当前道路名<br>
 *              Current street name [length = 64]
 *  @note
 */
@property (retain,nonatomic)NSString* roadName;

/** @property   drifting
 *
 *  @brief      有路线时，表示是否已经偏离路线。无路线时，表示是否成功抓在路段上。
 *  @note
 */
@property (assign,nonatomic)BOOL drifting;

/** @property   drifting
 *
 *  @brief      当前是否在 GPS 信号推演中。
 *  @note
 */
@property(nonatomic,assign) BOOL gpsPredicting;

/** @property   routeLength
 *
 *  @brief      当前路线的长度，单位：米<br>
 *              如果没有路线，那么此值为0 Total length of the route [unit: meter] is zero if no route
 *  @note
 */
@property (assign,nonatomic)NSInteger routeLength;

/** @property   travelledDistance
 *
 *  @brief      在当前路上已经走过的距离，单位：米<br>
 *              Distance has traveled in current route [unit: meter] is zero if no route
 *  @note
 */
@property (assign,nonatomic)NSInteger travelledDistance;

/** @property   remainingTime
 *
 *  @brief      提示路线剩余时间，单位：秒<br>
 *              Time remaining [unit: second]
 *  @note
 */
@property (assign,nonatomic)NSInteger remainingTime;

/** @property   turnIcon
 *
 *  @brief      当前转向标ID Icon ID of current turning[type = TNaviTurnIconID]
 *              {@link RouteDescriptionItem.TurnIconID}.
 *  @see RouteDescriptionItem.TurnIconID
 *  @note
 */
@property (assign,nonatomic)NSInteger turnIcon;

/** @property   turnIconProgress
 *
 *  @brief      当前转向标转弯的进度，取值范围是 [0, 1 << FIXPT_SHIFT]，可用于显示注水罐的水位或进度条的进度<br>
 *              The progress of current turning, range [0, 1 << FIXPT_SHIFT(128)] [type = fixpt]
 *  @note
 */
@property (assign,nonatomic)NSInteger turnIconProgress;
/** @property   turnIconDistance
 *
 *  @brief      显示在转向标上的距离值，单位：米。与 distanceToTurn 的区别是，转过弯后在转向图标变化前会保持为0
 *  @note
 */
@property (assign,nonatomic)NSInteger turnIconDistance;
/** @property   turnDistanceStr
 *
 *  @brief      显示在转向标上的距离文本，字符串。
 *  @note
 */
@property (retain,nonatomic)NSString* turnDistanceStr;

/** @property   suggestedMapScale
 *
 *  @brief      建议的地图显示比例尺
 *  @note
 */
@property (assign,nonatomic)NSInteger suggestedMapScale;
/** @property   hasTurn
 *
 *  @brief      是否有下一个转弯<br> Whether has the next turning
 *  @note       当 m_hasTurn 为 TRUE 时，表示下一个转弯点距离不太远。此时 turnIconDistance, curManeuverLength, distanceToTurn, nextRoadName 这些字段的取值有意义。
                当 m_hasTurn 为 FALSE 时，表示下一个转弯点距离很远。此时 turnIconDistance, curManeuverLength, distanceToTurn 取值为 INT_MAX；nextRoadName 为空字符串。
 */
@property (assign,nonatomic)BOOL hasTurn;
/** @property   curManeuverLength
 *
 *  @brief      从上一个转弯点(或者路线起点)到下一个转弯点的距离，单位：米<br>
 *              Distance between previous turning (or the start point) and next turning [unit: meter]
 *  @note
 */
@property (assign,nonatomic)NSInteger curManeuverLength;

/** @property   distanceToTurn
 *
 *  @brief      从当前位置到下一个转弯点的距离，单位：米<br>
 *              Distance between current point and next turning [unit: meter]
 *  @note
 */
@property (assign,nonatomic)NSInteger distanceToTurn;
/** @property   nextRoadName
 *
 *  @brief      转弯之后的道路名称 The road name after next turning.[length = 64]
 *  @note
 */
@property (retain,nonatomic)NSString* nextRoadName;

/** @property   shouldDisplayExpandView
 *
 *  @brief      是否应该显示路口放大图
 *  @note
 */
@property (assign,nonatomic) BOOL shouldDisplayExpandView;

/** @property   shouldDisplayExpandViewButton
 *
 *  @brief      是否应该显示“显示路口放大图”的按钮(TRUE 表示现在有路口放大图可以显示，但是被用户隐藏了)
 *  @note
 */
@property (assign,nonatomic) BOOL shouldDisplayExpandViewButton;

/** @property   highwayGuideNum
 *
 *  @brief      高速模式路牌数量
 *  @note
 */
@property (assign,nonatomic) NSInteger highwayGuideNum;

/** @property   highwayGuideItem
 *
 *  @brief      高速模式路牌
 *  @note
 */
@property (retain,nonatomic) NSMutableArray *highwayGuideItems;

/** @property   cameraNum
 *
 *  @brief      摄像头数量
 *  @note
 */
@property (assign,nonatomic) NSInteger cameraNum;

/** @property   cameras
 *
 *  @brief      摄像头
 *  @note
 */
@property (retain,nonatomic) NSMutableArray* cameras;
/** @property   firstCamera
 *
 *  @brief      当前位置最近的摄像头
 *  @note
 */
@property (retain,nonatomic) MBCameraData *firstCamera;
@end
