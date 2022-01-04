//
//  ExtendStaticFunctions.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/18/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "ExtendStaticFunctions.h"
#import <UIKit/UIApplication.h>

static NSMutableDictionary * m_dicWebError;
static NSMutableDictionary * m_dicViolations;
static NSMutableDictionary * m_dicServerError;

@interface ExtendStaticFunctions ()

@end

@implementation ExtendStaticFunctions {
    
}

+ (void) doCallForHelp: (NSString *) code {
    //    调用打电话功能
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"tel://%@", code]]];
    //    调用发短信功能
    //    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://10000"]];
}

+ (void) doCallForKCHelp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"tel://%@", @"0571-28815911"]]];
}

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//
+ (NSString *) getWebErrorMessage:(NSString *)code {
    if (m_dicWebError == nil) {
        m_dicWebError = [[NSMutableDictionary alloc]init];
        [m_dicWebError setObject:@"Success" forKey:@"200"];
        [m_dicWebError setObject:@"Failed,the response code is for querying processing request, according to the request parameters, if there is no record then returns this code." forKey:@"204"];
        [m_dicWebError setObject:@"Failed,server capacity reach its limit, unable to handle the request." forKey:@"206"];
        [m_dicWebError setObject:@"Failed,request message does not match to the protocol specification.Protocol body length is wrong or some must items is not completed." forKey:@"400"];
        [m_dicWebError setObject:@"Failed,request message does not match to the protocol specification.Request parameter values of the wrong format." forKey:@"401"];
        [m_dicWebError setObject:@"Failed,user authentication has error." forKey:@"402"];
        [m_dicWebError setObject:@"Failed,user service is disabled, unable to use the service." forKey:@"403"];
        [m_dicWebError setObject:@"Failed,user dose not buy packages, unable to use the service." forKey:@"404"];
        [m_dicWebError setObject:@"Failed,data is sent to VHL failed." forKey:@"405"];
        [m_dicWebError setObject:@"Failed,RequestID of new Event can not be repeated." forKey:@"406"];
        [m_dicWebError setObject:@"Timeout." forKey:@"407"];
        [m_dicWebError setObject:@"Failed,POI can not be repeated." forKey:@"408"];
        [m_dicWebError setObject:@"Failed,server internal error." forKey:@"500"];
        [m_dicWebError setObject:@"Failed,server database connect failed." forKey:@"501"];
        [m_dicWebError setObject:@"Failed,network user authentication failed." forKey:@"502"];
        [m_dicWebError setObject:@"Failed,response object is null." forKey:@"503"];
    }
    
    if (![[m_dicWebError allKeys] containsObject:code]) return @"";
    NSString * result = [NSString stringWithString:[m_dicWebError objectForKey:code]];
    return result;
}

+ (NSString *) getViolationMessage:(NSString *)code {
    if (m_dicViolations == nil) {
        m_dicViolations = [[NSMutableDictionary alloc]init];
        
        [m_dicViolations setObject:@"非法请求" forKey:@"1"];
        [m_dicViolations setObject:@"未知错误" forKey:@"2"];
        [m_dicViolations setObject:@"验证码错误,请重试" forKey:@"201"];
        [m_dicViolations setObject:@"车牌号错误,请核对" forKey:@"202"];
        [m_dicViolations setObject:@"发动机号错误,请核对" forKey:@"203"];
        [m_dicViolations setObject:@"车架号错误,请核对" forKey:@"204"];
        [m_dicViolations setObject:@"车主姓名错误,请核对" forKey:@"205"];
        [m_dicViolations setObject:@"身份证号错误,请核对" forKey:@"206"];
        [m_dicViolations setObject:@"登记证书编号错误,请核对" forKey:@"207"];
        [m_dicViolations setObject:@"用户名或密码错误,请核对" forKey:@"208"];
        [m_dicViolations setObject:@"输入信息有误,请核对" forKey:@"209"];
        [m_dicViolations setObject:@"未找到满足条件的车辆" forKey:@"210"];
        [m_dicViolations setObject:@"验证码获取失败" forKey:@"301"];
        [m_dicViolations setObject:@"交管局服务器暂时无法连接,请稍后再试" forKey:@"302"];
        [m_dicViolations setObject:@"交管局服务器繁忙,请稍后再试" forKey:@"303"];
        [m_dicViolations setObject:@"sign错误" forKey:@"401"];
        [m_dicViolations setObject:@"权限不足" forKey:@"402"];
        [m_dicViolations setObject:@"单日调用量超限" forKey:@"403"];
        [m_dicViolations setObject:@"总调用量超限" forKey:@"404"];
        [m_dicViolations setObject:@"参数格式错误" forKey:@"501"];
        [m_dicViolations setObject:@"系统没有该车牌所对应的城市/该车牌所对应的城市暂不支持查询" forKey:@"502"];
    }
    
    if (![[m_dicViolations allKeys] containsObject:code]) return @"";
    NSString * result = [NSString stringWithString:[m_dicViolations objectForKey:code]];
    return result;
}

+ (NSString *) getServerErrorMessage:(NSString *)code {
    if (m_dicServerError == nil) {
        m_dicServerError = [[NSMutableDictionary alloc] init];
        
        [m_dicServerError setObject:@"数据错误,请重新获取。" forKey:@"201"];        // @"服务器返回错误的JSON串"
        [m_dicServerError setObject:@"数据错误,请重新获取。" forKey:@"202"];      // HTTP请求错误
        [m_dicServerError setObject:@"数据错误,请重新获取。" forKey:@"204"];      // 没有返回结果
        [m_dicServerError setObject:@"当前账户登录时效已过期,\n请重新登录。" forKey:@"402"];
        [m_dicServerError setObject:@"服务器错误,请重试。" forKey:@"500"];
        [m_dicServerError setObject:@"密码错误,\n请重新登录。" forKey:@"505"];
        [m_dicServerError setObject:@"用户不存在,\n请重新登录。" forKey:@"504"];
    }
    
    if (![[m_dicServerError allKeys] containsObject:code]) return @"数据错误,请重试。";
    NSString * result = [NSString stringWithString:[m_dicServerError objectForKey:code]];
    return result;
}

// 保密字符串
+ (NSString *) stringReplaceWithStar:(NSString *) str {
    if (str == nil || [str isEqualToString:@""]) {
        return nil;
    }
    
    NSRange strRange = NSMakeRange(2, [str length] - 5);
    NSString * res = [[NSString alloc]initWithString:[str stringByReplacingCharactersInRange:strRange withString:@"****"]];
    return res;
}

+ (NSDate *) toLocalTime:(NSString *) stime {
    NSTimeZone* gtm = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSTimeZone* local = [NSTimeZone localTimeZone];
    
    NSDateFormatter * dateformat = [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateformat setTimeZone: gtm];
    
    NSDate * date = [dateformat dateFromString:stime];
    if (date.description == nil) return nil;
    
    NSInteger interval = [local secondsFromGMTForDate: date];
    NSDate * localedate = [date dateByAddingTimeInterval: interval];
    return localedate;
}

+ (void) doSetUserDefaults:(NSString *)str withKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject: str forKey: key];
    [userDefault synchronize];
}

+ (NSString *) getUserDefaultsWithKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString * res = [userDefault objectForKey: key];
    [userDefault synchronize];
    
    return res;
}

+ (void) doRemoveDefaultsWithKey: (NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey: key];
    [userDefault synchronize];
}

@end
