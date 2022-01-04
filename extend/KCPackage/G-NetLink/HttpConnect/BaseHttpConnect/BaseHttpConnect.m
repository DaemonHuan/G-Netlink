//
//  BaseHttpConnect.m
//  HttpConnect
//
//  Created by 95190 on 13-3-31.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "BaseHttpConnect.h"
#import "HttpHead.h"

@implementation BaseHttpConnect
@synthesize timeOut;
@synthesize respones = _respones;
@synthesize resquestHeads = _resquestHeads;
@synthesize resquestType;
@synthesize url;
@synthesize body;
@synthesize stauts = _stauts;
@synthesize errorCode = _errorCode;

- (id)init
{
    if (self = [super init]) {
        _resquestHeads = [[NSMutableArray alloc] init];
        _respones = [[HttpConnectRespones alloc] init];
        dataBuffer = [[NSMutableData alloc] init];
        body = [[NSMutableData alloc] init];
        _stauts = HttpContentStauts_WillStart;
        _errorCode = HttpErrorCode_None;
    }
    return self;
}

-(void)send
{
    if (_stauts == HttpContentStauts_DidStart) {
        return;
    }
    
    if (timeOut == 0) {
        timeOut = CONNECT_DEFAULT_TIMEOUT;
    }
    
    if (url == nil) {
        return;
    }
    
    NSURL * urlAddress  = [NSURL URLWithString:url];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:urlAddress];
    [urlRequest setHTTPMethod:resquestType];
    if ([resquestType isEqualToString:HTTP_REQUEST_POST]) {
        if (body != nil) {
            if([body isKindOfClass:[NSData class]])
            {
                [urlRequest setHTTPBody:body];
            }
        }
    }
    if (_resquestHeads != nil) {
        for (int index=0; index<_resquestHeads.count; index++)
        {
            NSString* headValue = ((HttpHead*)[_resquestHeads objectAtIndex:index]).headValue;
            if (headValue!=nil && headValue.length>0)
            {
                [urlRequest setValue: headValue forHTTPHeaderField:((HttpHead*)[_resquestHeads objectAtIndex:index]).headName];
            }
        }
    }
//    NSLog(@"^^ %@ %@", url, _resquestHeads);
    
    if (self.observer != nil) {
        [self.observer willHttpConnectResquest:self];
    }
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    if(timeOut!=NO_TIMEOUT)
        timer = [NSTimer scheduledTimerWithTimeInterval:timeOut target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void)closeConnect
{
    [connection cancel];
    [self removeTimer];
}

- (void)onTimer:(id)sender
{
    _stauts = HttpContentStauts_DidStop;
    _errorCode = HttpErrorCode_TimerOut;
    if (self.observer != nil) {
        [self.observer didHttpConnectError:_errorCode];
    }
    [self closeConnect];
}

- (void)removeTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

-(void)cancel
{
    [self closeConnect];
    _stauts = HttpContentStauts_DidStop;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    _stauts = HttpContentStauts_DidStart;
    if (self.observer) {
        [self.observer willHttpConnectResquest:self];
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
// A delegate method called by the NSURLConnection when the request/response
// exchange is complete.  We look at the response to check that the HTTP
// status code is 2xx and that the Content-Type is acceptable.  If these checks
// fail, we give up on the transfer.
{
    assert(theConnection == connection);
    _stauts = HttpContentStauts_DidRespones;
    
    NSHTTPURLResponse * httpResponse;
    assert( [response isKindOfClass:[NSHTTPURLResponse class]] );
    httpResponse = (NSHTTPURLResponse *)response;
    _errorCode = httpResponse.statusCode;
    NSLog(@"the response status code is %d\n",httpResponse.statusCode);
    self.respones.responesHead = [httpResponse allHeaderFields];
    if(self.observer!=nil)
        [self.observer didGetHttpConnectResponseHead:self.respones.responesHead];
}


- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
// A delegate method called by the NSURLConnection as data arrives.  We just
// write the data to the file.
{
    assert(theConnection == connection);
    [dataBuffer appendData:data];
    if(self.observer!=nil)
        [self.observer httpConnectResponse:self GetByteCount:data.length];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
// A delegate method called by the NSURLConnection if the connection fails.
// We shut down the connection and display the failure.  Production quality code
// would either display or log the actual error.
{
    assert(theConnection == connection);
    
    [self closeConnect];
    _stauts = HttpContentStauts_DidStop;
    _errorCode = error.code;
    if (self.observer) {
        [self.observer didHttpConnectError:_errorCode];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
// A delegate method called by the NSURLConnection when the connection has been
// done successfully.  We shut down the connection with a nil status, which
// causes the image to be displayed.
{
    assert(theConnection == connection);
    NSLog(@"the connection is %d",[dataBuffer length]);
    
    _stauts = HttpContentStauts_DidFinishRespones;
    if (self.observer)
    {
        //需要加上业务错误对象判断的机制
        if(_errorCode != HttpErrorCode_None && [resquestType isEqualToString:HTTP_REQUEST_POST])
            [self.observer didHttpConnectError:_errorCode];
        else
        {
            self.respones.responesData = dataBuffer;
            [self.observer didHttpConnectFinish:self];
        }
    }
    [self closeConnect];
}

-(void)dealloc
{
    self.resquestType = nil;
    _respones = nil;
    _resquestHeads = nil;
    self.url = nil;
    self.body = nil;
    dataBuffer = nil;
    connection = nil;
}
@end
