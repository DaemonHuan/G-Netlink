//
//  jkAlertController.h
//
//  Created by jk on 11/23/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface jkAlertController : UIView

@property(nonatomic, retain) UIView * centerView;

@property (nonatomic, copy) dispatch_block_t okBlock;
@property (nonatomic, copy) dispatch_block_t exBlock;

- (id) initWithTitle:(NSString *) title CenterLabel:(NSString *)msg Enter:(NSString *)btOK Cancle:(NSString *)btEX;
- (id) initWithOKButton:(NSString *)msg;
- (id) initWithNOButton: (NSString *) msg;
- (id) initWithLoadingGif: (NSString *) msg;

- (void) show;
- (void) close;

@end
