//
//  ServicesPro.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/14/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "ServicesPro.h"
#import "public.h"

#define IS_DEMOVIEW_HEIGHT 30.0f
#define IS_DEMOVIEW_TEXT @"模拟运行"

static NSMutableDictionary * m_dicWebError;
static NSMutableDictionary * m_dicViolations;
static NSMutableDictionary * m_dicServerError;

@implementation ServicesPro

+ (void) doCallForHelp {
    //    调用打电话功能
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"tel://%@", @"4000176801"]]];
    //    调用发短信功能
    //    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://10000"]];
}

//调整图片大小
+ (UIImage *) imageScaleToSize:(UIImage *)img size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
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
    
    if ([[m_dicWebError allKeys] containsObject:code]) return @"";
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
    
    if ([[m_dicViolations allKeys] containsObject:code]) return @"";
    NSString * result = [NSString stringWithString:[m_dicViolations objectForKey:code]];
    return result;
}

+ (NSString *) getServerErrorMessage:(NSString *)code {
    if (m_dicServerError == nil) {
        m_dicServerError = [[NSMutableDictionary alloc] init];
        
        [m_dicServerError setObject:@"服务器返回错误的JSON串" forKey:@"201"];
        [m_dicServerError setObject:@"HTTP请求错误" forKey:@"202"];
        [m_dicServerError setObject:@"没有返回结果" forKey:@"204"];
    }
    
    if ([[m_dicServerError allKeys] containsObject:code]) return @"";
    NSString * result = [NSString stringWithString:[m_dicServerError objectForKey:code]];
    return result;
}

+ (UIView *) loadMarkDemoView {
    UIView * thisView = [[UIView alloc]init];
    thisView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    CGFloat ax = [UIScreen mainScreen].bounds.size.height - IS_DEMOVIEW_HEIGHT;
    CGFloat wx = [UIScreen mainScreen].bounds.size.width;
    NSLog(@"%f %f", ax, wx);
    
    thisView.frame = CGRectMake(0, ax, wx, IS_DEMOVIEW_HEIGHT);
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, wx, 2.0f)];
    [image setImage: [UIImage imageNamed:@"public_seperateline01"]];
    [thisView addSubview: image];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(wx/2.0f - 45.0f, 5.0f, 70.0f, 20.0f)];
    [title setText: IS_DEMOVIEW_TEXT];
    [title setTextColor: [UIColor whiteColor]];
    [title setFont: [UIFont fontWithName:FONT_XI size:17.0f]];
    [thisView addSubview: title];
    
//    UIImageView * imageup = [[UIImageView alloc] initWithFrame:CGRectMake(wx/2.0f + 35.0f, 10.0f, 15.0f, 10.0f)];
//    [imageup setImage: [UIImage imageNamed:@"home_up"]];
//    [thisView addSubview: imageup];
    
    return thisView;
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
    //    NSLog(@"** %@", date);
    if (date.description == nil) return nil;
    
    NSInteger interval = [local secondsFromGMTForDate: date];
    NSDate * localedate = [date dateByAddingTimeInterval: interval];
    return localedate;
}

@end
