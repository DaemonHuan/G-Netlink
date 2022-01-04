//
//  MBRouteDescriptionItem.h
//  iNaviCore
//
//  Created by fanwei on 2/26/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNaviCoreTypes.h"

/** @interface MBRouteDescriptionItem
 *
 *  @brief 路线详情类
 *  @note
 */
@interface MBRouteDescriptionItem : NSObject

/** @property   title
 *
 *  @brief  路线详情主体描述，例如，“请左转，然后进入 XX 路”
 *  @note
 */
@property (nonatomic,retain) NSString *title;

/** @property   subtitle
 *
 *  @brief  路线详情辅助描述，例如，“继续前行 XX 米”
 *  @note
 */
@property (nonatomic,retain) NSString *subtitle;

/** @property   distance
 *
 *  @brief  到达当前路线详情提示的距离
 *  @note
 */
@property (nonatomic,assign) NSInteger distance;

/** @property   iconId
 *
 *  @brief  当前路线详情提示所使用的图标{@link RouteDescriptionItem.TurnIconID}
 *  @note
 */
@property (nonatomic,assign) NSInteger iconId;

/** @property   position
 *
 *  @brief  当前路线详情提示所发生的位置的经纬度坐标
 *  @note
 */
@property (nonatomic,assign) MBPoint position;

/** @property   isChild
 *
 *  @brief  判断当前路线详情是否为子详情
 *  @note
 */
@property (nonatomic,assign) BOOL isChild;
/** @property   segmentIndex
 *
 *  @brief  当前路线详情开始的路段索引
 */
@property (nonatomic,assign) NSInteger segmentIndex;
@end
