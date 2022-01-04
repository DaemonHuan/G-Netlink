//
//  HttpStautsCode.h
//  ZhiJiaX
//
//  Created by 95190 on 13-4-27.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpErrorCode.h"
@interface HttpErrorCodeManager : NSObject
+(NSString*)getDesFromErrorCode:(enum HttpErrorCode)code;
@end
