//
//  MBRoutePointCollector.h
//  iNaviCore
//
//  Created by fanyl on 14-7-8.
//  Copyright (c) 2014年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBObject.h"
#import "MBNaviCoreTypes.h"

@interface MBRoutePointCollectorData : MBObject
@property(nonatomic,assign)BOOL isValid;
@property(nonatomic,assign)NSInteger carOri;
@property(nonatomic,assign)MBPoint* points;
@property(nonatomic,assign)NSInteger pointsNum;
@end

@class MBRoutePointCollector;

@protocol MBRoutePointCollectorDelegate <NSObject>

-(void)RoutePointCollectorDataChanged:(MBRoutePointCollectorData*)data;

@end

@interface MBRoutePointCollectorParams : MBObject
@property(nonatomic,assign)NSUInteger forwardDistance;
@property(nonatomic,assign)id<MBRoutePointCollectorDelegate> delegate;
@end



@interface MBRoutePointCollector : NSObject
-(id)initWithParams:(MBRoutePointCollectorParams*)params;
@end
