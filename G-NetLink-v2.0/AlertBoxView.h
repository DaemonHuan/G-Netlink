//
//  AlertBoxView.h
//  G-NetLink-v2.0
//
//  Created by jk on 3/18/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertBoxView : UIView

@property(nonatomic, retain) UIView * centerView;

@property (nonatomic, copy) dispatch_block_t okBlock;
@property (nonatomic, copy) dispatch_block_t exBlock;

- (id) initWithTitle:(NSString *)msg Enter:(NSString *)btOK Cancle:(NSString *)btEX;
- (id) initWithOKButton:(NSString *)msg;

- (void) show;
- (void) close;

@end
