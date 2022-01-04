//
//  StringUtils.h
//  ZhiJiaX
//
//  Created by jishu on 13-5-27.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(StringUtil)
-(BOOL)isValidateEmail;
-(BOOL)isValidateMobile;
- (BOOL)isValidateCall;
-(BOOL)isValidateCarNo;

-(BOOL) isValidateMobileLevel1;
-(BOOL) isValidateMobileLevel0;


-(BOOL) isValidateZip;

-(BOOL) isValidateZJ;
-(BOOL) isValidateUserName;
-(BOOL) isValidateAreaName;
-(BOOL) isValidatelat;
-(BOOL) isValidatelot;
-(BOOL) isValidateTotalMiles;
-(BOOL) isValidateIdentity;
-(BOOL) isValidateNumber;
-(BOOL) isValidatePassword;

@end
