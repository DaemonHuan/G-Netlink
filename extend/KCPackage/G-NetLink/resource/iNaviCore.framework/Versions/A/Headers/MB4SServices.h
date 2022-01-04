//
//  MB4SServices.h
//  iNaviCore
//
//  Created by fanyl on 14-5-4.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"
/**
 * 4S店排序规则
 */
typedef enum MBSortRule
{
	MBSortRule_byDistance = 0,	//< by distance away from your car
	MBSortRule_byKeywordScore = 1	//< by scores calculated between keyword and 4s'name and address strings
}MBSortRule;

@class MB4SObject;
/**
 * 4S店搜索功能模块
 * 注意：此模块需要使用额外的资源文件。打包在base.dat中。
 */
@interface MB4SServices : NSObject
/**
 * 模块初始化，失败返回 nil
 */
+ (MB4SServices *) shared4SServices;
/**
 *  设置排序规则
 */
@property (nonatomic,assign) MBSortRule sortRule;
/**
 * 模块资源清理
 */
-(void)cleanup;
/**
 * 返回当前车类型个数
 * @return	车类型个数
 */
-(size_t)getCarTypeNum;
/**
 * 根据索引查找指定类型名称，如果名称不存在，或者索引不是有效值将返回null
 * @param carTypeIndex	车类型索引
 * @return	车类型名称字符串
 */
-(NSString*)getCarTypeByIndex:(int)index;
/**
 * 根据车类型名称和品牌名称首字母搜索指定的品牌名称
 * @param carTypeName	车类型名称
 * @param initials		品牌名称首字母，<font color="orange">如果需要所有的车类型名称所对应的品牌个数，则此参数应该传null</font>
 * @return	品牌个数
 * @since 4.9.x
 */
-(size_t)queryCarBrands:(NSString*)carTypeName initials:(NSString*)initials;
/**
 * 根据车品牌名称索引获取品牌名称
 * @param carBrandIndex	品牌名称索引
 * @return	品牌名称
 * @since 4.9.x
 * @see #queryCarBrands(String, String)
 */
-(NSString*)getCarBrandByIndex:(int)carBrandIndex;
/**
 * 按照指定类型排序结果<br>
 * @note
 * <font color="red"><i><b>
 * 注意：此方法仅在有返回结果后调用有效。
 * </b></i></font>
 * @param type	排序类型{@link MBSortRule}
 *
 * @since 4.9.x
 * @see SortRule
 */
-(void)setSortRule:(MBSortRule)sortRule;
/**
 * 根据关键字搜索车所在位置附近的4S店
 * @param carPos	车所在位置
 * @param cityId	所在城市及区县Id，如果输入城市以上级别id将没有结果，一般是通过{@link MBWorldManager}相关方法获取的
 * @param type		车类型
 * @param brand		搜索的汽车品牌名称
 * @param keyword	搜索的关键字，关键字可以为空
 * @since 4.9.x
 */
-(BOOL)queryWithPoint:(MBPoint)carPos wmrNodeId:(int)wmrNodeId type:(NSString*)type brand:(NSString*)brand keywords:(NSString*)keywords;

-(BOOL)queryByBrandAndWmrId:(MBPoint)carPos wmrNodeId:(int)wmrId brand:(NSString*)brand;
/**
 * 获取搜索结果数
 * @return	搜索结果数量
 * @since 4.9.x
 * @see #getResults(int, int)
 */
-(size_t)getResultRecordsNum;
/**
 *  根据索引得到查询结果对象
 *
 *  @param index 索引
 *
 *  @return 4S结果对象
 */
-(MB4SObject*)getResultRecordByIndex:(int)index;
/**
 * 根据品牌名称返回品牌名称所在索引位置
 * @param carBrandName	品牌名称
 * @return	品牌名称对应的在表中的索引位置，如果获取失败则返回无效索引{@link #INVALID_INDEX}
 */
-(size_t)getCarBrandIndex:(NSString*)carBrandName;

-(size_t)getCarBrandSubSetIndex:(int)brandIndexInWholeSet;
/**
 *  设置搜索距离限制
 *
 *  @param distanceLimit 距离限制
 */
-(void)setSearchAroundDis:(unsigned int)distanceLimit;

@end
