//
//  ViewsManager.h
//  G-NetLink-v2.0
//
//  Created by jk on 3/22/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ViewsDiscription) {
    ViewsDiscriptionLogin = 0,
    ViewsDiscriptionIndex,
};

@interface ViewsManager : NSObject

- (void) setCurrentViewDiscription:(ViewsDiscription) dis;
- (ViewsDiscription) gCurrentViewDiscription;

@end
