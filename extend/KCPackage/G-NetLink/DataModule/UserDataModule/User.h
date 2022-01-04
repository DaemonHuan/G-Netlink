//
//  User.h
//  G-NetLink
//
//  Created by jayden on 14-4-14.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"
#import "UserInfo.h"


enum UserLoginStatus
{
    UserLoginStatus_NoLogin = 0,
    UserLoginStatus_Login,
    UserLoginStatus_Logout
};

@interface User : BaseDataModule
@property (nonatomic,readonly)NSString  *mobileNumber;
@property (nonatomic,readonly)NSString  *password;
@property (nonatomic,readonly)NSString  *accesst_token;
@property (nonatomic,readonly)NSString  *uuid;
@property (nonatomic,readonly)NSString  *tuid;
@property (nonatomic,readonly)UserInfo  *userInfo;
@property(nonatomic,readonly,assign)enum UserLoginStatus userLoginStatus;
@property(nonatomic,assign)BOOL autoLoginFlag;
@property(nonatomic,assign)BOOL rememberFlag;
@property(nonatomic,assign)BOOL wifiCheck;
@property (nonatomic,readonly)NSString *loginCount;
@property (nonatomic,readonly)NSArray  *phoneNumberArray;
@property  (nonatomic,readonly,assign)NSInteger  phone_num;
+(User*)shareUser;
-(void)login:(NSString  *)mobileNumber withPassword:(NSString  *)password;
-(void)logout;
-(void)commitFeed:(NSString  *)feed withContract:(NSString  *)contact;
-(void)setAutoLoginFlag:(BOOL)autoLogin;
-(void)setRememberFlag:(BOOL)remember;
-(void)getLoginCount;
-(void)getMobilePhone;
-(void)removeMobilePhone:(NSString * )phoneNumber;
-(void)bindingMobilePhone:(NSString * )phoneNumber;
@end
