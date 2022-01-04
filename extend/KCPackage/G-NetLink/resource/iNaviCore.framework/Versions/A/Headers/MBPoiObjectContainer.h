//
//  MBPoiObjectContainer.h
//  Navigation
//
//  Created by delon on 13-2-27.
//
//

#import <Foundation/Foundation.h>
#import "MBPoiObjectLevel.h"

@class MBCloudServer;
@class MBPoiFavorite;

@interface MBPoiObjectContainer : NSObject
@property(nonatomic,readonly) NSMutableArray *poiObjects;
@property(nonatomic,readonly) NSMutableArray *delPoiObjects;

- (id)initWithLevel:(MBPoiObjectLevel)level;

- (BOOL)addPoiObject:(MBPoiFavorite *)poiObject;
- (BOOL)contains:(MBPoiFavorite *)poiObject;
- (MBPoiFavorite *)findPoiObjectWithName:(NSString *)name address:(NSString *)address type:(NSInteger)type;
- (void)removePoiObject:(MBPoiFavorite *)poiObject;
- (void)removeAllObjects;
- (void)synchronize;

//add for MBCloud
- (void)updataObjs:(NSArray *)objs;
- (void)comnitChangesWithOperate:(NSInteger)op withCategory:(NSInteger)category withServer:(MBCloudServer *)server;
- (MBPoiFavorite *)delArrContains:(MBPoiFavorite *)poiObject;
- (void)modifyPoiObjectWithName:(NSString *)name address:(NSString *)address type:(NSInteger)type poiObject:(MBPoiFavorite *)poiObj;
//shortcut only
-(void)modifyShortCutPoi:(MBPoiFavorite *)poiObj atIndex:(NSInteger)index;
@end
