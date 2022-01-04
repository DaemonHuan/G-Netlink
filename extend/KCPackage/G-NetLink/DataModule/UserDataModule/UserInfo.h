//
//  UserInfo.h
//  G-NetLink
//
//  Created by jayden on 14-4-14.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"

@interface UserInfo : BaseDataModule
@property (nonatomic,readonly)NSString  *realname;
@property (nonatomic,readonly)NSString  *gender;
@property (nonatomic,readonly)NSString  *certificate_num;
@property (nonatomic,readonly)NSString  *mobilephone;
-(void)getInfo;
-(void)updateMobilePhone:(NSString *)newMoblePhone;
@end
