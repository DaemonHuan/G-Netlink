//
//  MBPolylineOverlay.h
//  Navigation
//
//  Created by delon on 12-12-26.
//
//

#import "MBMultipointOverlay.h"
#import <CoreLocation/CoreLocation.h>
#import "MBNaviCoreTypes.h"

typedef enum MBStrokeStyle
{
    MBStrokeStyle_solid,	// (========)
    MBStrokeStyle_solidWithButt,	// |==================|
    MBStrokeStyle_10,		// * * * * * * * * *
    MBStrokeStyle_63,		// ------   ------   ------
    MBStrokeStyle_railway,// == == == == ==
    MBStrokeStyle_route,	// ->--->---->---
    MBStrokeStyle_unknown
} MBStrokeStyle;

/** @interface MBPolylineOverlay
 *
 *  @brief  绘制多边形polygon和线条line的Overlay
 *  @note
 */
@interface MBPolylineOverlay : MBMultipointOverlay

/**
 *
 *  @brief  根据点数组创建一个多边形图层
 *  @param  points  点的数组，用来表示线段
 *  @param  count   点的数组数量
 *  @param  isClosed  是否是闭合区域，如果是，那么最后一个点将自动和第一个点连接
 *  @return 类对象
 */
- (id)initWithPoints:(const MBPoint*) points count:(NSInteger)count isClosed:(BOOL)isClosed;

- (id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count closed:(BOOL)closed;

/**
 *
 *  @brief  设置线条类型
 *  @param  style  线条类型
 *  @return 空
 */
- (void)setStrokeStyle:(MBStrokeStyle)style;
/**
 *  得到线条类型
 *
 *  @return style  线条类型
 */
- (MBStrokeStyle) getStrokeStyle;

/**
 *
 *  @brief  设置线条外边缘颜色
 *  @param  color  颜色格式(A,R,G,B)，例如0xff ff 00 00表示完全不透明的红色
 *  @return 空
 */
- (void)setOutlineColor:(NSUInteger)color;

/**
 *
 *  @brief  设置线条外边缘颜色
 *  @param  color  颜色格式(A,R,G,B)，例如0xff ff 00 00表示完全不透明的红色
 *  @return 空
 */
- (void)setOutlineUIColor:(UIColor *)color;
/**
 *
 *  @brief  设置多边形或线段的宽度值
 *  @param  width  多边形或线段的宽度值
 *  @return 空
 */
- (void)setWidth:(CGFloat)width;
/**
 *  得到多边形或者线段的宽度值
 *
 *  @return 宽度
 */
-(CGFloat)getWidth;
/**
 *  得到边缘线的颜色值，用UIColor实例表示
 *
 *  @return UIColor实例
 */
- (UIColor*)getOutlineUIColor;

@end