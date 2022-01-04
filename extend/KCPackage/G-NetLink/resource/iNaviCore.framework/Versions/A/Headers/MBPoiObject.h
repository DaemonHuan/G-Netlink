//
//  MBPoiObject.h
//  Navigation
//
//  Created by delon on 13-2-27.
//
//

#import <Foundation/Foundation.h>
#import "MBPoiFavorite.h"
#import "MBNaviCoreTypes.h"

@interface MBPoiObject : MBPoiFavorite< NSCoding >
@property(nonatomic,copy) NSString* pid;
@property(nonatomic,copy) NSString* displayName;
@property(nonatomic,assign) MBPoint displayPos;
@property(nonatomic,copy) NSString* typeName;
//add for MBCloud
@property(nonatomic,copy) NSString* uid;
@property(nonatomic,assign) NSInteger editMode;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSTimeInterval useTime;

-(id)initWithPoiFavorite:(id)poiFavorite;

-(MBPoint *)position;
-(MBPoint *)displayPosition;

-(BOOL)isEqual:(id)object;
-(BOOL)isValidate;
-(void)reset;
-(void)copyToPoiObject:(MBPoiObject *)poiObject;
-(void)updateFromPoiObject:(MBPoiObject *)poiObject;
-(MBPoiObject *)clone;

@end
