//
//  BaseHttpConnect.h
//  HttpConnect
//
//  Created by 95190 on 13-3-31.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpHead.h"
#import "HttpConnectRespones.h"
#import "HttpConnectDelegate.h"
#import "HttpErrorCode.h"

#define HTTP_REQUEST_GET  @"GET"
#define HTTP_REQUEST_POST @"POST"
#define     CONNECT_DEFAULT_TIMEOUT     30
#define     NO_TIMEOUT     -1

enum HttpContentStauts
{
    HttpContentStauts_DidStart = 1,
    HttpContentStauts_DidStop,
    HttpContentStauts_WillStart,
    HttpContentStauts_WillStop,
    HttpContentStauts_WillRespones,
    HttpContentStauts_DidRespones,
    HttpContentStauts_DidFinishRespones,
};

@interface BaseHttpConnect : NSObject
{
    int timeOut;
    NSString *url;
    NSMutableArray *_resquestHeads;
    NSMutableData * body;
    NSString *resquestType;
    HttpConnectRespones *_respones;
    NSURLConnection *connection;
    NSTimer * timer;
    enum HttpContentStauts _stauts;
    NSMutableData * dataBuffer;
    int _errorCode;
}
@property int timeOut;
@property(readonly) int errorCode;
@property (nonatomic,readonly)enum HttpContentStauts stauts;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,readonly)NSMutableArray *resquestHeads;//HttpHead Type
@property(nonatomic,retain)NSMutableData * body;
@property(nonatomic,copy)NSString *resquestType;
@property(nonatomic,readonly)HttpConnectRespones *respones;
@property(nonatomic,assign)id<HttpConnectDelegate> observer;

-(void)send;
-(void)cancel;
- (void)closeConnect;
@end
