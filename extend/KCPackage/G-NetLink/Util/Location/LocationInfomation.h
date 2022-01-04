//
//  LocationInfo.h
//  ZhiJiaX
//
//  Created by jishu on 13-4-18.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationInfomation : NSObject<NSCopying>
{
   
}

@property(nonatomic,strong)NSString *longitude;
@property(nonatomic,strong)NSString *latitude;
@property(nonatomic,strong)NSString *height;
@property(nonatomic,strong)NSString *localedtime;
@property(nonatomic,strong)NSString *speed;
@property(nonatomic,strong)NSString *direction;
@property(nonatomic,strong)NSString *star;
@property(nonatomic,strong)NSString *descriptionInfo;
@property(nonatomic)int localedType;

- (NSDictionary *)toDic;
- (id)initWithDic:(NSDictionary *)localInfoDic;
-(CGPoint)convertToTubaCoordinate;
+(CGPoint)convertToTubaCoordinate:(CGPoint)coordinate;

@end
