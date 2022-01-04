//
//  HttpConnectRespones.h
//  HttpConnect
//
//  Created by 95190 on 13-3-31.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpConnectRespones : NSObject
{
    NSDictionary *_responesHead;
    NSData *_responesData;
}
@property(nonatomic,retain)NSDictionary *responesHead;
@property(nonatomic,retain)NSData *responesData;
@end
