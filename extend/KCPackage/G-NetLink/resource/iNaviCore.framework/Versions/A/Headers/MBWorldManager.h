//
//  MBWorldManager.h
//  iNaviCore
//
//  Created by fanwei on 1/10/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBWmrNode.h"
#import "MBNaviCoreTypes.h"
@class MBAdminBorder;
/** @interface MBWorldManager
 *
 *  @brief  城市管理类
 *  @note   
 */
@interface MBWorldManager : NSObject

/**
 *
 *  @brief  获取城市管理的单例对象
 *  @return MBWorldManager 对象
 *  @note
 */
+(MBWorldManager *)sharedInstance;

/**
 *
 *  @brief  获取根节点信息
 *  @return MBWorldObject对象
 *  @note
 */
- (MBWmrNode *)rootWmrNode;

/**
 *
 *  @brief  获取根节点对象ID
 *  @return 根节点ID
 其实已经没用了，为了兼容之前版本，rootWmrNode替代
 */
- (NSUInteger) getRoot;

/**
 *  @brief  根据邮政编码返回当前行政区划ID
 *
 *  @param  adminCode 邮政编码
 *  @return 行政区划ID
 */
-(NSInteger)getIdByAdminCode:(NSInteger)adminCode;

/**
 *  @brief  根据行政区划ID返回邮政编码
 *
 *  @param  nodeId 行政区划ID
 *  @return 行政区划ID
 */
-(NSInteger)getAdminCodeByNodeId:(NSInteger)nodeId;

/**
 *
 *  @brief  根据节点ID，获得该节点MBWmrNode对象
 *  @param  wmrNodeId 节点ID 
 *  @return MBWmrNode对象
 */
- (MBWmrNode *) getNodeById:(NSInteger)nodeId;

/**
 *
 *  @brief  根据节点ID，获得该节点下的全部Child对象
 *  @param  nodeId 节点ID
 *  @return NSArray<MBWmrNode>对象
 和MBWmrNode的children重复，为了兼容。
 */
- (NSArray*) getChildNodes:(NSInteger)nodeId;
- (MBWmrNode *) getNodeByIdWithoutThirdLevel:(NSInteger)nodeId;
/**
 *  @brief  根据指定的经纬度坐标返回其所在的行政区划名称
 *
 *  @param  pt 指定的经纬度坐标
 *  @param  level
 *            要获取得到的行政区区划级别<br>
 *            3： 省一级，如：“安徽”，“北京市”<br>
 *            2：地级市一级，如：“安徽滁州市”，“北京市”<br>
 *            1：区县一级，如：“安徽滁州市凤阳县”，“北京市西城区”
 *  @return 得到的行政区划名称
 */
- (NSString*)getCompleteRegionName:(MBPoint)pt level:(NSInteger)level;
    
/**
 *
 * @brief   根据指定的位置，返回该位置所属城市结点信息
 * @param   pt 指定位置的经纬度坐标
 * @return  所属城市结点信息
 */
-(MBWmrNode *)getNodeByPosition:(MBPoint)pt;
/**
 *  根据指定的位置，返回该位置所属的城市ID
 *
 *  @param point 坐标
 *
 *  @return 城市id
 */
-(int)getIdByPosition:(MBPoint)point;
/**
 *  根据经纬度坐标获取指定城市的ID，此处获取的ID是带有PED文件的ID，一般来说是城市、直辖市以及特别行政区的ID
 *
 *  @param point 坐标
 *
 *  @return 城市id
 */
-(int)getPedIdByPosition:(MBPoint)point;

/**
 *
 *  @brief  根据指定的ID，返回其对应的不带扩展名的数据文件路径
 *          使用数据文件时，尽量用本函数来构造数据文件名，而不要在代码中写死。
 *          对于纯国内数据，id 为 0 时得到的结果是：L"china/china"，
 *          id 为 1 时得到：L"china/0beijing/0beijing"
 *          对于躲过数据，如当前国家为印度，id 为 0 时得到的结果将会是：L"in/india/india"。
 *
 *  @param  id 指定的行政区划节点ID
 *  @return 不带扩展名的文件路径
 */
-(NSString*)getDataFileWithoutExt:(NSInteger)nodeId;

/**
 *
 *  @brief  分省数据时，根据ID判断对应省份的数据是否已经下载了
 *  @param  id 省ID
 *  @return 如果已经存在则返回true，否则返回false
 通routeDataExists
 */
-(BOOL)dataExist:(NSInteger)nodeId;

/**
 *
 *  @brief  判断当前是否有全国节点
 *  @return 如果存在，返回全国节点Id，如果不存在，返回无效Id
 */
-(NSInteger) get0achinaNode;

/**
 *
 *  @brief  根据关键字或拼音查询相关的城市Id
 *  @param  id		搜索范围Id，最大为全国，即根节点Id
 *  @param  kwandPY	所要查询城市的关键字或拼音
 *  @param  maxNum	最大查找结果数
 *  @return	返回所有匹配的结果Id集合
 */
-(NSArray*)getIdByKeywordOrPY:(NSInteger)nodeId kwandPY:(NSString*)kwandPY maxNum:(NSInteger)maxNum;

/**
 *
 *  @brief  获取行政区划名称
 *  @param  p		制定位置经纬度坐标
 *  @param  level	所要获取的区县级别{@link WorldManager.DistrictLevel}
 *  @return	返回行政区划名称字符串，如果未获取到或者不支持此方法，那么将返回null
 */
-(NSString*)getRegionNameByPosition:(MBPoint)point level:(NSInteger)level;

/**
 *
 *  @brief  根据行政区划编码字符串获取行政区划Id
 *  @param  adminCode	行政区划编码字符串
 *  @return	行政区划Id
 */
-(NSInteger)getIdByAdminCodeStr:(NSString*)adminCode;

/**
 *
 *  @brief  根据行政区名称获取Id
 *  @param  cityName	行政区划名称
 *  @return	返回行政区划id
 */
-(NSInteger)getNodeIdByCityName:(NSString*)cityName;
-(NSInteger)getNodeId:(MBWmrNode*)node cityName:(NSString*)cityName;
/**
 @brief
 获取指定id的行政区划的多边形边界点坐标
 @param [out] adminBorder
 输出的边界点坐标，一个id可能对应多个多边形
 @return
 若给定的id无效则不对adminBorder进行操作，若有效返回AdminBorder结构指针。
 */
-(MBAdminBorder*)getBorderById:(NSInteger)nodeId;

/**
 * 指定的MBWorldObject是否存在导航数据
 *
 * @param worldObject 指定MBWorldObject对象
 * @return 如果存在返回YES
 同dataExist
 */
-(BOOL)routeDataExists:(MBWmrNode *)node;
/**
 * 指定的MBWorldObject是否存在地图数据
 *
 * @param worldObject 指定MBWorldObject对象
 * @return 如果存在返回YES
 */
-(BOOL)mapDataExists:(MBWmrNode *)node;
@end

