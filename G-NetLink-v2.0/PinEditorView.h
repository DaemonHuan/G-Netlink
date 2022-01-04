//
//  PinEditorView.h
//  G-NetLink-v2.0
//
//  Created by jk on 4/6/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinEditorView : UIView {
    
}

@property (nonatomic, retain) UIButton * bt_OK;
@property (nonatomic, retain) UIButton * bt_NO;
@property (nonatomic, retain) NSString * code;

- (void) showView;
- (void) hideView;

@end
