//
//  DataForDrivingLog.h
//  G-NetLink-v2.0
//
//  Created by jk on 4/19/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataForDrivingLog : NSObject

@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, strong) NSString * endTime;

@property (nonatomic, strong) NSString * startPointLatitude;
@property (nonatomic, strong) NSString * startPointLongitude;
@property (nonatomic, strong) NSString * startPointName;

@property (nonatomic, strong) NSString * endPointLatitude;
@property (nonatomic, strong) NSString * endPointLongitude;
@property (nonatomic, strong) NSString * endPointName;

@property (nonatomic, strong) NSString * detailAway;
@property (nonatomic, strong) NSString * detailOil;
@property (nonatomic, strong) NSString * detailTime;

@end
