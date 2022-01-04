//
//  UserInfo.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/8/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "GNLUserInfo.h"

@implementation GNLUserInfo

static NSString * m_token = @"0";
static BOOL m_isDemo = NO;
static BOOL m_online = YES;
static bool m_isTokenPass = NO;
static NSString * m_userName = @"未登录";
static NSString * m_userID = nil;
static NSString * m_defaultCarVin = nil;
static NSString * m_defaultCarLisence = nil;
static NSString * m_userVin = nil;
static NSString * m_phoneNumber = nil;
static NSString * m_defaultCarType = nil;

static bool m_isGoOut = YES;

+(NSString *)accessToken {
    return m_token;
}

+(void)setAccessToken:(NSString *)value {
    m_token = value;
}

+(BOOL)isDemo {
    return m_isDemo;
}

+(void)setIsDemo:(BOOL)value {
    m_isDemo = value;
}

+(BOOL)isTokenPass {
    return m_isTokenPass;
}

+(void)setTokenPass:(BOOL)value {
    m_isTokenPass = value;
}

+(NSString *)userName {
    return m_userName;
}

+(void)setUserName:(NSString *)value {
    m_userName = value;
}

+ (NSString *) defaultCarVin {
    return m_defaultCarVin;
}
+ (void) setDefaultCarVin: (NSString *)value {
    m_defaultCarVin = value;
}

+ (NSString *) defaultCarLisence {
    return m_defaultCarLisence;
}
+ (void) setDefaultCarLisence:(NSString *)value {
    m_defaultCarLisence = value;
}

+ (NSString *) defaultCarType {
    return m_defaultCarType;
}
+ (void) setDefaultCarType:(NSString *)value {
    m_defaultCarType = value;
}

+ (NSString *) userVin{
    return m_userVin;
}
+ (void) setUserVin: (NSString *) value {
    m_userVin = value;
}

+ (NSString *) phoneNumber {
    return m_phoneNumber;
}
+ (void) setPhoneNumber: (NSString *) value {
    m_phoneNumber = value;
}

+ (NSString *) userID {
    return m_userID;
}
+ (void) setUserID:(NSString *)value {
    m_userID = value;
}


+ (void) selflogout {
    m_token = @"0";
    m_isDemo = NO;
    m_userName = @"未登录";
    m_defaultCarVin = nil;
    m_defaultCarLisence = nil;
    m_userVin = nil;
    m_phoneNumber = nil;
    m_defaultCarType = nil;
    
    m_online = NO;
}

+ (BOOL) isonline {
    return m_online;
}

+ (void) selflogin {
    m_online = YES;
}

+ (void) setGoOut :(BOOL)value {
    m_isGoOut = value;
}
+ (BOOL) isGoOut {
    return m_isGoOut;
}

@end
