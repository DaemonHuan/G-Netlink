//
//  ViewsManager.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/22/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "ViewsManager.h"

@implementation ViewsManager {
    ViewsDiscription _discription;
}

- (void) setCurrentViewDiscription:(ViewsDiscription) dis {
    _discription = dis;
}

- (ViewsDiscription) gCurrentViewDiscription {
    return _discription;
}

@end
