//
//  SlideMenuView.h
//  G-NetLink-v1.0
//
//  Created by jk on 12/7/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideMenuActionDelegate <NSObject>
- (void) doSlideMenuActions:(NSString *) code;
@end

@interface SlideMenuView : UIView {
    id<SlideMenuActionDelegate> delegate;
}

@property(nonatomic, retain) id<SlideMenuActionDelegate> delegate;

- (id) initWithContainView;
- (void) show;

- (void) setMessageForTitle: (NSString *)username carlisence: (NSString *) code;

@end
