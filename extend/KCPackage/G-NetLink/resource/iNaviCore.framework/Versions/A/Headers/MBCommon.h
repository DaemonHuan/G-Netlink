//
//  MBCommon.h
//  iNaviCore
//
//  Created by fanwei on 2/4/13.
//  Copyright (c) 2013 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MBPoiFavorite.h"

@interface MBCommon : NSObject
+ (CLLocationCoordinate2D) getCoordinate2D:(cqPoint)point;
+ (cqPoint) getcqPoint:(CLLocationCoordinate2D)coordinate;
+ (cqPoint *) getcqPoints:(CLLocationCoordinate2D *)coords count:(NSInteger)count;
+ (NSString *) getNSString:(const cqWCHAR*)cqwchar;
+ (const cqWCHAR*) getCqWCHAR:(NSString *)string;
+ (MBPoiFavorite *) getMBPoiFavoriteWith:(PoiFavorite *)favorite;
@end
