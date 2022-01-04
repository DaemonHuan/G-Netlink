//
//  ViewControllerPathManager.h
//  ZhiJiaX
//
//  Created by 95190 on 13-6-6.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeAndViewControllerID.h"

@interface ViewControllerPathManager : NSObject
{
}
+(void)addViewControllerID:(NSNumber*)viewControllerID;
+(NSNumber*)getCurrentViewControllerID;
+(NSNumber*)getPreviousViewControllerID;
+(NSNumber*)getPreviousViewControllerIDWithDelete;
+(void)deleteViewControllerID:(NSNumber*)viewControllerID;
+(void)deleteAllViewControllerID;
+(void)deleteLastViewControllerID;
+(void)deleteViewControllerFromIDLater:(NSNumber*)viewControllerID;
@end
