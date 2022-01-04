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
    int x;
    int y;
} MBPoint;

typedef struct MBRect
{
    int left;
    int top;
    int right;
    int bottom;
} MBRect;

#endif

typedef struct MBNdsPoint
{
    int x, y;
} MBNdsPoint;

typedef struct MBRange {
    int lower;
    int upper;
} MBRange;

typedef struct MBRangeF {
    float lower;
    float upper;
} MBRangeF;

/**
 *
 *    表示日期时间的结构体
 *  
 */
typedef struct MBDateTime
{
    /**
     *   小时
     */
    NSInteger   m_hours;
    
    /**
     *   分钟
     */
    NSInteger 	m_minutes;
    
    /**
     *   秒钟
     */
    NSInteger 	m_seconds;
    
    /**
     *   年
     */
    NSInteger 	m_year;
    
    /**
     *   月
     */
    NSInteger 	m_month;
    
    /**
     *   日
     */
    NSInteger 	m_day;
    
} MBDateTime;

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


#ifndef MBRoutePlanNum
#define MBRoutePlanNum 5
#endif

#define KLocationManagerSimStartNotification @"com.mapbar.lmnss"

#endif

