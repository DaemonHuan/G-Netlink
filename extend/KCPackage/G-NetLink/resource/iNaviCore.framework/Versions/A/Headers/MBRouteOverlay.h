//
//  MBRouteOverlay.h
//  Navigation
//
//  Created by delon on 12-12-26.
//
//

#import "MBOverlay.h"
#import "MBNaviCoreTypes.h"

/** @interface MBRouteOverlay
 *
 *  @brief  绘制路线所使用的绘制图层
 *  @note
 */
@interface MBRouteOverlay : MBOverlay

/** @property   width
 *
 *  @brief  线宽值
 *  @note
 */
@property(nonatomic,assign) CGFloat width;

/** @property   outlineColor
 *
 *  @brief  路线边框颜色值
 *  @note
 */
@property(nonatomic,assign) NSUInteger outlineColor;

/** @property   outlineColor
 *
 *  @brief  路线边框颜色值
 *  @note
 */
@property(nonatomic,assign) UIColor * outlineUIColor;

/** @property   enableArrow
 *
 *  @brief  开启箭头绘制功能
 *  @note
 */
@property(nonatomic,assign) BOOL enableArrow;

/** @property   arrowColor
 *
 *  @brief  箭头颜色
 *  @note
 */
@property(nonatomic,assign) NSUInteger arrowColor;

/** @property   arrowColor
 *
 *  @brief  箭头颜色
 *  @note
 */
@property(nonatomic,assign) UIColor * arrowUIColor;

/** @property   arrowIntervalFactor
 *
 *  @brief  箭头的间隔因子
 *  @note
 */
@property(nonatomic,assign) CGFloat arrowIntervalFactor;

/** @property   route
 *
 *  @brief  路线实例
 *  @note
 */
@property(nonatomic,readonly) id route;

/**
 *
 *  @brief  初始化路线
 *  @param  route  路线实例
 *  @return 类对象
 */
- (id)initWithRoute:(id)route;
/**
 *  是否打开蚯蚓路，默认False。
 *
 *  @param enable True表示打开，False表示关闭。
 */
-(void)enableTmcColors:(BOOL)enable;
@end
