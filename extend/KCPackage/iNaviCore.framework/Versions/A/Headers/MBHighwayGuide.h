//
//  MBHighwayGuide.h
//  iNaviCore
//
//  Created by fanyl on 14-5-23.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBObject.h"

typedef enum MBHighwayGuideMode
{
    /**	缺省模式
     @details
     此模式下，用 HighwayGuide_getItem() 获取当前的高速行程信息，包括服务区和停车区，
     也可以用 HighwayGuide_getNextServiceArea() 来单独获取下一个服务区或停车区的信息。
     */
    MBHighwayGuideMode_default = 0,
    
    /** 排除服务区模式
     @details
     在此模式下，HighwayGuide_getItem() 返回的结果中不会包含任何服务区和停车区，
     但可以用 HighwayGuide_getNextServiceArea() 来获取下一个服务区或停车区的信息。
     */
    MBHighwayGuideMode_excludeServiceArea = 1,
    
    /**	服务区优先模式
     @details
     在此模式下，HighwayGuide_getItem() 返回的结果中尽可能包含至少一个服务区或停车区，即：
     如果 HighwayGuide_getNextServiceArea() 不为空，则这个服务区/停车区一定会出现在 HighwayGuide_getItem() 返回的结果中。
     */
    MBHighwayGuideMode_preferServiceArea = 2
} MBHighwayGuideMode;

@class MBHighwayGuideItem;
/**
 *  高速引导
 */
@interface MBHighwayGuide : NSObject
/**
 *  高速引导模式
 */
@property (nonatomic,assign) MBHighwayGuideMode mode;
/**
 *  是否开启
 */
@property (nonatomic,assign) BOOL enable;
@property (nonatomic,retain) NSArray* items;
/**
 *  得到单例，注意：必须在主线程调用
 *
 *  @return 高速引导单例
 */
+(instancetype)sharedHighwayGuide;
/**
 *  高速引导销毁
 */
-(void)cleanUp;
-(void)reset;
-(BOOL)shouldDisplay;
-(MBHighwayGuideItem*)getNextServiceArea;
@end

