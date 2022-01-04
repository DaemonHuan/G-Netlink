//
//  RootViewController.h
//  TOYOTA_ZhijiaX
//
//  Created by jayden on 14-8-1.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseViewController.h"
#import "RootView.h"

@interface RootViewController : BaseViewController<CustomTabBarDelegate>
{
    @private
    NSArray *_viewControllerIDs;
}
- (id)initWithControllerIDs:(NSArray*)ids;
@end
