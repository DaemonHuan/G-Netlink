//
//  jkGuideViewController.h
//  jk-Test-For-Demo
//
//  Created by jk on 1/19/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jkGuideViewController : UIViewController {
    BOOL m_animating;
    IBOutlet UIScrollView * m_pageScroll;
}

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) UIScrollView *pageScroll;

+ (jkGuideViewController *)sharedGuide;

+ (void)show;
+ (void)hide;

@end
