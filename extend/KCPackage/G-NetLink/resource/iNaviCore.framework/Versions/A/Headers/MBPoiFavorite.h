//
//  MBPoiFavorite.h
//  iNaviCore
//
//  Created by fanwei on 2/4/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"

/** @interface MBPoiFavorite
 *
 *  @brief POI点信息
 *  @note  
 */
@interface MBPoiFavorite : NSObject < NSCoding >

/** @property   type
 *
 *  @brief  POI类型码
 *  @note
 */
@property (nonatomic, assign) NSInteger type;

/** @property   pos
 *
 *  @brief  POI导航点坐标
 *  @note
 */
@property (nonatomic, assign) MBPoint pos;

/** @property   pos
 *
 *  @brief  POI显示点坐标，有可能与导航点坐标一致，也可能不一致。
 *  @note
 */
@property(nonatomic,assign) MBPoint displayPos;

/** @property   name
 *
 *  @brief  POI名称
 *  @note
 */
@property (nonatomic, retain) NSString *name;

/** @property   address
 *
 *  @brief  POI地址
 *  @note
 */
@property (nonatomic, retain) NSString *address;

/** @property   phoneNumber
 *
 *  @brief  POI电话
 *  @note
 */
@property (nonatomic, retain) NSString *phoneNumber;

/** @property   regionName
 *
 *  @brief  POI所在地区名
 *  @note
 */
@property (nonatomic, retain) NSString *regionName;

/** @property   distance
 *
 *  @brief  距离
 *  @note
 */
@property (nonatomic, assign) NSInteger distance;

@property(nonatomic,copy) NSString* pid;
@property(nonatomic,copy) NSString* displayName;
@property(nonatomic,copy) NSString* typeName;
//add for MBCloud
@property(nonatomic,copy) NSString* uid;
@property(nonatomic,assign) NSInteger editMode;
@property(nonatomic,assign)NSInteger index;
/** @property   useTime
 *
 *  @brief  收藏时间
 *  @note
 */
@property(nonatomic,assign)NSTimeInterval useTime;

-(id)initWithPoiFavorite:(id)poiFavorite;

-(MBPoint *)position;
-(MBPoint *)displayPosition;

-(BOOL)isEqual:(id)object;
-(BOOL)isValidate;
-(void)reset;
-(void)copyToPoiObject:(MBPoiFavorite *)poiObject;
-(void)updateFromPoiObject:(MBPoiFavorite *)poiObject;
-(MBPoiFavorite *)clone;
@end
