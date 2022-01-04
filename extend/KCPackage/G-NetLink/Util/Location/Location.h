//
//  Location.h
//  ZhiJiaX
//
//  Created by jishu on 13-4-18.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "BaseDataModule.h"
#import "LocationInfomation.h"
#import <iNaviCore/MBGpsLocation.h>

#define KEY_NAVIGATION  @"KEY_NAVIGATION"

@protocol LocationDelegate <NSObject>
@optional
-(void)didGetCurrentGpsInfo:(LocationInfomation*)locationInfo;
-(void)didGpsDisconnected;
@end


@interface Location : BaseDataModule<MBGpsLocationDelegate>
{
@protected
    BOOL _locationStatus;
    
}
@property(nonatomic,readonly)BOOL locationStatus;
@property(nonatomic,assign)id<DataModuleDelegate,LocationDelegate> observer;
- (void)requestLocation;
+(BOOL)checkLocationServer;
-(void)close;
@end
