//
//  GetPostSessionData.m
//
//  Created by jk on 11/10/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "GetPostSessionData.h"

@interface GetPostSessionData () <NSURLSessionDataDelegate> {
    NSURLSession * defaultSession;
    NSString * PostRequest;
    NSDictionary *jsonDecFromRequest;
    NSError * PostError;
    CGFloat timedelay;
    
    NSString * mThread_url;
    NSString * mThread_body;
    NSDate * beginTime;
    BOOL isGetting;
    
//    id trustedCerArr;
}
@end

@implementation GetPostSessionData

@synthesize delegate;

- (id) init {
    self = [super init];
    if (self != nil) {
        timedelay = -60.0f;
        isGetting = YES;
        
        
//        //导入客户端证书
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ca" ofType:@"cer"];
//        NSData *data = [NSData dataWithContentsOfFile:cerPath];
//        SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) data);
//        trustedCerArr = @[(__bridge_transfer id)certificate];
//        //发送请求
//        NSURL *testURL = [NSURL URLWithString:@"https://casetree.cn/web/test/demo.php"];
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//        NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:testURL]];
//        [task resume];
    }
    return self;
}

- (void) setRequestSpecialTimeoff:(CGFloat)timeoff {
    timedelay = -1.0f * timeoff;
}

- (void) clearData {
    PostRequest = nil;
    jsonDecFromRequest = nil;
}

- (void) SendPostSessionRequest:(NSString *)urlstr Body:(NSString *)body{
    [self clearData];
    NSLog(@"SEND : %@ - %@", urlstr, body);
    isGetting = YES;
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];

//    defaultConfigObject.TLSMaximumSupportedProtocol = kTLSProtocol1;
    
    defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURL * url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setTimeoutInterval:timedelay];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    [dataTask resume];
}

- (void) SendPostSessionThreadRequest:(NSString *)urlstr Body:(NSString *)body {
    mThread_url = urlstr;
    mThread_body = body;
    isGetting = YES;
    [self clearData];
    
    //    beginTime = [[NSDate date] timeIntervalSince1970];
    beginTime = [[NSDate alloc]init];
    [NSThread detachNewThreadSelector:@selector(newThreadSend:) toTarget:self withObject:nil];
//    NSLog(@"new thread over ..");
}

- (void) newThreadSend: (id)sender {
    NSLog(@"nThread %@ %@", mThread_url, mThread_body);
    @synchronized(self) {
        while (YES) {
            NSLog(@"time -- %lf", [beginTime timeIntervalSinceNow]);
            if ([beginTime timeIntervalSinceNow] < timedelay) {
                [delegate didPostSessionRequest:@"jk-timeout .."];
                break;
            }
            if (isGetting == NO) break;
            [self SendPostSessionRequest:mThread_url Body:mThread_body];
            
            // 暂停 2s
            [NSThread sleepForTimeInterval: 2.0f];
        }
    }
//    [self performSelectorOnMainThread:@selector(endThread) withObject:nil waitUntilDone:YES];
}

// get Functions

- (NSString *) getStringFromRequest {
    return PostRequest;
}

- (NSDictionary *) getDictionaryFromRequest {
    return jsonDecFromRequest;
}

// Function from NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (PostRequest == nil) {
        PostRequest = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        PostRequest = [PostRequest stringByAppendingString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    }

    if (dic != nil && isGetting == YES) {
        if ([[[dic objectForKey:@"status"]objectForKey:@"code"]isEqualToString:@"200"]) {
            isGetting = NO; // 2612 1368 1244
        }
    }
    
    if ([PostRequest isEqualToString:@""]) {
        PostRequest = nil;
    }
//    NSLog(@"Received String %@",PostRequest);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if (PostRequest == nil) {
        NSLog(@"Received String nil %d", isGetting);
        jsonDecFromRequest = nil;
    }
    else {
        NSLog(@"Received String %@ %d",PostRequest, isGetting);
        jsonDecFromRequest = [NSJSONSerialization JSONObjectWithData: [PostRequest dataUsingEncoding: NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: nil];
    }
    
    if (error == nil) {
        if (jsonDecFromRequest == nil) {
            [delegate didPostSessionRequest:@"jk-error .."];
        }
        else {
            [delegate didPostSessionRequest:PostRequest];
        }
        PostRequest = nil;
        jsonDecFromRequest = nil;
    }

    if(error != nil) {
        PostError = error;
        
        [delegate didPostSessionRequest:@"jk-error .."];
        NSLog(@"PostSession Error .. %@", PostError);
    }
    
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
        return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
    
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
            //if ([trustedHosts containsObject:challenge.protectionSpace.host])
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
                 forAuthenticationChallenge:challenge];
        
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
