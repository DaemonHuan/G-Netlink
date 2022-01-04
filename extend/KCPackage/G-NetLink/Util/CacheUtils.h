//
//  CacheUtils.h
//  ZhiJiaX
//
//  Created by jishu on 13-4-12.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheUtils : NSObject

+(BOOL)writeFile:(NSData *)data withFilePath:(NSString *)filePath;
+(NSData *)readFileWithFilePath:(NSString *)userName;
+(NSString *)cacheFilePath;

@end
