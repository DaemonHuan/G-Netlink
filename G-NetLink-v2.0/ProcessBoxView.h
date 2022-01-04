//
//  ProcessBoxView.h
//  G-NetLink-v2.0
//
//  Created by jk on 3/18/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessBoxView : UIView

- (id) initWithMessage: (NSString *)title;

- (void) showView;
- (void) hideView;

- (void) setTitile: (NSString *)titile;

@end
