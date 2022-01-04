//
//  GetPostSessionData.m
//
//  Created by jk on 11/10/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "GetPostSessionData.h"
#import "HttpHead.h"
#import <Foundation/NSData.h>

@interface GetPostSessionData () <NSURLSessionDataDelegate> {
    NSURLSession * defaultSession;
    NSString * PostRequest;
    NSDictionary *jsonDecFromRequest;
    NSError * PostError;
    CGFloat timedelay;

    NSMutableData * m_data;
}
@end

@implementation GetPostSessionData

@synthesize delegate;

- (id) init {
    self = [super init];
    if (self != nil) {
        timedelay = 60.0f;
    }
    return self;
}

- (void) clearData {
    PostRequest = nil;
    jsonDecFromRequest = nil;
    m_data = nil;
}

- (void) setRequestSpecialTimeoff:(CGFloat)timeoff {
    timedelay = timeoff;
}

- (void) SendPostSessionRequest:(NSString *)urlstr Body:(NSString *)body {
    [self clearData];
    NSLog(@"** SEND : %@ - %@", urlstr, body);
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURL * url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setTimeoutInterval:timedelay];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    [dataTask resume];
}

- (void) SendPostSessionRequestForKC:(NSString *)urlstr Body:(NSDictionary *)body {
    [self clearData];
    NSLog(@"** SEND : %@ - %@", urlstr, body);
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURL * url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setTimeoutInterval:timedelay];
    [urlRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil]];

    HttpHead * headerContentType = [[HttpHead alloc] init];
    headerContentType.headName = HEADER_CONTENT_TYPE_NAME;
    headerContentType.headValue = HEADER_CONTENT_TYPE_VALUE;
    [urlRequest setValue: headerContentType.headValue forHTTPHeaderField:headerContentType.headName];
    
    HttpHead * headerContentEncoding = [[HttpHead alloc] init];
    headerContentEncoding.headName = HEADER_CONTENT_LENGTH_NAME;
    headerContentEncoding.headValue = HEADER_CONTENT_LENGTH_VALUE;
    [urlRequest setValue: headerContentEncoding.headValue forHTTPHeaderField:headerContentEncoding.headName];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    [dataTask resume];
}

- (NSDictionary *) getDictionaryFromRequest {
    return jsonDecFromRequest;
}

// Function from NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    if (m_data == nil) {
        m_data = [[NSMutableData alloc]initWithData:data];
    }
    else {
        [m_data appendData:data];
    }
    
    PostRequest = [[NSString alloc] initWithData:m_data encoding:NSUTF8StringEncoding];
    NSLog(@"Received String - %@ %zd", PostRequest, [m_data length]);
    
//    if (PostRequest == nil) return;     //
    
//    if (PostRequest == nil) {
//        PostRequest = str;
//    }
//    else {
//        PostRequest = [PostRequest stringByAppendingString: str];
//    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    NSString * ResultRequest = nil;

    if (error == nil) {
        if (PostRequest == nil) {
            ResultRequest = nil;
        }
        else {
            jsonDecFromRequest = [NSJSONSerialization JSONObjectWithData: [PostRequest dataUsingEncoding: NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: nil];
            ResultRequest = PostRequest;
        }

        if (jsonDecFromRequest == nil) {
            ResultRequest = [NSString stringWithFormat:@"jk-Error"];
        }
    }

    // 过滤错误 网络错误
    // 网络断开
    if (NSURLErrorNetworkConnectionLost == error.code) {
        NSLog(@"** The network connection was lost .. %zd", error.code);
        
        ResultRequest = nil;
        [self.delegate didPostSessionRequest:@"NSURLErrorNetworkConnectionLost"];
        return;
    }
    
    if(error != nil) {
        PostError = error;
        NSLog(@"PostSession Error .. %@", PostError);
        ResultRequest = [NSString stringWithFormat:@"jk-Error"];
    }
    
    [self.delegate didPostSessionRequest:ResultRequest];
    ResultRequest = nil;
    
    [self clearData];
}

// HTTPS 服务器证书错误问题
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
    
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
