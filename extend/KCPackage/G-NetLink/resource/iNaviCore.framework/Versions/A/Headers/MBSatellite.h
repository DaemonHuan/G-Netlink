//
//  MBSatellite.h
//  iNaviCore
//
//  Created by fanwei on 4/1/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBSatellite : NSObject
@property (nonatomic, assign) NSInteger	satId;
@property (nonatomic, assign) NSInteger	elevation;
@property (nonatomic, assign) NSInteger	azimuth;
@property (nonatomic, assign) NSInteger	SNRatio;
@end
