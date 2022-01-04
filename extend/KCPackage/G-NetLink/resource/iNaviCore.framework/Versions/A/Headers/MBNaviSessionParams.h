//
//  MBNaviSessionParams.h
//  iNaviCore
//
//  Created by fanwei on 3/6/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"

/** @interface MBNaviSessionParams
 *
 *  @brief 始始化导航的基本参数信息
 *
 */
@interface MBNaviSessionParams : NSObject

/**
 *
 *  @brief      初始化
 *  @return     self
 *  @note
 */
- (id) init;

/** @property   modules
 *
 *  @brief  需要使用的子模块
 *  @note
 */
@property (nonatomic,assign) MBNaviMode modules;

/** @property   autoTakeRoute
 *
 *  @brief  算路完成后是否自动采纳路线结果用于导航.<br>只涉及于单条路段结果的算路和偏航重计算。<br>对于多条路线结果，必须手动调用 {@link NaviSession#takeRoute(RouteBase)}来采纳路线
 *  @note
 */
@property (nonatomic,assign) BOOL autoTakeRoute;

/** @property   autoReroute
 *
 *  @brief  偏航后是否自动重计算
 *  @note
 */
@property (nonatomic,assign) BOOL autoReroute;

/** @property   autoRemoveRoute
 *
 *  @brief  到达目的地后是否自动删除路线
 *  @note   when destination is arrived, automatically remove the route
 */
@property (nonatomic,assign) BOOL autoRemoveRoute;

/** @property   allowManeualStartMode
 *
 *  @brief  是否允许出现手动起点状态
 *  @note   allow entering of manual start mode
 */
@property (nonatomic,assign) BOOL allowManeualStartMode;
/**	@brief 是否允许在隧道中丢星后对 GPS 信号进行推演。
 @details 缺省值为 FALSE。
 如果允许在隧道中丢星后对 GPS 信号进行推演，则客户端需要注意将 GPS 推演状态也作为 GPS 定位状态处理，尽管此时
 Gps_getDeviceState() 不是 GpsDeviceState_ok 或者 GpsInfo::m_valid 为 FALSE。
 例如，可以用 NaviSession_isPositionFixed() 判断当前是否是定位状态。
 */
@property (nonatomic,assign) BOOL allowTunnelGpsPredicting;
///< 是否启用TMC重算路的特性
@property (nonatomic,assign) BOOL allowTmcReroute;
/** @property   expandViewWidth
 *
 *  @brief  路口放大图显示区的宽度
 *  @note
 */
@property (nonatomic,assign) NSInteger expandViewWidth;

/** @property   expandViewHeight
 *
 *  @brief  路口放大图显示区的高度
 *  @note
 */
@property (nonatomic,assign) NSInteger expandViewHeight;

/** @property   expandViewSmallFontSize
 *
 *  @brief  路口放大图使用的小号字体
 *  @note
 */
@property (nonatomic,assign) NSInteger expandViewSmallFontSize;

/** @property   expandViewBigFontSize
 *
 *  @brief  路口放大图使用的大号字体
 *  @note
 */
@property (nonatomic,assign) NSInteger expandViewBigFontSize;

/** @property   expandViewSuperDigitFont
 *
 *  @brief  路口放大图使用的显示数字的超大字体 需要使用Clearview字体
 *  @note   http://en.wikipedia.org/wiki/Clearview_(typeface)
 */
@property (nonatomic,assign) NSInteger expandViewSuperDigitFont;

/** @property   voiceFeedback
 *
 *  @brief  是否自动播报某些语音。<br>包括：
 *          <br>1. 到达目的地后：“到达目的地”{@link NaviSession.Event#destArrived}<br>
 *          2. 偏航重计算的路线被采纳后：“航线更正完毕”{@link NaviSession.Event#rerouteComplete}<br>
 *          3. GPS第一次定位后：“卫星已连接”，“您当前在某某市某某区某某路”{@link NaviSession.GPSEvent#connected}<br>
 *          4. GPS信号丢失后：“卫星信号丢失”{@link NaviSession.GPSEvent#disconnected}<br>
 *          5. 模拟导航开始时：“模拟导航开始”{@link NaviSession.Event#simNaviBegin}<br>
 *          6. 模拟导航结束时：“模拟导航结束”{@link NaviSession.Event#simNaviEnd}
 *  @note
 */
@property (nonatomic,assign) BOOL voiceFeedback;
/**
 @brief
 是否播报GPS相关语音，一下为GPS相关语音播报：
 1. GPS第一次定位后：“卫星已连接”，“您当前在某某市某某区某某路”。
 2. GPS信号丢失后：“卫星信号丢失”。
 如果设置为TRUE且voiceFeedback也为TRUE表示使用此语音，如果设置为FALSE或者voiceFeedback为FALSE，表示不需要引擎播报此语音。
 默认值：TRUE
 */
@property (nonatomic,assign) BOOL needGpsVoiceFeedback;

/** @property   useNaviCoreGPS
 *
 *  @brief  是否使用JNaviCore内部的GPS定位<br>
 *          如果为false，那么将不使用JNaviCore内部实现的的GPS定位<br>
 *          此时需要客户端手动调用{@link NaviSession#locationChanged(android.location.Location)}
 *          方法 如果为true，则不需要客户端实现GPS定位功能
 *  @note   默认值：false
 */
@property (nonatomic,assign) BOOL useNaviCoreGPS;

/** @property   useNaviCoreNet
 *
 *  @brief  是否使用JNaviCore内部实现的联网功能<br>
 *          默认为不使用，即，使用net包提供的联网功能<br>
 *          一般在测试是开启此选项，应用中应该使用默认 默认值: false
 *  @note
 */
@property (nonatomic,assign) BOOL useNaviCoreNet;

/** @property   debugGPSMode
 *
 *  @brief  是否开启GPS调试模式<br>
 *          {@link NaviSession.GPSDebugMode#none} -- 表示不开启<br>
 *          {@link NaviSession.GPSDebugMode#useNaviCoreDebugger} -- 开启导航引擎的GPS调试支持<br>
 *          {@link NaviSession.GPSDebugMode#useAndroidMockLocationDebugger} -- 开启本地GPS调试支持，此支持需要{@link Settings#Secure#ALLOW_MOCK_LOCATION}权限否则抛出异常<br>
 *          如果开启，将使用{@link NaviSession#GPSDebuggerLoad(String)}等一系列函数操作gps_log文件实现灵活调试<br>
 *          <font color="red">注意: GPS所使用的Log形式分为两种，Info模式log和NMEA模式log，以后缀名区分，NMEA格式的log使用.txt或.nmea结尾，Info模式的log使用.info结尾。</font>
 *          默认值为{@link NaviSession.GPSDebugMode#none}<br>
 *
 *  @see NaviSession.GPSDebugMode
 *  @see NaviSession#GPSDebuggerLoad(String)
 *  @note
 */
@property (nonatomic,assign) BOOL debugGPSMode;
///< 高速行程的显示模式
@property (nonatomic,assign) MBHighwayGuideMode highwayGuideMode;
/**	@brief 是否允许使用 OBD 信息在丢星时对 GPS 信号进行推演
 @details 缺省值为 FALSE。
 如果允许使用 OBD 信息在丢星时对 GPS 信号进行推演，则客户端需要注意：
 
 * GPS 信号推演状态下(NaviSessionData::m_gpsPredicting 为 TRUE 时)，自车不一定在隧道中。
 
 @note allowObdGpsPredicting 为 TRUE 时，将忽略 allowTunnelGpsPredicting 字段。
 */
@property (nonatomic,assign) BOOL allowObdGpsPredicting;
@end
