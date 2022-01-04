//
//  ProcessBoxCommandView.h
//  G-NetLink-v2.0
//
//  Created by jk on 4/27/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessBoxCommandView : UIView

- (id) initWithMessage: (NSString *)title;

- (void) showView;
- (void) hideView;

- (void) setTitile: (NSString *)titile;

@end
