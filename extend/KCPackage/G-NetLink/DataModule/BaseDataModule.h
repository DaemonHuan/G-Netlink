//
//  BaseDataModule.h
//  MessageFrame
//
//  Created by 95190 on 13-4-7.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModuleDelegate.h"

#import "BaseBusiness.h"
@interface BaseDataModule : NSObject<BusinessProtocl>
{
@protected
    BaseBusiness *baseBusiness;
}
@property(nonatomic,assign)id<DataModuleDelegate> observer;
- (void)creatBusinessWithId:(NSInteger)businessId andExecuteWithData:(NSDictionary *)dic;
- (void)creatBusinessWithId:(NSInteger)businessId andObserver:(id<BusinessProtocl>)observer andExecuteWithData:(NSDictionary *)dic;
;
@end
