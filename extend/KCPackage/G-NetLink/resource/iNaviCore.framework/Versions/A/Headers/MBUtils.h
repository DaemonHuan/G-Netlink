//
//  MBUtils.h
//  iNaviCore
//
//  Created by delon on 13-4-24.
//  Copyright (c) 2013年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"

@interface MBUtils : NSObject
/**
 *  数据源
 *
 *  @param fileName 文件相对路径
 *
 *  @return 字典，keys分别是：fileExist，guid，dataVersion，moreDataVersionNumber，moreDataVersions，mapbarVersion，compileTime，dataId，values分别是：BOOL，NSString，NSString，int，NSArray，NSString，NSString，NSString。
 */
+ (NSDictionary *)App_getNaviDataMetadata:(NSString*)fileName;
/**
 *  将世界坐标系下的经纬度表示的长度转换为屏幕坐标系下的长度,来绘制用于显示的比例尺。
 *
 *  @param startPoint 起点坐标
 *  @param endPoint   终点坐标
 *
 *  @return 距离，单位：米。
 */
+ (NSInteger)distanceWithStartPoint:(MBPoint *)startPoint endPoint:(MBPoint *)endPoint;
/**
 *  将世界坐标系下的经纬度表示的长度转换为屏幕坐标系下的长度,来绘制用于显示的比例尺。
 *
 *  @param startPoint 起点坐标
 *  @param endPoint   终点坐标
 *
 *  @return 距离，单位为“公里”、“米”、“英里”、“英尺”。
 */
+ (NSString *)distanceTextWithStartPoint:(MBPoint *)startPoint endPoint:(MBPoint *)endPoint;
/**
 *  int类型的距离转化成字符串类型的距离
 *
 *  @param length int表示的长度
 *
 *  @return 字符串表示的长度
 */
+ (NSString *)distanceTextWithLength:(int)length;
/**
 *  相对位置转化为字符串，比如"东偏北300米"，但是如果小于等于100米，则返回"附近"
 *
 *  @param startPoint 起始点
 *  @param endPoint   终点
 *
 *  @return 字符串描述
 */
+ (NSString *)orientationTextWithStartPoint:(MBPoint *)startPoint endPoint:(MBPoint *)endPoint;

+ (NSInteger)angleFromDx:(NSInteger)dx andDy:(NSInteger)dy;
+ (NSInteger)angleFromPoint:(MBPoint)posFrom toPoint:(MBPoint)posTo;

/**
 *  白天黑夜自动模式，根据当前时区自动判断是否是白天或者黑夜
 *
 *  @return -1表示error,0表示daymode,1表示nightmode
 */
+ (int)isNightMode;

+ (NSString*)getAbsolutePath:(NSString*)relativePath;
+ (MBDateTime)NSDate2DateTime:(NSDate*)date;
+ (NSString*)Device_uniqueDeviceIdentifier;
@end
