//
//  MBAuth.h
//  iNaviCore
//
//  Created by delon on 13-7-11.
//  Copyright (c) 2013年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"

@class MBDataPackageDesc;
/**
 *  <#Description#>
 */
@interface MBAuth : NSObject
@property(nonatomic,copy) NSString *token;
@property(nonatomic,assign) id delegate;

+ (MBAuth *)sharedAuth;

/**
 @brief
 设置验证数据的URL
 @param [in] baseUrl 获取验证数据的URL，如果为空，则使用默认
 */
- (void)setLicenseBaseUrl:(NSString *)baseUrl;

/**
 @brief
 根据用户名，imei/mac设备号来更新权限列表文件
 @param [in] token 用户的唯一标识，是由服务端生成给客户端用的
 @param [in] dataLength 用户标识的长度
 */
- (void)updateLicense;
/**
 @brief
 根据用户输入的参数来请求授权文件
 @param [in] params 需要拼接的字符串参数，格式为param1=1&param2=2，此参数应该是请求URL的"?"后面的参数部分
 如：https://auth?param1=1&param2=2, 那么/p params应该为"param1=1&param2=2"
 @param [in] callback 请求返回后相应的回调函数
 */
- (void)updateLicenseWithParamString:(NSString *)param;
/**
 @brief
 获取指定数据包是否有使用权限，以及相关的数据信息获取
 @param [in] dataId 数据的GUID唯一标识
 @param [out] DataPackageDesc 数据包信息，如果此字段NULL，那么仅获取当前数据的状态信息，即参照AuthError
 在实际使用中，通常用的操作应该是Auth_getDataInfo(guid, NULL)如果返回AuthError_none表示数据可用
 @return 数据错误信息枚举
 
 @se
 DataPackageDesc
 @se
 AuthError
 */
- (MBDataPackageDesc *)dataInfoWith:(NSString *)dataId error:(MBAuthError *)error;
/**
 @brief
 指定的数据是否可用，属于一个简化的API
 @param [in] dataId 数据的唯一标识ID
 @return 数据可用返回TRUE，否则返回FALSE，如果想要过去更多的信息，可以调用Auth_getDataInfo
 
 @se
 Auth_getDataInfo
 */
- (BOOL)dataIsAvailable:(NSString *)dataId;
/**
 @brief
 获取当前已经存在的授权ID
 */
- (NSArray *)dataIds;
/**
 @brief
 检查授权文件状态
 返回结果仅可能是如下值：
 AuthError_none
 AuthError_deviceIdReaderError
 AuthError_licenseIoError
 AuthError_licenseFormatError
 AuthError_licenseMissing
 AuthError_licenseIncompatible
 AuthError_licenseDeviceIdMismatch
 */
- (MBAuthError)checkLicense;

+ (void)cleanup;

@end

@interface MBDataPackageDesc : NSObject
@property(nonatomic,readonly) NSString *dataId;
@property(nonatomic,readonly) NSDate *expiredTime;
@end

@protocol MBAuthDelegate
@optional
- (void)mbAuth:(MBAuth *)auth udpateState:(MBAuthUpdateState)state code:(NSInteger)code;
@end
