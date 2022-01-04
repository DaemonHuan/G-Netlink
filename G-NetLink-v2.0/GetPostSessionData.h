//
//  GetPostSessionData.h
//
//  Created by jk on 11/10/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

@protocol PostSessionDataDelegate <NSObject>
- (void) didPostSessionRequest:(NSString * __nonnull) request;
@end

@interface GetPostSessionData : NSObject {
    id <PostSessionDataDelegate> delegate;
}

@property(nonatomic, retain) __nullable id<PostSessionDataDelegate>delegate;

- (void) setRequestSpecialTimeoff:(CGFloat) timeoff;
- (void) SendPostSessionRequest:(NSString * __nonnull)urlstr Body:(NSString * __nonnull)body;
- (void) SendPostSessionRequestForKC:(NSString * __nonnull)urlstr Body:(NSDictionary * __nonnull)body;
- (NSDictionary * __nonnull) getDictionaryFromRequest;


@end
