//
//  BaseBusiness.m
//  G_NetLink
//
//  Created by 95190 on 14-3-20.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseBusiness.h"
#import "BaseBusinessHttpConnect.h"
#import "BusinessHttpConnectWithNtspHeader.h"
#import "HttpErrorCodeManager.h"

@implementation BaseBusiness
@synthesize businessId = _businessId;
@synthesize businessErrorType = _businessErrorType;
@synthesize baseBusinessHttpConnect = _baseBusinessHttpConnect;
@synthesize errmsg = _errmsg;
@synthesize errCode = _errCode;

- (id)init
{
    if (self = [super init]) {
        self.baseBusinessHttpConnect = [[BaseBusinessHttpConnect alloc] init];
    }
    return self;
}

- (id)initWithNtspHeader
{
    if (self = [super init]) {
        self.baseBusinessHttpConnect = [[BusinessHttpConnectWithNtspHeader alloc] init];
    }
    return self;
}


- (void)execute:(NSDictionary *)theParm
{
    if(theParm!=nil)//可能有无参数的情况：例如注销登录
    {
        if (![NSJSONSerialization isValidJSONObject:theParm])
            return;
    }
    
    if (self.baseBusinessHttpConnect) {
        self.baseBusinessHttpConnect.observer = self;
        [self.baseBusinessHttpConnect sendWithParam:theParm];
    }
}

- (void)cancel
{
    if (self.baseBusinessHttpConnect) {
        [self.baseBusinessHttpConnect cancel];
    }
}

//简单解析为dic
- (NSDictionary *)parseBaseBusinessHttpConnectResponseData
{
    NSError * error;
    if (self.baseBusinessHttpConnect.respones.responesData) {
        return [NSJSONSerialization JSONObjectWithData:self.baseBusinessHttpConnect.respones.responesData options:NSJSONReadingMutableContainers error:&error];
    }else{
        return nil;
    }
}


//获取错误码
- (void)errorCodeFromResponse:(NSDictionary *)theResponseBody
{
    if (theResponseBody) {
        if ([theResponseBody isKindOfClass:[NSDictionary class]]) {
            _errCode = [[theResponseBody objectForKey:@"errcode"] integerValue];
            _errmsg = [theResponseBody objectForKey:@"errmsg"];
        }
    }
    switch (_errCode) {
        case NO_ERROR:
            self.businessErrorType = REQUEST_NOERROR;
            break;
        case TIME_ERROR:
            self.businessErrorType = REQUEST_TIME_ERROR;
            break;
        case SYSTEM_ERROR:
            self.businessErrorType = REQUEST_SYSTEM_ERROR;
            break;
        case AUTH_ERROR:
            self.businessErrorType = REQUEST_AUTH_ERROR;
            break;
        case PARAM_ERROR:
            self.businessErrorType = REQUEST_PARAM_ERROR;
            break;
        default:
            break;
    }
}

-(void) willHttpConnectResquest:(BaseHttpConnect*)httpContent
{
}

-(void) httpConnectResponse:(BaseHttpConnect*)httpContent GetByteCount:(int)byteCount
{
}
-(void)didGetHttpConnectResponseHead:(NSDictionary*)allHead
{
    
}

//-(void) didHttpConnectSucuss:(BaseHttpConnect*) httpContent
//{
//}

-(void) didHttpConnectError:(enum HttpErrorCode)errorCode
{
    if (self.businessObserver)
    {
        _errmsg = [HttpErrorCodeManager getDesFromErrorCode:errorCode];
        [self.businessObserver didBusinessError:self];
    }
}

-(void) didHttpConnectFinish:(BaseHttpConnect *)httpContent
{
    NSDictionary * responseBodyDic = [self parseBaseBusinessHttpConnectResponseData];
    
#ifdef DEBUG_LOG
    NSLog(@"Reseive : %@",responseBodyDic);
#endif
    if (responseBodyDic) {
        [self errorCodeFromResponse:responseBodyDic];
        if(_errCode == REQUEST_NOERROR)
        {
            //不需要"errcode"和"errmsg"的数据，数据通过getNtspHeaderFromBaseBusinessHttpConnectResponseData取得
            [((NSMutableDictionary*)responseBodyDic) removeObjectForKey:@"errcode"];
            [((NSMutableDictionary*)responseBodyDic) removeObjectForKey:@"errmsg"];
        }
        else if(_errCode >= TIME_ERROR || _errCode <= REQUEST_PARAM_ERROR)
        {
            [self.businessObserver didBusinessError:self];
            return;
        }
    }
    [self.businessObserver didBusinessSucess:self withData:responseBodyDic];
}

//-(void) didTimeout:(BaseHttpConnect *)httpContent
//{
//    if (self.businessObserver) {
//        [self.businessObserver didBusinessError:self];
//    }
//}

-(void)dealloc
{
    self.baseBusinessHttpConnect.observer = nil;
}
@end
