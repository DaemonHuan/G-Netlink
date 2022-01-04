//
//  MBNaviCoreTypes.h
//  Navigation
//
//  Created by delon on 12-12-27.
//
//

#ifndef NAVICORE_TYPES_H
#define NAVICORE_TYPES_H

#import <Foundation/Foundation.h>

#define NAVICORE_ERROR_DOMAIN @"com.mapbar.iosnav"

//用于poi查询
#define NAVICORE_ERROR_POIQUERY_NONE 0x00ff0000
#define NAVICORE_ERROR_POIQUERY_CANCELED 0x00ff0001
#define NAVICORE_ERROR_POIQUERY_NO_RESULT 0x00ff0002
#define NAVICORE_ERROR_POIQUERY_NO_DATA 0x00ff0003
#define NAVICORE_ERROR_POIQUERY_NOT_SUPPORT 0x00ff0004
#define NAVICORE_ERROR_POIQUERY_NET_ERROR 0x00ff0005

#ifdef NAVICORE_USED

typedef struct cqPoint MBPoint;
typedef struct cqRect MBRect;

#else

typedef struct MBPoint
{
    NSInteger x;
    NSInteger y;
} MBPoint;

typedef struct MBRect
{
    NSInteger left;
    NSInteger top;
    NSInteger right;
    NSInteger bottom;
} MBRect;

#endif

/**
 *
 *  @brief  表示日期时间的结构体
 *  @note
 */
typedef struct MBDateTime
{
    /**
     *  @brief 小时
     */
    NSInteger   m_hours;
    
    /**
     *  @brief 分钟
     */
    NSInteger 	m_minutes;
    
    /**
     *  @brief 秒钟
     */
    NSInteger 	m_seconds;
    
    /**
     *  @brief 年
     */
    NSInteger 	m_year;
    
    /**
     *  @brief 月
     */
    NSInteger 	m_month;
    
    /**
     *  @brief 日
     */
    NSInteger 	m_day;
    
} MBDateTime;

typedef enum MBSdkAuthError
{
	/* 无错误，SDK验证通过 */
	MBSdkAuthError_none = 0,
	/* 没有Key */
	MBSdkAuthError_keyIsMismatch = 201,
	/* 网络不可用，无法请求SDK验证 */
	MBSdkAuthError_netWorkIsUnavailable = 301,
	/* KEY已经过期 */
	MBSdkAuthError_expired = 302,
	/* KEY是无效值，已经被注销 */
	MBSdkAuthError_keyIsInvalid = 303,
	/* 模块没有权限 */
	MBSdkAuthError_noPermission = 304,
	/* SDK授权文件没有准备好 */
	MBSdkAuthError_licenseMissing = 305,
	/* 授权设备ID读取错误，也可能是授权设备的ID没有准备好 */
	MBSdkAuthError_deviceIdReaderError = 306,
	/* SDK授权文件读取错误 */
	MBSdkAuthError_licenseIoError = 307,
	/* SDK授权文件格式错误 */
	MBSdkAuthError_licenseFormatError = 308,
	/* 设备码不匹配 */
	MBSdkAuthError_licenseDeviceIdMismatch = 309,
	/* 其他错误，比如内存分配失败 */
	MBSdkAuthError_otherError = 400,
	/* 网络返回信息格式错误 */
	MBSdkAuthError_networkContentError = 401,
	/* KEY到达激活上线 */
	MBSdkAuthError_keyUpLimit = 402
} MBSdkAuthError;



typedef struct _MBPoint_Short {
    short               v;
    short               h;
}_MBPoint_Short;

/**
 *  引擎提供的模块支持，用以控制模块的开关
 */
typedef enum _MBNaviSessionModule
{
	MBNaviSessionModule_cameraWarning = 1,
	MBNaviSessionModule_expandView = 2,
	MBNaviSessionModule_arrowRenderer = 4,
	MBNaviSessionModule_highwayGuide = 8,
	MBNaviSessionModule_speedLimitWarning = 16,
	MBNaviSessionModule_adminSpeaker = 32,
	MBNaviSessionModule_all = 1 + 2 + 4 + 8 + 16 + 32
} _MBNaviSessionModule;
/**
 *  导航开始时的语音播报模式，分为详细模式和简洁模式
 */
typedef enum _MBNaviSessionNaviStartVoiceMode
{
	/** 详细模式 */
	MBNaviSessionNaviStartVoiceMode_detailed = 0,
	/** 简洁模式 */
	MBNaviSessionNaviStartVoiceMode_brief = 1,
	/**	PND 模式 */
	MBNaviSessionNaviStartVoiceMode_pnd = 2
} _MBNaviSessionNaviStartVoiceMode;
/**
 *  导航模式，主要控制算路的模式
 */
typedef enum _MBNaviMode
{
	MBNaviMode_offline = 0,
	MBNaviMode_online = 1,
	MBNaviMode_auto = 2
} _MBNaviMode;

typedef enum MBMapDataMode
{
    MBMapDataMode_online,
    MBMapDataMode_offline,
    MBMapDataMode_both
}MBMapDataMode;

typedef enum _MBTmcState
{
	MBTmcState_unknown = 0,
	MBTmcState_light   = 1,
	MBTmcState_medium  = 2,
	MBTmcState_heavy   = 3,
	MBTmcState_blocked = 4,
	MBTmcState_none    = 5
} _MBTmcState;



/**
 *  控制算路方式
 */
typedef enum _MBNaviSessionRouteMethod {
	MBNaviSessionRouteMethod_single,        ///< 算一条路
	MBNaviSessionRouteMethod_multipleRule,  ///< 用“系统推荐”、“距离优先”、“高速优先”、“避让收费” 4种规则算出4条路线结果(其中可能有相同结果)，此时路线计划(RoutePlan)中的算路规则字段会被忽略。
	MBNaviSessionRouteMethod_multipleResult ///< 用 RoutePlan 中的规则，尝试算多条路线结果(最终结果可能是1条~3条)
} _MBNaviSessionRouteMethod;
/**
 *  TMC播报失败对应的错误类型
 */
typedef enum _MBTmcReportError
{
	MBTmcReportError_none = 0,
	MBTmcReportError_netFailed = 1,		///< Õ¯¬Á ß∞‹µº÷¬tmc≤•±® ß∞‹
} _MBTmcReportError;
/**
 *  算路方式中的对规则
 */
typedef enum _MBRouteRule
{
	MBRouteRule_recommended,
	MBRouteRule_shortest,
	MBRouteRule_fastest,
	MBRouteRule_economic,
	MBRouteRule_walk,
	MBRouteRule_placeHolder = 0xffffffff
} _MBRouteRule;

typedef enum _MBRouteType
{
	MBRouteType_none = 0,
	MBRouteType_offline = 1, // 离线数据计算的路线
	MBRouteType_online = 2   // 在线数据计算的路线
} _MBRouteType;

typedef enum _MBErrorCode
{
    MBError_none = 0,
    MBError_incomplete = 1,
    MBError_noRoadAroundStartPoint = 2,
    MBError_noRoadAroundEndPoint = 3,
    MBError_noRoadAroundViaPoint = 4,
    MBError_startEndTooNear = 5,
    MBError_startViaTooNear = 6,
    MBError_endStartTooNear = 7,
    MBError_endViaTooNear = 8,
    MBError_viaStartTooNear = 9,
    MBError_viaEndTooNear = 10,
    MBError_viaViaTooNear = 11
}_MBErrorCode;


typedef enum _MBGPSDebugMode
{
    MBNone = 0,
    MBUseNaviCoreDebugger = 1
    
}_MBGPSDebugMode;
/**
 *  需要避让的道路类型
 */
typedef enum _MBAvoidRoadType
{
	/**
	 *  空
	 */
	MBAvoidRoadType_none = 0x00,
	/**
	 *  避让高速和快速路
	 */
	MBAvoidRoadType_highway = 0x01,
	/**
	 *  避让收费路段
	 */
	MBAvoidRoadType_toll = 0x02,
	/**
	 *   避让轮渡
	 */
	MBAvoidRoadType_sailingRoute = 0x04,
	/**
	 *  最大值标识，仅作限制使用，实际不应调用
	 */
	MBAvoidRoadType_max = 0xffffffff
}_MBAvoidRoadType;
/**
 *  初始化引擎后，已加载的电子眼数据状态
 */
typedef enum _MBCameraDataState
{
	//电子眼数据加载失败，或未开启电子眼模块
	MBCameraDataState_none = 0,
	//已经加载的电子眼数据为VIP数据
	MBCameraDataState_vip = 1,
	//已经加载的电子眼数据为普通版数据
	MBCameraDataState_normal = 2
} _MBCameraDataState;
/**
 *  防止掉头设置
 */
typedef enum _MBAvoidUTurnMode
{
    //不防调头
	MBAvoidUTurnMode_disable = 0,
    //偏航多次后自动防掉头
	MBAvoidUTurnMode_auto,
    //一直防掉头(测试用，客户端一般不使用此值)
	MBAvoidUTurnMode_always,
}_MBAvoidUTurnMode;
/**
 *  Guidance的播报模式
 */
typedef enum _MBGuidanceMode
{
	MBGuidanceMode_concise = 0,
	MBGuidanceMode_standard,
	MBGuidanceMode_safe
}_MBGuidanceMode;

typedef enum _MBCamerFilterMode{
    MBCamerFilterMode_simple = 0,
    MBCamerFilterMode_standard,
    MBCamerFilterMode_all
}_MBCamerFilterMode;

typedef enum _MBGpsDeviceState
{
	MBGpsDeviceState_off,
	MBGpsDeviceState_connecting,
	MBGpsDeviceState_ok
} _MBGpsDeviceState;

typedef enum _MBPoiQueryMode {
	MBPoiQueryMode_online,
	MBPoiQueryMode_offline
} _MBPoiQueryMode;

typedef enum _MBKeywordClass{
	MBKeywordClass_normal,
	MBKeywordClass_nearby
} _MBKeywordClass;

typedef enum _MBTNaviTurnIconID {
	MBENTI_None = 0,
	MBENTI_Arrival,
	MBENTI_TurnAround,
	MBENTI_EnterMainRoute,
	MBENTI_EnterRotary,
	MBENTI_GoStraight,
	MBENTI_LeaveMainRoute,
	MBENTI_LeaveRotary,
	MBENTI_TurnLeft,
	MBENTI_TurnRight,
	MBENTI_TurnSlightlyLeft,	// 10
	MBENTI_TurnSlightlyRight,
	MBENTI_Rotary1,
	MBENTI_Rotary2,
	MBENTI_Rotary3,
	MBENTI_Rotary4,
	MBENTI_Rotary5,
	MBENTI_Rotary6,
	MBENTI_Rotary7,
	MBENTI_Rotary8,
	MBENTI_Rotary9,	// 20
	MBENTI_KeepLeft,
	MBENTI_KeepRight,
	MBENTI_TurnHardLeft,
	MBENTI_TurnHardRight,
	MBENTI_TurnLeftKeepLeft,
	MBENTI_TurnLeftKeepRight,
	MBENTI_TurnRightKeepLeft,
	MBENTI_TurnRightKeepRight,
	MBENTI_EnterTunnel,
	MBENTI_TakeFerry,
	MBENTI_Start,
	MBENTI_WayPoints1,
	MBENTI_WayPoints2,
	MBENTI_WayPoints3,
	MBENTI_IC,
	MBENTI_DR,
	MBENTI_Overpass,
	MBENTI_WindOverpass,
	MBENTI_Max
} _MBTNaviTurnIconID;

typedef enum MBSdkAuthType
{
	/* 地图包 */
	MBSdkAuthType_map = 1,
	/* 导航包 */
	MBSdkAuthType_poiquery = 1 << 1,
	/* 搜索包 */
	MBSdkAuthType_navi = 1 << 2,
	/* 公交包 */
	MBSdkAuthType_loc = 1 << 3,
	/* 定位包 */
	MBSdkAuthType_bus = 1 << 4
} MBSdkAuthType;

typedef enum MBCameraType
{
	// 请勿更改此顺序
	MBCameraType_none = 0,
	MBCameraType_speed = 1,							//< 限速摄像头
	MBCameraType_light = 2,							//< 红绿灯照相
	MBCameraType_roadCondition = 3,					//< 路况监控摄像头(deprecate)
	MBCameraType_radar = 4,							//< 雷达测速摄像头(deprecate)
	MBCameraType_onewayStreet = 5,					//< 单行线摄像头(deprecate)
	MBCameraType_bicycle = 6,							//< 非机动车道摄像头
	MBCameraType_highSpeed = 7,						//< 高速出入口摄像头(deprecate)
	MBCameraType_bus = 8,								//< 公交车道摄像头
	MBCameraType_turnForbidden = 9,					//< 禁止左右转摄像头(deprecate)
	MBCameraType_mobile = 10,							//< 移动式测速摄像头(deprecate)
	MBCameraType_redLight = 11,						//< 红绿灯照相(deprecate)
	MBCameraType_monitor = 12,						//< 电子监控
	MBCameraType_areaSpeedingBegin = 13,
	MBCameraType_areaSpeedingEnd = 14,
	MBCameraType_cameraMax = 50,						//< 摄像头标识
	MBCameraType_serviceArea = 51,					//< 服务区
	MBCameraType_toll = 52,							//< 收费站
	MBCameraType_tunnel = 53,							//< 隧道
	MBCameraType_trfcSign = 100,						//< 交通信号标识
	MBCameraType_sharpLeftCurve = 101,				//< 向左急弯路
	MBCameraType_sharpRightCurve = 102,				//< 向右急弯路
	MBCameraType_reverseCurve = 103,					//< 反向弯路(左)
	MBCameraType_windingRoad = 104,					//< 连续弯路
	MBCameraType_steepAscent = 105,					//< 上陡坡
	MBCameraType_steepDecent = 106,					//< 下陡坡
	MBCameraType_roadNarrowsFromBothSides = 107,		//< 两侧变窄
	MBCameraType_roadNarrowsFromTheRight = 108,		//< 右侧变窄
	MBCameraType_roadNarrowsFromTheLeft = 109,		//< 左侧变窄
	MBCameraType_narrowBridge = 110,					//< 窄桥
	MBCameraType_twowayTraffic = 111,					//< 双向交通
	MBCameraType_childrenCrossing = 112,				//< 注意儿童
	MBCameraType_cattleCrossing = 113,				//< 注意牲畜
	MBCameraType_fallingRocksOnTheLeft = 114,			//< 注意左落石
	MBCameraType_fallingRocksOnTheRight = 115,		//< 注意右落石
	MBCameraType_crosswinds = 116,					//< 注意横风
	MBCameraType_slipperyRoad = 117,					//< 易滑
	MBCameraType_hillsOnTheLeft = 118,				//< 左侧傍山险路
	MBCameraType_hillsOnTheRight = 119,				//< 右侧傍山险路
	MBCameraType_embankmentOnTheRight = 120,			//< 右侧堤坝路
	MBCameraType_embankmentOnTheLeft = 121,			//< 左侧堤坝路
	MBCameraType_village = 122,						//< 村庄
	MBCameraType_humpbackBridge = 123,				//< 驼峰桥
	MBCameraType_unevenRoadSurface = 124,				//< 路面不平
	MBCameraType_roadFloods = 125,					//< 过水路面
	MBCameraType_guardedRailroadCrossing = 126,		//< 有人看守铁路道口
	MBCameraType_unguardedRailroadCrossing = 127,		//< 无人看守铁路道口
	MBCameraType_highAccidentArea = 128,				//< 事故易发路段
	MBCameraType_passLeftOrRightOfObstacle = 129,		//< 左右绕行
	MBCameraType_passLeftOfObstacle = 130,			//< 左侧绕行
	MBCameraType_passRightOfObstacle = 131,			//< 右侧绕行
	MBCameraType_dangerAhead = 132,					//< 注意危险
	MBCameraType_noOvertaking = 133,					//< 禁止超车
	MBCameraType_overtakingAllowed = 134,				//< 解除禁止超车
	MBCameraType_audibleWarning = 135,				//< 鸣喇叭
	MBCameraType_continuousDecent = 136,				//< 连续下坡
	MBCameraType_textWarning = 137,					//< 文字性警示标牌
	MBCameraType_confluenceFromLeft = 138,			//< 注意左侧合流
	MBCameraType_confluenceFromRight = 139,			//< 注意右侧合流
	///(以下类型为四维12夏新增)
	MBCameraType_stopToGiveWay = 140,					///< 停车让行
	MBCameraType_joinToGiveWay = 141,					///< 会车让行
	MBCameraType_decelerationToGiveWay = 142,			///< 减速让行
	MBCameraType_tunnelToLight = 143,					///< 隧道开灯
	MBCameraType_tideRoad = 144,						///< 潮汐车道
	MBCameraType_convexRoad = 145,					///< 路面高凸
	MBCameraType_hollowRoad = 146,					///< 路面低洼
	///(以下类型为四维12冬新增)
	MBCameraType_reverseCurveRight = 147,				///< 反向弯路(右)
	MBCameraType_max = 148
} MBCameraType;


typedef enum MBHighwayGuideType
{
	MBHighwayGuideType_invalid, ///< 无效类型
	MBHighwayGuideType_IC,      ///< 出口
	MBHighwayGuideType_JC,      ///< 高速连接线
	MBHighwayGuideType_SA,      ///< 服务区
	MBHighwayGuideType_PA,      ///< 停车区
	MBHighwayGuideType_TG       ///< 收费站
} MBHighwayGuideType;

typedef enum MBTRouterError {
	MBERouterError_None,
	MBERouterError_OriDestTooNear,
	MBERouterError_SetOriFailed,
	MBERouterError_SetDestFailed,
	MBERouterError_ComputeFailed,
	MBERouterError_MissingSubfiles,
	MBERouterError_NotEnoughMemory,
	MBERouterError_NetworkError,
	MBERouterError_oriNoData,
	MBERouterError_destNoData,
	MBERouterError_waypointNoData
} MBTRouterError;

typedef enum MBAuthError
{
	MBAuthError_none = 0,
	MBAuthError_deviceIdReaderError,
	MBAuthError_licenseIoError,
	MBAuthError_licenseFormatError,
	MBAuthError_licenseMissing,
	MBAuthError_licenseIncompatible,
	MBAuthError_licenseDeviceIdMismatch,
	MBAuthError_expired,
	MBAuthError_noPermission,
	MBAuthError_otherError
} MBAuthError;

typedef enum MBAuthUpdateState
{
	MBAuthUpdateState_succ,
	MBAuthUpdateState_failed
} MBAuthUpdateState;

typedef struct _MBTmcOptions
{
	BOOL enableTmcReroute;//是否开启
	unsigned int rerouteCheckInterval;//算路间隔，单位：毫秒
	unsigned int routeColorUpdateInterval;
} _MBTmcOptions;
typedef enum _MBTmcRequest
{
	MBTmcRequest_updateRouteColors = 0x1,
	MBTmcRequest_unused = 0x2,
	MBTmcRequest_checkReroute = 0x4,
	MBTmcRequest_all = MBTmcRequest_updateRouteColors + MBTmcRequest_checkReroute
}_MBTmcRequest;

typedef enum _MBAnimationType
{
	MBAnimationType_linear,
	MBAnimationType_flyOver   //At present, only the helicopter style of fly is implemented.
}_MBAnimationType;

typedef enum _MBRouteTmcStyle{
	MBTmcRouteDrawStyle_normal = 1,
	MBTmcRouteDrawStyle_weaker = 2
}_MBRouteTmcStyle;

typedef enum MBHighwayGuideMode
{
	/**	缺省模式
     @details
     此模式下，用 HighwayGuide_getItem() 获取当前的高速行程信息，包括服务区和停车区，
     也可以用 HighwayGuide_getNextServiceArea() 来单独获取下一个服务区或停车区的信息。
     */
	MBHighwayGuideMode_default = 0,
    
	/** 排除服务区模式
     @details
     在此模式下，HighwayGuide_getItem() 返回的结果中不会包含任何服务区和停车区，
     但可以用 HighwayGuide_getNextServiceArea() 来获取下一个服务区或停车区的信息。
     */
	MBHighwayGuideMode_excludeServiceArea = 1,
    
	/**	服务区优先模式
     @details
     在此模式下，HighwayGuide_getItem() 返回的结果中尽可能包含至少一个服务区或停车区，即：
     如果 HighwayGuide_getNextServiceArea() 不为空，则这个服务区/停车区一定会出现在 HighwayGuide_getItem() 返回的结果中。
     */
	MBHighwayGuideMode_preferServiceArea = 2
} MBHighwayGuideMode;
#ifndef MBRouteTmcStyle
#define MBRouteTmcStyle _MBRouteTmcStyle
#endif
#ifndef MBTmcState
#define MBTmcState _MBTmcState
#endif

#ifndef MBAnimationType
#define MBAnimationType _MBAnimationType
#endif
#ifndef MBTmcRequest
#define MBTmcRequest _MBTmcRequest
#endif
#ifndef MBTmcOptions
#define MBTmcOptions _MBTmcOptions
#endif
#ifndef MBTNaviTurnIconID
#define MBTNaviTurnIconID _MBTNaviTurnIconID
#endif
#ifndef MBKeywordClass
#define MBKeywordClass _MBKeywordClass
#endif

#ifndef MBPoiQueryMode
#define MBPoiQueryMode _MBPoiQueryMode
#endif

#ifndef MBNaviSessionModule
#define MBNaviSessionModule _MBNaviSessionModule
#endif

#ifndef MBNaviMode
#define MBNaviMode _MBNaviMode
#endif

#ifndef MBNaviSessionRouteMethod
#define MBNaviSessionRouteMethod _MBNaviSessionRouteMethod
#endif

#ifndef MBRouteRule
#define MBRouteRule _MBRouteRule
#endif

#ifndef MBRoutePlanNum
#define MBRoutePlanNum 5
#endif

#ifndef MBPoint_Short
#define MBPoint_Short _MBPoint_Short
#endif

#ifndef MBRouteType
#define MBRouteType _MBRouteType
#endif

#ifndef MBErrorCode
#define MBErrorCode _MBErrorCode
#endif

#ifndef MBGPSDebugMode
#define MBGPSDebugMode _MBGPSDebugMode
#endif

#ifndef MBAvoidRoadType
#define MBAvoidRoadType _MBAvoidRoadType
#endif


#ifndef MBCameraDataState
#define MBCameraDataState _MBCameraDataState
#endif

#ifndef MBGuidanceMode
#define MBGuidanceMode _MBGuidanceMode
#endif

#ifndef MBGpsDeviceState
#define MBGpsDeviceState _MBGpsDeviceState
#endif

#ifndef MBCamerFilterMode
#define MBCamerFilterMode _MBCamerFilterMode
#endif

#ifndef MBAvoidUTurnMode
#define MBAvoidUTurnMode _MBAvoidUTurnMode
#endif

#ifndef MBNaviSessionNaviStartVoiceMode
#define MBNaviSessionNaviStartVoiceMode _MBNaviSessionNaviStartVoiceMode
#endif

#ifndef MBTmcReportError
#define MBTmcReportError _MBTmcReportError
#endif

#define KLocationManagerSimStartNotification @"com.mapbar.lmnss"

#endif

