//
//  MBCustomAnnotation.h
//  iNaviCore
//
//  Created by fanwei on 5/16/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBAnnotation.h"
/**
 *  自定义的Annotation
 */
@interface MBCustomAnnotation : MBAnnotation
/**
 * 构造函数，支持自定义图标的{@link Annotation}<br>
 *
 * @param zLevel Z轴方向的等级，也就所处的压盖关系
 * @param pos 所在位置
 * @param iconId 所使用的图标ID，对于CustomAnnotation来说，此ID必须唯一
 * @param pivot
 *            设置显示时调整的X轴，Y轴的偏移量<br>
 *            默认情况下显示时的位置为图标中心点<br>
 *            此参数可以设置显示时相对于图标中心点的偏移量
 * @param icon 自定义图标，必须是{@link android.graphics.Bitmap.Config#ARGB_8888}格式的
 */
- (id)initWithZLevel:(NSInteger)zLevel pos:(MBPoint)pos pivot:(CGPoint)pivot path:(NSString*)path;
/**
 * 动态切换CustomAnnotation所显示的图标
 *
 * @param pivot 图标显示的的位置
 * @param icon  图标资源位图
 */
-(void)setCustomIcon:(CGPoint)pivot path:(NSString*)path;
@end
