//
//  MBHighwayGuide.h
//  iNaviCore
//
//  Created by fanyl on 14-5-23.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBObject.h"
#import "MBNaviCoreTypes.h"

@class MBHighwayGuideItem;
@interface MBHighwayGuide : NSObject
@property (nonatomic,assign) MBHighwayGuideMode mode;
@property (nonatomic,assign) BOOL enable;
@property (nonatomic,retain) NSArray* items;
-(id)sharedHighwayGuide;
-(void)cleanUp;
-(void)reset;
-(BOOL)shouldDisplay;
-(MBHighwayGuideItem*)getNextServiceArea;
@end

