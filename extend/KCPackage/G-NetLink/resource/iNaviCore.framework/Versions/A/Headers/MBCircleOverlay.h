//
//  MBCircleOverlay.h
//  Navigation
//
//  Created by delon on 12-12-26.
//
//

#import "MBOverlay.h"

/** @interface MBCircleOverlay
 *
 *  @brief  圆形图层
 *  @note
 */
@interface MBCircleOverlay : MBOverlay

/** @property   radius
 *
 *  @brief  半径
 *  @note
 */
@property(nonatomic,assign) CGFloat radius;

/**
 *
 *  @brief  初始化圆形图层
 *  @param  radius  半径
 *  @param  center  中心点坐标
 *  @note
 */
- (id)initWithCenter:(const MBPoint)center radius:(CGFloat)radius;

/**
 *
 *  @brief  设置圆形中心点箭头宽度
 *  @param  center  中心点坐标
 *  @note
 */
- (void)setCenter:(const MBPoint)center;

@end
