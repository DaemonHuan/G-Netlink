//
//  MBCameraSystem.h
//  iNaviCore
//
//  Created by fanwei on 5/6/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum MBFilterMode {
	MBSimple,       // 简洁模式，仅播报必要的电子眼
	MBStandard,     // 标准模式，系统推荐使用，播报的比简洁模式多一些
	MBAll           // 详细模式，播报所有电子眼和交通标识
} MBFilterMode;

typedef enum MBCameraErrorCode
{
	MBCameraErrorCode_noError = 0,
	MBCameraErrorCode_userCameraNoUserFile,		///< 用户自定义电子眼文件不存在
	MBCameraErrorCode_userCameraInvalidIndex,		///< 无效的索引，超出自定义电子眼数目上限，或者小于-1
	MBCameraErrorCode_userCameraGrabFailed,		///< 自定义电子眼抓路失败
	MBCameraErrorCode_userCameraRepeat,			///< 在附近发现另一个用户自定义电子眼
	MBCameraErrorCode_userCameraInvalidId,		///< 无效的UserCamera id
	MBCameraErrorCode_userCameraInvalidPos,		///< 非法坐标
	MBCameraErrorCode_userCameraInvalidType,		///< 非法类型
}MBCameraErrorCode;

@class MBUserCameraData;

/** @interface MBCameraSystem
 *
 *  @brief 摄像头信息获取
 *  @note
 */
@interface MBCameraSystem : NSObject

/**
 *
 *  @brief  设置播报模式
 *  @param  mode  播报模式
 *  @return 空
 *  @note   一般推荐设置为标准模式
 */
-(void)setFilterMode:(MBFilterMode)mode;

/**
 *
 *  @brief  是否播报电子眼的语音
 *  @param  enable 果为true，表示正常播报，如果为false，那么只显示不播报语音
 *  @return 空
 *  @note   
 */
-(void)enableVoice:(BOOL)enable;

/**
 *
 *  @brief  获取前方道路中的电子眼
 *  @param  enable 果为true，表示正常播报，如果为false，那么只显示不播报语音
 *  @return 电子眼信息数组
 *  @note   如果前方无电子眼，那么返回0个元素的数组
 */
-(NSArray*)getCameras;

/**
 *
 *  @brief  根据下标获取用户自定义电子眼
 *  @param  index 下标
 *  @return 如果电子眼存在返回电子眼数据，否则返回null
 *  @note   
 */
-(MBUserCameraData*)getUserCamera:(NSInteger)index;
/**
 * 根据范围获取用户自定义电子眼，例如，获取全部电子眼时参数为(0, {@link #getUserCameraNum()})
 *
 * @param start
 *            开始位置
 * @param number
 *            个数
 * @return 用户自定义电子眼数组 MBUserCameraData
 */
-(NSArray*)getUserCameras:(NSRange)range;
/**
 * 添加自定义电子眼，应该保证电子眼数据base.cmr或base.ca2存在且获得授权
 *
 * @return 错误码{@link MBCameraErrorCode}，如果添加成功返回{@link MBCameraErrorCode#MBMBCameraErrorCode_noError}
 */
-(MBCameraErrorCode)addUserCamera:(MBUserCameraData*)userCamera;
/**
 *
 *  @brief  通过索引删除自定义电子眼
 *  @param  index 索引值
 *  @return 错误码，如果返回(MBCameraErrorCode)表示删除成功
 *  @note
 */
-(MBCameraErrorCode)removeUserCamera:(NSInteger)index;
/**
 * 通过ID删除自定义电子眼
 *
 * @param id
 *            自定义电子眼ID
 * @return 错误码，如果返回{@link ErrorCode#noError}表示删除成功
 */
-(MBCameraErrorCode)removeUserCameraById:(NSInteger)cameraId;

/**
 *
 *  @brief  根据索引替换自定义电子眼
 *  @param  index 索引
 *  @param  data 替换数据
 *  @return 错误码，如果返回{@link ErrorCode#noError}表示删除成功
 *  @note
 */
-(MBCameraErrorCode)replaceUserCamera:(NSInteger)index data:(MBUserCameraData*)data;
/**
 * 将添加的电子眼数据保存到文件中
 */
-(void)saveUserCamera2File;
/**
 *  获取用户自定义电子眼个数
 *
 *  @return 用户自定义电子眼个数
 */
-(NSInteger)getUserCameraNum;
@end
