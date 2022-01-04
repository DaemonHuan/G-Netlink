//
//  MBOfflineRecord.h
//  iNaviCore
//
//  Created by mapbar on 13-9-12.
//  Copyright (c) 2013年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
/*  @brief  下载状态
 *  @note
 */
typedef enum DownloadState{
    DownloadState_None,
    DownloadState_Error,
    DownloadState_UnZip,
    DownloadState_Start,
    DownloadState_Pause,
    DownloadState_Downloading,
    DownloadState_Complete,
    DownloadState_UnZipError
}DownloadState;
/*  @brief  数据类型
 *  @note
 */
typedef enum DataType{
    DataType_None=0,
    DataType_Vip,
    DataType_Normal,
    DataType_Camera,
    DataType_Base
}DataType;

/** @interface MBOfflineRecord
 *
 *  @brief  离线下载记录（下载的文件，大小进度等）
 *  @note
 */
@interface MBOfflineRecord : NSObject<NSCoding>{
@package
    NSString* _url;
    NSString* _version;
    NSString* _md5s;
    NSString* _fileName;
    long long _downloadSize;
    long long _accumulateSize;
}
@property(nonatomic,getter = getDownloadSize) long long downloadSize;

@property(nonatomic,retain)NSString* dataId;
/** @property   name
 *
 *  @brief  名字
 *  @note
 */
@property(nonatomic,retain) NSString* name;
/** @property   fileSize
 *
 *  @brief  文件大小
 *  @note
 */
@property(nonatomic,assign) long long fileSize;
/** @property   download
 *
 *  @brief  下载状态
 *  @note
 */
@property(atomic,assign) DownloadState download;
/** @property   isUpdate
 *
 *  @brief  是否更新
 *  @note
 */
@property(nonatomic,assign) BOOL isUpdate;
/** @property   progress
 *
 *  @brief  下载进度
 *  @note
 */
@property(atomic,assign) NSInteger progress;
/** @property   childNodes
 *
 *  @brief  子节点
 *  @note
 */
@property(nonatomic,retain)NSArray * childNodes;
/** @property   type
 *
 *  @brief  数据类型
 *  @note
 */
@property(nonatomic,assign) DataType type;

/** @property   bandwidthUsedPerSecond
 *
 *  @brief  带宽(每秒的字节数)
 *  @note
 */
//@property(nonatomic,assign) unsigned long bandwidthUsedPerSecond;
@end
