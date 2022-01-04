//
//  MBNaviProcessParams.h
//  iNaviCore
//
//  Created by fanyl on 13-9-3.
//  Copyright (c) 2013年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNaviProcessParams : NSObject
@property(nonatomic)BOOL autoTakeRoute;
@property(nonatomic)BOOL autoReroute;
@property(nonatomic)BOOL autoRemoveRoute;
@property(nonatomic)BOOL allowManualStartMode;
@property(nonatomic,assign) NaviRealtimeData* rtData;
@property(nonatomic,assign) NaviProcessEventHandler handler;
- (id) init;
@end
