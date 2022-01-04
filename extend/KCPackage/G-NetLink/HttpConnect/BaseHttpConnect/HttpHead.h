//
//  HttpHead.h
//  HttpConnect
//
//  Created by 95190 on 13-3-31.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpHead : NSObject
{
    NSString *headName;
    NSString *headValue;
}
@property(nonatomic,retain)NSString *headName;
@property(nonatomic,retain)NSString *headValue;
@end
