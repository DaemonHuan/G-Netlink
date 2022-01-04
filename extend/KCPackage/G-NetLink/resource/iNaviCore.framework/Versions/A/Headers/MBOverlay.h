//
//  MBOverlay.h
//  Navigation
//
//  Created by delon on 12-12-26.
//
//

#import "MBNaviCoreTypes.h"
#import <UIKit/UIKit.h>

typedef enum MBOverlayLayer
{
    MBOverlayLayer_aboveBase,
    MBOverlayLayer_abovePoi,
    MBOverlayLayer_aboveBuilding,
    MBOverlayLayer_aboveAnnotation
} MBOverlayLayer;

/** @interface MBOverlay
 *
 *  @brief  图层
 *  @note
 */
@interface MBOverlay : NSObject
{
@package
    id _native;
@package
    BOOL _attatched;
}

/** @property   overlayerLayer
 *
 *  @brief  类型
 *  @note
 */
@property(nonatomic,assign) MBOverlayLayer overlayerLayer;
/**
 * Apply the items of specified style class in current style sheet to the stylized-object.
 *
 * These items are those rooted at "class-CNAME.ONAME" with "CNAME" replaced with real value of \a styleClass and
 * "ONAME" replaced with the node name of the stylized-object.
 * For configure items of the stylized-object that doesn't exist in specified style class, if this stylized-object
 * has already been added to a MapRendererthey will keep unchanged; otherwise, when the object is added to a MapRenderer
 * or the MapRenderer reloads a style sheet, they will take the values of these items in default style class of the sheet.
 * @param [in] styleClass
 *		The name of the style class to apply. Default: "DEFAULT".
 * @return
 *		Whether this stylized-object occurs in the specified style class.
 */
@property (nonatomic,retain) NSString* styleClass;

/** @property   hidden
 *
 *  @brief  隐藏
 *  @note
 */
@property(nonatomic,assign) BOOL hidden;

/** @property   tag
 *
 *  @brief  图层标签
 *  @note
 */
@property(nonatomic,assign) NSInteger tag;

/** @property   postion
 *
 *  @brief  图层位置
 *  @note
 */
@property(nonatomic,assign) MBPoint postion;

/**
 *
 *  @brief  设置需要刷新{@link Overlay}
 *  @return 空
 */
- (void)setNeedsDisplay;

/**
 *
 *  @brief  设置{@link Overlay}绘制时使用的画刷颜色
 *  @param  color 颜色值(ARGB)，一般为0xff0f0c0d的形式
 *  @return 空
 建议使用setUIColor
 */
- (void)setColor:(NSUInteger)color;

- (NSInteger)getColor;

/**
 *
 *  @brief  设置{@link Overlay}绘制时使用的画刷颜色
 *  @param  color 颜色值(ARGB)，一般为0xff0f0c0d的形式
 *  @return 空
 */
- (void)setUIColor:(UIColor *)color;

- (UIColor*)getUIColor;
/**
 *
 *  @brief  抽象方法
 *  @return 获取包络盒
 */
- (const MBRect)boundingBox;
@end
