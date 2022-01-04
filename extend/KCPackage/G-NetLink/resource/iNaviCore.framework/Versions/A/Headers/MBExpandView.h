//
//  MBExpandView.h
//  Navigation
//
//  Created by admin on 12-8-10.
//  Copyright (c) 2013年 mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

/** @interface MBExpandView
 *
 *  @brief 路口放大图
 *
 */
@interface MBExpandView : NSObject

/**
 * 启用路口放大图
 */
@property(nonatomic,assign) BOOL enable;

/**
 *
 *  @brief  获取放大图的单例对象
 *  @return MBExpandView 对象
 *  @note
 */
+ (MBExpandView *)sharedInstance;

/**
 *
 *  @brief  释放放大图的单例对象
 *  @return MBExpandView 对象
 *  @note
 代替cleanup
 */
+(void) freeSharedInstance;

/**
 *
 *  @brief  设置放大图尺寸
 *  @return 空
 *  @note
 */
- (void)setViewWidth:(NSInteger)width height:(NSInteger)height;

/**
 *
 *  @brief  重新计算放大图尺寸
 *  @return 空
 *  @note
 */
- (void)resizeViewWidth:(NSInteger)width height:(NSInteger)height;

/**
 *
 *  @brief  获得路口放大图
 *  @return image 路口放大图
 *  @note
 */
- (UIImage *)expandImage;
/**
 为本次转弯禁用放大图。过了本次转弯，会自动恢复显示；若需要手动地恢复显示，应调用open().
 */
-(void) closeOnce;
/** 用于手动地清除closeOnce()的效果，以便在当前转弯通过之前即开始恢复显示放大图。
 @sa ExpandView_closeOnce()
 */
-(void) open;
/** 当前是否要显示“打开放大图”的按钮。“打开放大图”即需要调用open()。
 返回TRUE意味着当前有放大图可供显示、且因为closeOnce()的原因不需要显示。
 closeOnce().
 */
-(BOOL) shouldDisplayOpenButton;
@end
