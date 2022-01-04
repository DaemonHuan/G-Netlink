//
//  TransitPointsObject.h
//  G-NetLink-v2.0
//
//  Created by jk on 4/10/17.
//  Copyright © 2017 jk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MAMapKit/MAMapKit.h>

@interface TransitPointsObject : NSObject

@property (nonatomic, strong) NSString * subtitle;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) CGFloat latitude; //!< 纬度（垂直方向）
@property (nonatomic, assign) CGFloat longitude; //!< 经度（水平方向）

@end
