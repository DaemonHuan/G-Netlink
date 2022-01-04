//
//  MBPoiQuery.h
//  iNaviCore
//
//  Created by fanwei on 1/25/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MBPoiQueryParams.h"
#import "MBPoiFavorite.h"
#import "MBRouteBase.h"

typedef enum MBPoiQueryHostType
{
	MBPoiQueryHostType_query = 1,					///< 在线关键字搜索Host
	MBPoiQueryHostType_nearby = 2,				///< 周边搜索Host
	MBPoiQueryHostType_alongRoute = 3				///< 沿路搜索Host
} MBPoiQueryHostType;
/**
 *  用于表示路段单侧方向信息
 */
typedef enum MBSideness
{
	MBSideness_unknown,
	MBSideness_left,
	MBSideness_right
}MBSideness;
/**
 *  用于表示指定对象所在的位置信息，一般用于表示其余相关路段的位置关系，如POI搜索结果在路段的左侧还是右侧、到达路段的正交距离等信息
 */
@interface MBSideInfo : NSObject
/**
 *  路段单侧方向SideInfo.Sideness，表示当前信息位置在路段的哪侧
 */
@property(nonatomic,assign) MBSideness sideness;
/**
 *  此信息到达路段的正交距离，单位：米
 */
@property(nonatomic,assign) int distance;
@end

/** @protocol MBPoiQueryDelegate
 *
 *  @brief POI搜索代理类
 
 与导航可能存在问题，1初始化默认在线，2搜索结果返回全部，而导航只是当页
 *
 */
@protocol MBPoiQueryDelegate;

/** @interface MBPoiQuery
 *
 *  @brief POI搜索类
 *      
 */
@interface MBPoiQuery : NSObject

@property(nonatomic, readonly) MBSdkAuthError authErrorType;
/** @property   delegate
 *
 *  @brief  接收者的委托。
 *  @note   当查询在线POI数据或部分离线数据功能,需要实现MBPoiQueryDelegate协议中的方法。
 */
@property(nonatomic, assign) id<MBPoiQueryDelegate> delegate;
/**
 *
 * @brief  保存最近使用的点坐标
 */
@property(nonatomic,readonly) MBPoint lastPosition;
/**
 *
 *  @brief  获取搜索的单例对象
 *  @return MBPoiQuery 对象
 *  @note
 */
+(MBPoiQuery *)sharedInstance;

/**
 *
 *  @brief  切换在线、离线搜索模式。一旦切换，现有结果会清空。需要重新搜索。
 *  @param  PoiQueryMode:PoiQueryMode_online(在线),PoiQueryMode_offline(离线)
 *  @return 空
 *  @see    setMode:
 *  @see    getMode:
 *  @note
 */
- (void) setMode:(MBPoiQueryMode)mode;

/**
 *
 *  @brief  获取当前的搜索模式：在线、离线
 *  @return PoiQueryMode：PoiQueryMode_online、PoiQueryMode_offline
 *  @see    getMode:
 *  @see    setMode:
 *  @note
 */
- (MBPoiQueryMode) getMode;

/**
 *
 *  @brief  返回是否还有下一页
 *  @return 如果有下一页则返回YES，没有下一页返回NO
 *  @note
 */
- (BOOL) hasNextPage;

/**
 *
 *  @brief  通过回调的形式，下载下一页。下载完成后，返回 PoiQueryEvent_pageLoaded 消息
 *  @return 空
 *  @note
 */
- (void) loadNextPage;

/**
 *
 *  @brief  通过回调的形式，加载上一页。加载完成后，返回 PoiQueryEvent_pageLoaded 消息
 *  @return 空
 *  @note
 */
- (void) loadPreviousPage;

/**
 *
 *  @brief  获取当前页第一个元素在搜索结果中的下标
 *  @return 返回当前页第一个元素在搜索结果中的下标
 *  @note
 */
- (NSInteger) getCurrentPageFirstResultIndex;

/**
 *
 *  @brief  获取当前页最后一个元素在搜索结果中的下标
 *  @return 返回当前页最后一个元素在搜索结果中的下标
 *  @note
 */
- (NSInteger) getCurrentPageLastResultIndex;

/**
 *
 *  @brief  获取当前结果页的页码
 *  @return 返回当前结果页的页码
 *  @note
 */
- (NSInteger) getCurrentPageIndex;

/**
 *
 *  @brief  获取总页码
 *  @return 返回总页码
 *  @note
 */
- (NSInteger) totalPageCount;

/**
 *
 *  @brief  返回总结果数。可能还需要用loadNextPage()加载
 *  @return 结果总数
 - (NSInteger) resultCount
 */
- (NSInteger) getTotalResultNumber;

/**
 *
 *  @brief  取消当前搜索，在线模式有效
 *  @return 空
 *  @note
 */
- (void) cancel;

/**
 *
 *  @brief  为关键字/首字母/地址/交叉路口/公交车站搜索设置当前城市
 *  @param  wmrId 城市树中节点id
 *  @return 空
 *  @see    setWmrId:
 *  @see    getWmrId:
 *  @note
 */
- (void) setWmrId:(NSInteger)wmrId;

/**
 *
 *  @brief  获取当前城市ID
 *  @return 空
 *  @see    getWmrId:
 *  @see    setWmrId:
 *  @note
 */
- (NSInteger) getWmrId;

/**
 *
 *  @brief  关键字搜索
 *  @param  keyword 搜索关键字
 *  @param  center  搜索中心点，用于计算到POI的距离
 *  @return 空
 *  @see    queryByKeyword:center:
 *  @see    queryNearbyKeyword:center:
 *  @note   
 */
- (void) queryByKeyword:(NSString *)keyword center:(MBPoint)pos;

/**
 *
 *  @brief  周边关键字搜索
 *  @param  keyword 搜索关键字
 *  @param  center  搜索中心点，用于计算到POI的距离
 *  @return 空
 *  @see    queryNearbyKeyword:center:
 *  @see    queryByKeyword:center:
 *  @note   这是个有些争议的功能，建议尽量避免或很少使用
 */
- (void) queryNearbyKeyword:(NSString *)keyword center:(MBPoint)pos;

/**
 *
 *  @brief  文本搜索，支持汉子关键字和拼音首字母搜索
 *  @param  text 搜索文本
 *  @param  center  搜索中心点，用于计算到POI的距离
 *  @param  nearby  是否是周边搜索
 *  @return 空
 */
- (void) queryText:(NSString*)text center:(MBPoint)pos isNearby:(BOOL) nearby;

/**
 *
 *  @brief  周边类型搜索
 *  @param  center  搜索中心点，用于计算到POI的距离
 *  @param  index   POI 类型索引（POI 类型 ID），实际上是 POI 类型树中节点的序号
 *  @return 空
 */
- (void) queryNearbyCenter:(MBPoint)pos poiType:(NSInteger)index;


/**
 *
 *  @brief  用类型码数组来做周边类型搜索
 *  @param  center  搜索中心点，用于计算到POI的距离
 *  @param  types   MBPoiType实例数组
 *  @return 空
 */
-(void)queryNearbyByPoiTypes:(MBPoint)center poiTypes:(unsigned int*)types length:(int)len;

/**
 *
 *  @brief  清除现在的搜索结果
 *  @return 空
 */
- (void) clearResult;

/**
 *
 *  @brief  根据经纬度坐标生成一个 POI(注：离线函数)
 *  @param  经纬度坐标
 *  @return MBPoiFavorite POI点
 *  @note   在传入的坐标点位置做一个周边搜索（排除停车场、公共厕所、车站、高速出入口、收费站、ATM/自助银行、其他加油站、中国石油、中国石化、壳牌、美孚、BP等类型）
 /n如果搜索到最近的 POI 离 @p pos 的距离小于等于 10，则直接返回此 POI
 /n如果搜索到最近的 POI 里 @p pos 的距离大于 10，则将该 POI 的地址修改为行政区划名称，并在名称后加上“附近”，然后返回
 /n如果没有搜索到 POI，则返回一个名称为“未知地点”，地址为行政区划名称的 POI
 */
- (MBPoiFavorite *) getPoiFavoriteByPosition:(MBPoint)pos;


/**
 *
 *  @brief  检测关键字分类
 *  @param  keyword         检测的关键字
 *  @return KeywordClass    关键字的类别
 *  @note   普通关键字建议使用 queryByKeyword:center: 做搜索
 /n周边关键字建议使用 queryNearbyKeyword:center: 做搜索
 *  @see    queryByKeyword:center:
 *  @see    queryNearbyKeyword:center:
 *  @note
 */
- (MBKeywordClass) classifyKeyword:(NSString *) keyword;
/**
 *
 *  @brief  通过拼音首字母进行检索
 *  @param  keyword     搜索关键词的拼音首字母
 *  @param  center      搜索中心点，用于计算到POI的距离
 *  @return 空
 */
- (void) queryByInitial:(NSString *)keyword center:(MBPoint)pos;

/**
 *
 *  @brief  地址搜索
 *  @param  keyword     搜索关键词的拼音首字母
 *  @param  center      搜索中心点，用于计算到POI的距离
 *  @return 空
 */
- (void) queryByAddress:(NSString *)keyword center:(MBPoint)pos;

/**
 *
 *  @brief  交叉路口搜索
 *  @param  keyword     搜索关键词的拼音首字母
 *  @param  center      搜索中心点，用于计算到POI的距离
 *  @return 空
 */
- (BOOL) queryCrossRoads:(NSString *)keyword center:(MBPoint)pos;

/**
 *
 *  @brief  公交站点搜索
 *  @param  keyword     搜索关键词的拼音首字母
 *  @param  center      搜索中心点，用于计算到POI的距离
 *  @return 空
 */
- (BOOL) queryBusStations:(NSString *)keyword center:(MBPoint)pos;

/**
 *
 *  @brief  清除现在的搜索结果
 *  @return 已经加载的结果数
 */
- (NSInteger) getResultNumber;

/**
 *
 *  @brief  将搜索结果按距离排序
 *  @return 空
 */
- (void) sortByDistance;

/**
 *
 *  @brief  将搜索结果按默认(如关键字搜索按相关度)排序
 *  @return 空
 */
- (void) sortByDefault;

/**
 *
 *  @brief  初始化联想字和拼音数据
 *  @return 空
 */
- (void) initRwdPyData;

/**
 *
 *  @brief  清除联想字和拼音数据
 *  @return 空
 */
- (void) cleanupRwdPyData;

/**
 *
 *  @brief  获取联想字的候选字
 *  @return 空
 */
//- (void) getRwd:(NSString *)keywork result:(RWDResult*)result;

/**
 *
 *  @brief  获取拼音输入的候选字
 *  @param  pinyin      将要查询的拼音
 *  @param  maxNum      获取拼音候选字的最大数量
 *  @return 空
 */
- (NSMutableArray *) getPyCandidates:(NSString *)pinyin maxNum:(NSInteger)maxnum;

/**
 *  沿路搜索,路线为当前导航引擎所采纳的路线，所以此方法必须在已经开始导航的情况下使用
 *
 *  @param poiTypeIndex 搜索类型
 *  @param carPos       当前位置
 */
-(void)queryByRouteWithPoiType:(NSInteger)poiTypeIndex carPoint:(MBPoint)carPos;
/**
 *  设置搜索相关服务的Host地址[在线]
 *
 *  @param type 搜索相关服务类型
 */
-(void)setHostUrl:(MBPoiQueryHostType)type hostUrl:(NSString*)hostUrl;
/**
 *  获取搜索相关服务的Host地址[在线]
 *
 *  @param type 搜索相关服务类型
 *
 *  @return Host URL
 */
-(NSString*)getHostUrl:(MBPoiQueryHostType)type;
/**
 *   获取搜索到的指定索引POI所在位置相对路线的关系信息[离线]，沿路搜索时获取POI相对于路线的左右侧信息及沿路的距离
 *
 *  @param index poi索引
 *
 *  @return 指定对象所在的位置信息
 */
-(MBSideInfo*)getResultRoutePosition:(int)index;
/**
 *  将结果以POI的形式返回[在线&离线]
 *
 *  @param index poi索引
 *
 *  @return 搜索点。
 */
-(MBPoiFavorite*)getResultAsPoiFavoriteInfo:(int)index;
/**
 *  设置全国范围搜索[在线]
 */
-(void)setWmrNationWide;
@end

/** @protocol MBPoiQueryDelegate
 *
 *  @brief POI搜索代理类
 *
 */
@protocol MBPoiQueryDelegate <NSObject>

@optional

/**
 *  @brief  poi搜索开始
 */
- (void) poiQueryStart;

/**
 *  @brief  poi搜索失败
 */
- (void) poiQueryFailed;

/**
 *  @brief  poi搜索没有结果
 */
- (void) poiQueryNoResult;

/**
 *  @brief  搜索分页结果回调
 *  @param  poiQuery    poi搜索对象
 *  @param  poiFavorite poi点
 */
- (void)poiQueryResultByPage:(NSArray *)result;
/**
 *  @brief  搜索所有结果回调
 *  @param  poiQuery    poi搜索对象
 *  @param  poiFavorite poi点
 */
- (void) didReversePoiQueryResult:(NSMutableArray *)poiFavorites;
@end
