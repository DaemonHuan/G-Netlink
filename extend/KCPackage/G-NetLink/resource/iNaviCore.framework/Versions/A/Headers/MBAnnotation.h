//
//  MBAnnotation.h
//  Navigation
//
//  Created by delon on 12-12-26.
//
//

#import <UIKit/UIKit.h>
#import "MBNaviCoreTypes.h"
/**
 *  MBAnnotation弹出样式
 */
typedef struct MBCalloutStyle
{
    /// 标题字体
    NSInteger titleSize;
    /// 副标题字体
    NSInteger subtitleSize;
    /// 标题颜色
    NSUInteger titleColor;
    /// 副标题颜色
    NSUInteger subtitleColor;
    /// 标题高亮
    NSUInteger titleColorHighlighted;
    /// 副标题高亮
    NSUInteger subtitleColorHighlighted;
    /// 左图标ID
    int leftIcon;
    /// 右图标ID
    int rightIcon;
    /// 锚点
    CGPoint anchor;
} MBCalloutStyle;

typedef enum MBAnnotationArea
{
    MBAnnotationArea_none,
    MBAnnotationArea_icon,
    MBAnnotationArea_leftButton,
    MBAnnotationArea_middleButton,
    MBAnnotationArea_rightButton
} MBAnnotationArea;

/**  MBAnnotation
 *
 *   标注，一个 MBMapView 上可以有多个 MBAnnotation。
 *
 */
@interface MBAnnotation : NSObject
{
@package
    id _native;
@package
    BOOL _attatched;
}

/** @property   clickable
 *
 *  @brief  是否可以点击
 *  @note   YES为可以点击，NO不可以点击，默认可以YES。
 */
@property(nonatomic,assign) BOOL clickable;

/** @property   position
 *
 *  @brief  位置坐标
 *  @note
 */
@property(nonatomic,assign) MBPoint position;

/** @property   title
 *
 *  @brief  标题
 *  @note
 */
@property(nonatomic,retain) NSString *title;

/** @property   subTitle
 *
 *  @brief  副标题
 *  @note
 */
@property(nonatomic,retain) NSString *subTitle;

/** @property   tag
 *
 *  @brief  tag标识
 *  @note
 */
@property(nonatomic,assign) NSInteger tag;

/** @property   selected
 *
 *  @brief  选中状态，默认 NO
 *  @note
 */
@property(nonatomic,assign) BOOL selected;

/** @property   hidden
 *
 *  @brief  是否隐藏，默认 NO
 *  @note
 */
@property(nonatomic,assign) BOOL hidden;


/** @property   calloutStyle
 *
 *  @brief {@link MBAnnotation}显示的样式
 *  @note
 */
@property(nonatomic,assign) MBCalloutStyle calloutStyle;

/**
 *
 *  @brief  初始化{@link MBAnnotation}实例
 *  @param  zLevel  Z轴方向的等级，也就所处的压盖关系
 *  @param  pos     所在位置
 *  @param  iconId  所使用的图标ID，用户自定义的图片，如:文件名1004.png，放在res目录的icons文件夹下。
 *  @param  pivot  设置显示时调整的X轴，Y轴的偏移量<br>默认情况下显示时的位置为图标左上角点<br>此参数可以设置显示时相对于图标左上角点的偏移量
 *  @return 空
 */
- (id)initWithZLevel:(NSInteger)zLevel pos:(MBPoint)pos iconId:(NSInteger)iconId pivot:(CGPoint)pivot;

/**
 *
 *  @brief  设置显示图标
 *  @param  iconId  所使用的图标ID
 *  @param  pivot  设置显示时调整的X轴，Y轴的偏移量<br>默认情况下显示时的位置为图标左上角点<br>此参数可以设置显示时相对于图标图标左上角点的偏移量
 *  @return 空
 */
- (void)setIcon:(NSInteger)iconId pivot:(CGPoint)pivot;

/**
 *
 *  @brief  设置图标上的文字，废弃。
 *  @param  text    文字内容
 *  @param  color   文字颜色
 *  @param  anchor  文字锚点位置
 *  @return 空
 */
- (void)setIconText:(NSString *)text color:(NSUInteger)color anchor:(CGPoint)anchor;

/**
 *
 *  @brief  设置图标上的文字，推荐。
 *  @param  text    文字内容
 *  @param  color   文字颜色
 *  @param  anchor  文字锚点位置
 *  @return 空
 */
- (void)setIconText:(NSString *)text UIColor:(UIColor *)color anchor:(CGPoint)anchor;
/**
 *
 *  @brief  设置图标文字大小
 *  @param  size  文字大小
 *  @return 空
 */
- (void)setIconTextSize:(NSInteger)size;

/**
 *
 *  @brief  需要刷新{@link Annotation}
 *  @return 空
 */
- (void)setNeedsDisplay;

/**
 *
 *  @brief  是否显示{@link Callout MBAnnotation}样式
 *  @param  show  YES显示，NO不显示，默认值 NO，该方法在是用MBMapView的addAnnotation之后调用有效
 *  @return 空
 */
- (void)showCallout:(BOOL)show;

/**
 *
 *  @brief  点击位置
 *  @return 空
 */
- (MBAnnotationArea)hitTest:(MBRect)clickArea;
@end
