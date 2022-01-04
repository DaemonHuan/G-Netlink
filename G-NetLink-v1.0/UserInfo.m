//
//  UserInfo.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/8/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "UserInfo.h"

@implementation GNLUserInfo

static NSString * m_token = @"0";
static BOOL m_isDemo = NO;
static NSString * m_userName = @"未登录";
static NSString * m_defaultCarVin = nil;
static NSString * m_defaultCarLisence = nil;
static NSString * m_userVin = nil;
static NSString * m_phoneNumber = nil;
static NSString * m_defaultCarType = nil;

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

@end
