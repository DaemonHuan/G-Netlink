//
//  jkProcessView.h
//  G-NetLink-v1.0
//
//  Created by jk on 2/25/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jkProcessView : UIView

- (id) initWithMessage:(NSString *)title;

- (void) toshow;
- (void) tohide;

- (void) setTitile:(NSString *)titile;

@end
