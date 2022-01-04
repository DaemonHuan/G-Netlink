//
//  MBIconOverlay.h
//  Navigation
//
//  Created by delon on 12-12-26.
//
//

#import "MBOverlay.h"
#import "MBNaviCoreTypes.h"

/** @interface MBIconOverlay
 *
 *  @brief  绘制图标的Overlay
 *  @note
 */
@interface MBIconOverlay : MBOverlay

/** @property   scaleFactor
 *
 *  @brief  缩放比例因子
 *  @note
 */
@property(nonatomic,assign) CGFloat scaleFactor;

/** @property   position
 *
 *  @brief  图标在地图上的位置经纬度坐标
 *  @note
 */
@property(nonatomic,assign) MBPoint position;

/** @property   orientAngle
 *
 *  @brief  图标角度
 *  @note   此角度为地图中的角度，即，正北为0度，逆时针为正<br>也就是正东是270度，正南为180度，正西为90度，单位：度
 */
@property(nonatomic,assign) CGFloat orientAngle;

/**
 *
 *  @brief  根据指定图片创建图标Overlay
 *  @param  filePath    所使用的图片路径
 *  @param  maintainPixelSize    是否保持像素级大小文件路径
 *  @return 类对象
 */
- (id)initWithFilePath:(NSString *)filePath maintainPixelSize:(BOOL)maintainPixelSize;

/**
 *
 *  @brief  设置图片路径
 *  @param  filePath    文件路径
 *  @return 空
 *  @note   用于动态修改所使用的图标
 */
- (void)setImageFilePath:(NSString *)filePath;

/**
 *
 *  @brief  添加图片动画
 *  @param  subimageNumber  图片数量
 *  @param  flashPattern    "*1000" means all frames last 1000 milliseconds. Like:*-*-*-*-*-...... "b300;a300;b300;a1800" constitues a flash-flash warning effect. Like: *-*------*-*-------......
 *  @return 空
 */
- (void)markAsAnimated:(NSUInteger)subimageNumber flashPattern:(NSString *)flashPattern;

@end
