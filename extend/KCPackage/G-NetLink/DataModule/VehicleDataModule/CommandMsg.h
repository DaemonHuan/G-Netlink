//
//  CommandMsg.h
//  G-NetLink
//
//  Created by a95190 on 15/11/18.
//  Copyright © 2015年 95190. All rights reserved.
//

#import "BaseDataModule.h"

@interface CommandMsg : BaseDataModule

@property(nonatomic,copy,readonly)  NSString *uuid;
@property(nonatomic,copy,readonly)  NSString *tuid;
@property(nonatomic,copy,readonly)  NSString *cmdType;
@property(nonatomic,assign,readonly) NSInteger sendState;
@property(nonatomic,copy,readonly)  NSString *sendTime;
@property(nonatomic,assign,readonly) NSInteger executeState;
@property(nonatomic,copy,readonly) NSString *executeDesc;

-(id)initWithDic:(NSDictionary *)dic;

@end
