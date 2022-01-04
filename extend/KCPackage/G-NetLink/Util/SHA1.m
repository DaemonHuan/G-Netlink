//
//  SHA1.m
//  ZhiJiaX
//
//  Created by 95190 on 13-4-10.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "SHA1.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SHA1
+(NSString*)stringConvertSHA1:(NSString*)str
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    const char *cStr = [str UTF8String];
    CC_SHA1(cStr, strlen(cStr), result);
    NSData *pwHashData = [[NSData alloc] initWithBytes:result length: sizeof result];
    
    NSMutableString *pStr = [[NSMutableString alloc] initWithCapacity: 1];
    UInt8 *p = (UInt8*) [pwHashData bytes];
    int len = [pwHashData length];
    for(int i = 0; i < len; i ++)
    {
        if(i%4==0){
            [pStr appendFormat:@"%02x", *(p+i)];
        }else{
            [pStr appendFormat:@"%02x", *(p+i)];
        }
    }
    
    return pStr;
}
@end
