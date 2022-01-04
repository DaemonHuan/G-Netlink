//
//  JPushNotification.h
//  G-NetLink
//
//  Created by jayden on 14-5-7.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "PushNotification.h"

@interface JPushNotification : PushNotification
-(void)registerUserTags:(NSSet *)tags andAlias:(NSString*)alias callbackSelector:(SEL) sel target:(id)observer;
-(void)resetJpushApplicationBadgeNumber;
@end
