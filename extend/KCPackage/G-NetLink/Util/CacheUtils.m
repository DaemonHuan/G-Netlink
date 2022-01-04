//
//  CacheUtils.m
//  ZhiJiaX
//
//  Created by jishu on 13-4-12.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "CacheUtils.h"

@implementation CacheUtils

//写入文件格式用json_data
+(BOOL)writeFile:(NSData *)data withFilePath:(NSString *)filePath 
{
    if ([data writeToFile:filePath atomically:YES]) {
        return YES;
    }else{
        return NO;
    }
}

//读取文件格式用json_data
+(NSData *)readFileWithFilePath:(NSString *)userName
{
    NSFileManager * file = [NSFileManager defaultManager];
    if ([file fileExistsAtPath:userName]) {
        return [file contentsAtPath:userName];
    }else{
        return nil;
    }
}

//获取cache 文件路径
+(NSString *)cacheFilePath
{
    NSFileManager * file = [NSFileManager defaultManager];
    
    NSArray * urls = [file URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL * urlCachePath = [urls objectAtIndex:0];
    return [urlCachePath path];
}


@end
