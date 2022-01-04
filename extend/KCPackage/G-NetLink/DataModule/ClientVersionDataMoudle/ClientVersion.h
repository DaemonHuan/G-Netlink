//
//  ClientVersion.h
//  G-NetLink
//
//  Created by jayden on 14-4-22.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"

@interface ClientVersion : BaseDataModule
@property(nonatomic,readonly)NSString *nowVersion;
@property(nonatomic,readonly)NSString *latestVersion;
@property(nonatomic,readonly)NSString *upgrade;
@property(nonatomic,readonly)NSString *introduction;
@property(nonatomic,readonly)NSString *url;
@property(nonatomic,readonly)NSString *versionname;
@property(nonatomic,assign)BOOL autoUpdateFlag;

-(void)getLatestVersion;
-(BOOL)isNeedUpdate;
-(void)setAutoUpdateFlag:(BOOL)autoUpdateFlag;
@end
