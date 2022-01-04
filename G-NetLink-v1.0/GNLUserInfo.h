//
//  UserInfo.h
//  G-NetLink-v1.0
//
//  Created by jk on 12/8/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNLUserInfo : NSObject

+(NSString *)accessToken;
+(void)setAccessToken:(NSString *)value;

+(BOOL)isDemo;
+(void)setIsDemo:(BOOL)value;

+(BOOL)isTokenPass;
+(void)setTokenPass:(BOOL)value;

+(NSString *)userName;
+(void)setUserName:(NSString *)value;

+ (NSString *) userID;
+ (void) setUserID:(NSString *)value;

+ (NSString *) defaultCarVin;
+ (void) setDefaultCarVin: (NSString *)value;

+ (NSString *) defaultCarLisence;
+ (void) setDefaultCarLisence:(NSString *)value;

+ (NSString *) defaultCarType;
+ (void) setDefaultCarType:(NSString *)value;

+ (NSString *) userVin;
+ (void) setUserVin: (NSString *) value;

+ (NSString *) phoneNumber;
+ (void) setPhoneNumber: (NSString *) value;

+ (NSString *) vehicleType;
+ (void) setVehicleType: (NSString *) value;

+ (void) selflogout;
+ (void) selflogin;
+ (BOOL) isonline;

// 注销后不自动登录
+ (void) setGoOut:(BOOL)value;
+ (BOOL) isGoOut;

@end
