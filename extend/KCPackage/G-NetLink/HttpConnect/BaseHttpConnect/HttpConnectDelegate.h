//
//  HttpConnectDelegate.h
//  HttpConnect
//
//  Created by 95190 on 13-3-31.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpErrorCode.h"
@class BaseHttpConnect;

@protocol HttpConnectDelegate <NSObject>
-(void) willHttpConnectResquest:(BaseHttpConnect*)httpContent;
-(void)didGetHttpConnectResponseHead:(NSDictionary*)allHead;
-(void) httpConnectResponse:(BaseHttpConnect*)httpContent GetByteCount:(int)byteCount;
//-(void) didHttpConnectSucuss:(BaseHttpConnect*) httpContent;
-(void) didHttpConnectError:(enum HttpErrorCode)errorCode;
-(void) didHttpConnectFinish:(BaseHttpConnect *)httpContent;
//-(void) didTimeout:(BaseHttpConnect *)httpContent;
//-(void) didHttpConnectFail:(int)error;
@end
