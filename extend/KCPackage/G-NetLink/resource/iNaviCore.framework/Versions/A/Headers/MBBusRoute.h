//
//  MBBusRoute.h
//  iNaviCore
//
//  Created by fanyl on 14-5-28.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import "MBObject.h"
#import "MBBus.h"
@interface MBBusRoute : MBObject
@property(nonatomic,retain)NSString* desc;
@property(nonatomic,retain)NSString* detail;
@property(nonatomic,assign)float transferCost;
@property(nonatomic,assign)float taxiCost;
@property(nonatomic,assign)BOOL isNightShift;
@property(nonatomic,assign)NSInteger travelTime;
@property(nonatomic,assign)int distance;
@property(nonatomic,assign)NSInteger segmentNum;
@property(nonatomic,retain)NSArray* segments;
@end


