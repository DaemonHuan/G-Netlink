//
//  MBEngine.h
//  iNaviCore
//
//  Created by fanwei on 1/10/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"
/**
 *  引擎基础初始化委托。
 */
@protocol MBEngineDelegate <NSObject>
@optional
/**
 *  程序异常回调
 *
 *  @param info 错误信息
 */
-(void)appEventException:(NSString*)info;
/**
 *  程序授权成功回调
 */
-(void)sdkAuthSuccessed;
/**
 *  授权失败回调
 */
-(void)sdkAuthFailed:(MBSdkAuthError)errCode;
/**
 *  数据授权状态
 *
 *  @param dataState 数据授权状态对应编码
 */
-(void)dataAuthState:(MBAuthError)dataAuthError;
@end
/** @interface MBEngine
 *
 *  @brief  引挚类基础初始化。是一切模块的初始化基础。必须第一个初始化。
 *  
 */
@interface MBEngine : NSObject
/**
 *  引擎委托
 */
@property(nonatomic,assign)id<MBEngineDelegate>delegate;
/**
 *  sdk授权错误码，默认是MBSdkAuthErrorType_keyIsMismatch。
 */
@property(nonatomic,readonly) MBSdkAuthError errCode;
/**
 *  引擎sdk授权是否激活
 */
@property(nonatomic,readonly) BOOL activate;
/**
 * @brief  引擎sdk授权key
 */
@property(nonatomic,readonly) NSString *key;
/**
 * @brief  返回设置参数
 */
@property(nonatomic,readonly) NSDictionary *params;
/**
 *
 *  @brief  初始化C引挚基础类库
 *  @note   必须在APP初始化的时候完成该工作，且应该仅初始化一次。在checkWithKey:方法前调用。
 */
+ (MBEngine *) sharedEngine;
/**
 *  授权验证，触发MBEngineDelegate。
 *
 *  @param key 激活码
 */
-(void) checkWithKey:(NSString*)key;
/**
 *
 *  @brief  清理
 */
+ (void) cleanup;
/**
 *  @brief  引擎版本
 */
- (NSString *)version;
/**
 *  @brief  获取引擎支持的最低的数据版本
 */
- (NSString *)dataVersion:(NSString*)filePath;
/**
 * @brief 清除已经初始化的对象
 */
- (void)uninitialize;
/**
 *  Sdk授权模块是否初始化
 *
 *  @return YES表示授权模块已经初始化
 */
-(BOOL)sdkAuthIsInited;
/**
 *  验证某个模块是否授权
 *
 *  @param type 授权模块
 *
 *  @return 授权结果
 */
-(MBSdkAuthError)sdkAuthCheck:(MBSdkAuthType)type;
/**
 *  更新时间
 *
 *  @return 更新时间
 */
-(NSString*)sdkAuthGetUpdateTime;
/**
 *  到期时间
 *
 *  @return 到期时间
 */
-(NSString*)sdkAuthGetExpiredTime;
/**
 *  经过授权的模块
 *
 *  @return 模块按与运算结果
 */
-(int)sdkAuthGetPermissions;
/**
 @brief 返回最后一次导航数据格式变化时的引擎版本号。
 
 @remarks
 
 4009000表示4.9.0。
 
 某些导航数据格式变化是不能向前兼容的。也就是说，老版本引擎无法使用新数据。
 此时，本函数的返回值会改变一次。
 
 客户端用本函数的返回值来确定某种数据是否能用于某版引擎。
 如果dataVersion > lastDataChangeVersion，这个数据就不能用。
 */
-(int)getLastDataChangeVersion;
@end
