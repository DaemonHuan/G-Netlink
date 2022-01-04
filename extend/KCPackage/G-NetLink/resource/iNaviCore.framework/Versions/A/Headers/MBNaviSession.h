//
//  MBNaviSession.h
//  iNaviCore
//
//  Created by fanwei on 2/21/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"
#import "MBRoutePlan.h"
#import "MBRouteBase.h"
#import "MBNaviSessionParams.h"
#import "MBRouteCollection.h"
#import "MBNaviSessionData.h"

#import "MBTmcReporter.h"


@class MBNaviLaneCollection;


/** @protocol MBNaviSessionDelegate
 *
 *  @brief 导航回调函数
 *
 */
@protocol MBNaviSessionDelegate <NSObject>
@optional
/**
 *
 *  @brief 开始算路
 *  @note
 */
- (void) naviSessionRouteStarted;

/**
 *
 *  @brief 开始偏航重计算
 *  @note
 */
- (void) naviSessionRerouteStarted;

/** 
 *
 *  @brief 路线计算，完成
 *  @note
 */
- (void) naviSessionResult:(MBRouteCollection*)routes;

/**
 *
 *  @brief 偏航重新计算，完成
 *  @note
 */
- (void) naviSessionRerouteComplete:(MBRouteBase *)base;

/**
 *
 *  @brief 算路失败
 *  @note
 */
- (void) naviSessionRouteFailed:(MBTRouterError)errCode moreDetails:(NSString*)details;
/**
 *
 *  @brief 重算路失败
 *  @note
 */
- (void) naviSessionRerouteFailed;
/**
 *
 *  @brief 到达终点
 *  @note
 */
- (void) naviSessionDestArrived;

/**
 *
 *  @brief 导航开始后回调数据包
 *  @note
 */
- (void) naviSessionTracking:(MBNaviSessionData*)sData;

/**
 *
 *  @brief 路线计算中
 *  @note
 */
- (void) naviSessionRouting;

/**
 *
 *  @brief 路线计算被取消
 *  @note
 */
- (void) naviSessionRouteCancelled;

/**
 *
 *  @brief 偏航重计算被取消
 *  @note
 */
- (void) naviSessionRerouteCancelled;

/**
 *
 *  @brief 进入手动起点状态
 *  @note
 */
- (void) naviSessionManualStartStateBegin;

/**
 *
 *  @brief 离开手动起点状态
 *  @note
 */
- (void) naviSessionManualStartStateEnd;

/**
 *
 *  @brief 新路线已被采纳为当前路线
 *  @note
 startRealtimeNavi
 */
- (void) naviSessionNewRouteTaken;

/**
 *
 *  @brief 需要进行偏航重计算。在真实导航中，如果在偏航状态保持2秒，则会收到此事件
 *  @note
 */
- (void) naviSessionNeedsReroute;

/**
 *
 *  @brief 模拟导航开始
 *  @note
 */
- (void) naviSessionSimNaviBegin;

/**
 *
 *  @brief 模拟导航结束
 *  @note
 */
- (void) naviSessionSimNaviEnd;
/**
 *  根据TMC发现一条比当前路线更优的路线。客户端应该在回调内决定是否take这个RouteBase对象,回调结束后这个指针会被回收。
 *
 *  @param base 一条路线。
 */
- (void) naviSessionNewTmcRoute:(MBRouteBase*)base;
/**
 *  当前有新的转弯箭头需要显示。
 *
 *  @param arrowShapes 表示箭头的点数组
 */
- (void) naviSessionNewArrow:(NSArray*)arrowShapes;
/**
 *  当有转弯箭头需要删除时出发回调
 */
- (void) naviSessionDeleteArrow;
/**
 *  路线上的TMC信息更新，获取该回调需要设置 MBTmcOptions 属性
 *
 *  @param base 一条路线
 */
- (void) naviSessionRouteTmcUpdated:(MBRouteBase*)base;
/**
 *  检测到TMC播报事件
 *
 *  @param tmcItems 返回MBTmcReportItem数组
 */
- (void) naviSessionTmcReportItemsDetected:(NSArray*)tmcItems;
/**
 *  进行了一次tmc的播报。
 *
 *  @param tmcItem MBTmcReportItem
 */
- (void) naviSessionTmcReportItemReported:(MBTmcReportItem*) tmcItem;
/**
 *  有新的车道信息可以显示。
 *
 *  @param collection 参数是一个 MBNaviLaneCollection
 */
- (void) naviSessionNewNaviLaneCollection:(MBNaviLaneCollection*)collection;
/**
 *  当前车道信息不再应该显示。
 */
- (void) naviSessionDeleteNaviLaneCollection;
- (void) naviSessionCameraAuthFailed:(id)notYet;//未实现。
@end





/** @interface MBNaviSession
 *
 *  @brief 导航API
 *
 */
@interface MBNaviSession : NSObject
@property(nonatomic,readonly) MBSdkAuthError authErrorType;
/**
 * 是否为VIP摄像头数据
 */
@property(nonatomic,readonly) BOOL isVipCameraData;

/**
 *  设置蚯蚓路tmc状态获取接口的url,默认值："http://search.api.mapbar.com/tmc/getTmc.jsp"
 */
@property(nonatomic,retain) NSString* tmcUrlBase;
/**
 * 是否启用摄像头播报
 */
@property(nonatomic,assign) BOOL enableCamera;

/**
 *
 *  @brief  获取导航的单例对象
 *  @return MBNaviSession 对象
 *  @note
 */
+(MBNaviSession *)sharedInstance;

/** @property   delegate
 *
 *  @brief  导航代理
 *  @note
 */
@property(nonatomic, assign) id<MBNaviSessionDelegate> delegate;

/**
 *
 *  @brief  打开/关闭某个/某些子模块 [子模块管理]
 *  @param  module  子模块
 *  @param  enable  是否开启
 *  @return 空
 *  @see    isModuleEnabled:
 *  @note   
 */
- (void)enableModule:(MBNaviSessionModule)module enable:(BOOL)enable;

/**
 *
 *  @brief  判断指定的子模块是否已打开 [子模块管理]
 *  @param  module  子模块
 *  @return enable  是否开启
 *  @see    enableModule:enable:
 *  @note
 */
- (BOOL)isModuleEnabled:(MBNaviSessionModule)module;

/**
 *
 *  @brief  设置导航模式：在线/离线/自动 [路线规划]
 *  @param  mode  在线/离线/自动
 *  @return 空
 *  @see    getNaviMode:
 *  @note
 */
- (void)setNaviMode:(MBNaviMode)mode;

/**
 *
 *  @brief  获取当前的导航模式：在线/离线/自动 [路线规划]
 *  @return  mode  在线/离线/自动
 *  @see    setNaviMode:
 *  @note
 */
- (MBNaviMode)getNaviMode;

/**
 *
 *  @brief  使用指定的路线计划开始算路 [路线规划]
 *  @param  newPlan     指定的路线计划
 *  @param  method      算路方法：是只算一条路，是用多种规则计算多条路，还是用一种规则算多条路。
 *  @return 空
 *  @see    cancelRouting:
 *  @note   算路开始后，典型地，调用者会收到以下事件：1条 NaviSessionEvent_routeStarted 若干条 NaviSessionEvent_routing 1条 NaviSessionEvent_routeComplete 或 NaviSessionEvent_routeFailed 或 NaviSessionEvent_routeCancelled
 */
- (void)startRoute:(const MBRoutePlan *)newPlan routeMethod:(MBNaviSessionRouteMethod)method;

/**
 *
 *  @brief  使用指定的路线规则开始算路,返回1~3条结果 [路线规划]
 *  @param  newPlan     指定的路线计划
 *  @param  type        用“系统推荐”、“距离优先”、“高速优先”、“避让收费”的一种规则算多条路。
 *  @return 空
 *  @note   算路开始后，典型地，调用者会收到以下事件：1条 NaviSessionEvent_routeStarted 若干条 NaviSessionEvent_routing 1条 NaviSessionEvent_routeComplete 或 NaviSessionEvent_routeFailed 或 NaviSessionEvent_routeCancelled
 */
-(void)startRoute:(const MBRoutePlan*)newPlan avoidRoadType:(MBRouteRule)type;

/**
 *
 *  @brief  取消正在进行的路线规划计算 [路线规划]
 *  @return 空
 *  @see    startRoute:routeMethod:
 *  @note
 */
- (void)cancelRouting;

/**
 *
 *  @brief  获取当前路线 [路线规划]
 *  @return RouteBase
 *  @note
 */
- (MBRouteBase *)getRoute;

/**
 *
 *  @brief  获取当前的路线计划(只读)线 [路线规划]
 *  @return RoutePlan
 *  @note
 */
- (MBRoutePlan*)getPlan;

/**
 *
 *  @brief  采纳指定的路线，将其设为当前路线，用于导航和模拟导航 [路线规划]
 *  @param  RouteBase   路线的基本信息
 *  @return 空
 *  @note   
 */
- (void)takeRoute:(MBRouteBase*)route;

/**
 *
 *  @brief  删除当前路线，以及路线计划文件 [路线规划]，也就是停止导航。对应takeRoute方法。
 *  @return 空
 *  @note
 */
- (void)removeRoute;

/**
 *
 *  @brief  当前是否正在算路中 [路线规划]
 *  @return 空
 *  @note
 */
-(BOOL)isRouting;

/**
 *
 *  @brief  获取算路步数计数器的值 [路线规划]
 *  @return 算路步数计数器的值
 *  @note
 */
- (NSInteger)getStepCounter;

/**
 *
 *  @brief  是否有上次运行留下来的路线计划文件可用于恢复导航 [路线规划]
 *  @return BOOL
 *  @note   如果不为 NULL，则函数返回 TRUE 时返回路线计划文件中的路线计划
 */
- (BOOL)canResumeNavigation:(MBRoutePlan*)plan;

/**
 *
 *  @brief  使用上次运行留下来的路线计划文件恢复导航 [路线规划]
 *  @return 空
 *  @note
 */
- (void)resumeNavigation;


/**
 *
 *  @brief  获取算路异常时错误信息 [路线规划]
 *  @return 返回当前算路错误的信息字串
 *  @note   
 */
-(NSString *)getErrorStr;

/**
 *
 *  @brief  用于获取导航实时数据 [路线规划]
 *  @return NaviSessionData 导航实时数据对象
 *  @note   一般情况下，在回调函数中的tracking事件会返回{@link NaviSessionData}对象<br>此对象即表示当前实时导航信息，不需要手动调用此方法获取实时信息
 */
-(id)getNaviData;

/**
 *
 *  @brief  开始模拟导航 [模拟导航]
 *  @return 空
 *  @note
 */
-(void)startSimulation;

/**
 *
 *  @brief  用指定的 RoutePlan 启动实景模拟功能 [模拟导航]
 *  @param  plan 指定的路线计划
 *  @return 空
 *  @note   会暂时强制启用路口放大图功能
 */
-(void)startSimulationWithPlan:(MBRoutePlan*)plan;

/**
 *
 *  @brief  终止模拟导航 [模拟导航]
 *  @return 空
 *  @note
 */
-(void)endSimulation;

/**
 *
 *  @brief  是否在模拟导航状态 [模拟导航]
 *  @return 如果处于模拟导航模式中返回YES，否则返回NO
 *  @note   模拟导航暂停时，仍然在模拟导航状态
 */
-(BOOL)isInSimulation;

/**
 *
 *  @brief  暂停模拟导航 [模拟导航]
 *  @return 空
 *  @note
 */
-(void)pauseSimulation;

/**
 *
 *  @brief  恢复模拟导航 [模拟导航]
 *  @return 空
 *  @note
 */
-(void)resumeSimulation;

/**
 *
 *  @brief  是否在模拟导航暂停状态 [模拟导航]
 *  @return 是否当前已经暂停了模拟导航状态，已经暂停返回YES，否则返回NO
 *  @note
 */
-(BOOL)isSimulationPaused;

/**
 *
 *  @brief  设置模拟导航的速度倍数 [模拟导航]
 *  @param  speed 当前的速度等级(相对于基础速度的百分比) 1.0,2.0 ...
 *  @return 空
 *  @note
 */
-(void)setSimulationSpeed:(float)speed;

/**
 *
 *  @brief  获取模拟导航的速度倍数 [模拟导航]
 *  @return 空
 *  @note
 */
-(float)getSimulationSpeed;

/**
 *
 *  @brief  设置模拟导航是否循环模拟 [模拟导航]
 *  @param  enable 设置为YES则表示循环模拟，设置为NO表示单次模拟
 *  @return 空
 *  @note
 */
-(void)enableRepeatSimulation:(BOOL)enable;

/**
 *
 *  @brief  模拟导航是否循环模拟 [模拟导航]
 *  @return 如果此时为循环模拟，返回YES，否则返回NO
 *  @note
 */
-(BOOL)isRepeatSimulationEnabled;

/**
 *
 *  @brief  设置模拟导航刷新的时间步长 [模拟导航]
 *  @param  milliseconds 设置模拟导航刷新的间隔时间，单位为毫秒(ms)
 *  @return 空
 *  @note
 */
-(void)setSimulationInterval:(NSInteger)milliseconds;

/**
 *
 *  @brief  用于在地图上呈现当前算的路线 [Route overview]
 *  @return 空
 *  @note
 */
-(void)startRouteOverview;

/**
 *
 *  @brief  用于结束道路的地图呈现 [Route overview]
 *  @return 空
 *  @note
 */
-(void)endRouteOverview;

/**
 *
 *  @brief  暂停真实导航 [Pause and resume]
 *  @return 空
 *  @note   此函数使用了引用计数。注意要保证与 NaviSession_resumeNavi() 成对使用
 */
-(void)pauseNavi;

/**
 *
 *  @brief  恢复真实导航 [Pause and resume]
 *  @return 空
 *  @note   
 */
-(void)resumeNavi;

/**
 *
 *  @brief  真实导航是否已暂停 [Pause and resume]
 *  @return 空
 *  @note
 */
-(BOOL)isNaviPaused;

/**
 *
 *  @brief  判断当前是否为手动起点状态 [手动起点状态]
 *  @return 如果当前处于手动起点状态返回YES，否则返回NO
 *  @note   所谓“手动起点状态”。就是说不采用GPS定位点为起点，而是手动设置的起点。此时虽然偏航，但是并不会引起重新计算
 */
-(BOOL)isInManualStartState;

/**
 *
 *  @brief  结束手动起点状态 [手动起点状态]
 *  @return 空
 *  @note   
 */
-(void)endManualStartState;
/**
 * 更新导航数据
 */
-(void)updateSessionTracking;
/**
 *
 *  @brief  设置白天黑夜模式 [Misc]
 *  @param  如果为YES表示进入夜晚状态，如果为NO进入白天状态
 *  @return 空
 *  @note
 */
-(void)setNightMode:(BOOL)night;

/**
 *
 *  @brief  获取当前的白天黑夜模式 [Misc]
 *  @return 如果当前为夜晚模式则返回YES，否则返回NO
 *  @note
 */
-(BOOL)getNightMode;

/**
 *
 *  @brief  测试根据给定的坐标和方向是否能抓路 [Misc]
 *  @param  pos 给定的坐标点
 *  @param  ori 给定的方向
 *  @return 如果能成功抓路则返回YES，否则返回NO
 *  @note
 */
-(BOOL)tryGrabSegments:(MBPoint*)pos ori:(short)ori;

/**
 *
 *  @brief  设置在线算路服务器URL
 *  @param  urlBase 服务器URL地址
 *  @return 空
 *  @note
 */
-(void)setRouteUrlBase:(NSString *)urlBase;

/**
 *
 *  @brief 设置语音播报模式
 *  @param [in] mode 要设置的语音播报模式：简介、标准、安全。
 *  @return 空
 *  @note
 */
-(void)setGuidanceMode:(MBGuidanceMode)mode;

/**
 *
 *  @brief 设置电子眼播报模式
 *  @param mode 要设置的电子眼播报模式：简单、标准、全部。
 *  @return 空
 *  @note
 */
- (void)setCameraMode:(MBCamerFilterMode)mode;

@property(nonatomic,assign)MBHighwayGuideMode highwayGuidemode;
/**
 *
 *  @brief 设置“导航开始语音模式”，“导航开始语音模式”的设置会影响导航开始以及模拟导航开始时的语音播报内容。缺省值为 MBNaviSessionNaviStartVoiceMode_pnd
 */
@property(nonatomic,assign)MBNaviSessionNaviStartVoiceMode naviStartVoiceMode;

/**
 *  近期导航得到的路线
 */
@property (nonatomic, retain) MBRouteCollection *routes;

/**
 *  近期导航得到的数据
 */
@property (nonatomic, retain) MBNaviSessionData *sessionData;

/**
 *  关闭离线电子眼
 */
-(void)disableOfflineCameraData;
/**
 *  获取电子眼数据的授权验证结果
 *
 *  @return 授权结果，参见MBAuthError
 */
-(MBAuthError)getCameraAuthError;
/**
 *  初始化引擎后，判断当前已经加载的电子眼数据状态
 *
 *  @return 电子眼数据状态,MBCameraDataState
 */
- (MBCameraDataState)getCameraDataState;
/**
 *  获取TMC相关选项
 *
 *  @return MBTmcOptions
 */
@property (nonatomic,assign) MBTmcOptions tmcOptions;
/**
 *  判断当前引擎是否处在定位状态
 *
 *  @return YES即定位
 */
-(BOOL)isPositionFixed;
/**
 *  开启/关闭各种播报语音
 *
 *  @param enabled YES表示开启。
 */
@property (nonatomic,assign) BOOL enableSound;
/**
 *  主动发起一次TMC更新、TMC重算路的请求，需要相应的MBTmcOptions.enableTmcReroute设置为true才生效
 *
 *  @param request MBTmcRequest
 */
-(void)requestTmcUpdate:(MBTmcRequest)request;
/**
 *  设置防调头模式
 *
 *  @param mode MBAvoidUTurnMode
 */
-(void)setAvoidUTurnMode:(MBAvoidUTurnMode)mode;
/**
 *  设置偏航重计算的结果是否倾向于与原有路线相似 此接口的需求来自这样的应用场景：
 用户在“单规则多结果”算路方式下选择了非第一条路线作为当前路线进行导航，
 但在起点附近很快就发生了偏航重计算，此时用户希望重计算的结果仍然是之前选择的路线。
 此接口设置为 true后可能带来的副作用是重计算结果立刻要掉头的概率会更大一些。
 *
 *  @param prefer YES表示尽可能相似。
 */
-(void)setReroutePreferExisting:(BOOL)prefer;
@end
