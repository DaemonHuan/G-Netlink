//
//  MBReverseGeocodeObject.h
//  iNaviCore
//
//  Created by fanyl on 14-2-28.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"
/**
 *  逆地理对应类
 */
@interface MBReverseGeocodeObject : NSObject < NSCoding >
@property (nonatomic,assign) MBPoint pos;///< 在线POI 的显示坐标
@property (nonatomic,assign) int distance;//距离
@property (nonatomic,assign) int roadDistance;//道路距离
@property (nonatomic,assign) MBPoint navPos;///< 在线POI 的导航坐标
@property (nonatomic,assign) int naviInfoTypeId;///< 在线POI 的类型编码
@property (nonatomic,retain) NSString* province;//省
@property (nonatomic,retain) NSString* city;//城市
@property (nonatomic,retain) NSString* area;//地区
@property (nonatomic,retain) NSString* typeName;//类型
@property (nonatomic,retain) NSString* poiDirection;//poi方向
@property (nonatomic,retain) NSString* poiArea;//兴趣点行政区
@property (nonatomic,retain) NSString* poiCity;//兴趣点城市
@property (nonatomic,retain) NSString* poiName;//名称
@property (nonatomic,retain) NSString* poiAddress;//兴趣点地址
@property (nonatomic,retain) NSString* roadName;//道路名称
@property (nonatomic,retain) NSString* roadDirection;//道路方向
@property (nonatomic,retain) NSString* roadLevel;//道路级别
-(id)initWithReverseGeocodeObject:(id)rgObject;
-(id)native;
@end
