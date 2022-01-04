//
//  HttpHead.h
//  HttpConnect
//
//  Created by 95190 on 13-3-31.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#define HEADER_CONTENT_TYPE_NAME      @"Content-Type"
#define HEADER_CONTENT_TYPE_VALUE     @"application/json;charset=utf-8"

#define HEADER_CONTENT_LENGTH_NAME      @"Content-Length"
#define HEADER_CONTENT_LENGTH_VALUE     @"0"

#import <Foundation/Foundation.h>

@interface HttpHead : NSObject
{
    NSString *headName;
    NSString *headValue;
}
@property(nonatomic,retain)NSString *headName;
@property(nonatomic,retain)NSString *headValue;
@end
