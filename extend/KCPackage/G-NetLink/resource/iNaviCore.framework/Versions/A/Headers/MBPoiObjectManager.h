//
//  MBPoiObjectManager.h
//  Navigation
//
//  Created by delon on 13-2-27.
//
//

#import <Foundation/Foundation.h>
#import "MBPoiObjectLevel.h"
#import "MBPoiObjectContainer.h"
#import "MBPoiFavorite.h"

@interface MBPoiObjectManager : NSObject
+ (MBPoiObjectManager*)sharedPoiObjectManager;

- (MBPoiObjectContainer *)poiObjectContainerWithLevel:(MBPoiObjectLevel)level;

@end
