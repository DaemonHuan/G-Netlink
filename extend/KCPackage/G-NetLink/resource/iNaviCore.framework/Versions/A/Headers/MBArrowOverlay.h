//
//  MBArrowOverlay.h
//  Navigation
//
//  Created by delon on 12-12-26.
//
//

#import "MBMultipointOverlay.h"
#import "MBNaviCoreTypes.h"

/** @interface MBArrowOverlay
 *
 *  @brief  箭头图层
 *  @note   
 */
@interface MBArrowOverlay : MBMultipointOverlay

/** @property   width
 *
 *  @brief  箭头宽度
 *  @note
 */
@property(nonatomic,assign) CGFloat width;

/** 
 *
 *  @brief  初始化箭头（C风格）
 *  @param  points  绘制箭头的坐标点
 *  @param  count   坐标点的数量
 *  @note
 */
- (id)initWithPoints:(const MBPoint*)points count:(NSInteger)count;
/**
 *
 *  @brief  箭头宽度（OC风格）
 *  @param  points  点的数组
 *  @note
 */
- (id)initWithPoints:(NSArray*)points;
@end