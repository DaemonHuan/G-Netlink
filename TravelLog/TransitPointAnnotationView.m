//
//  TransitPointAnnotationView.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/11/17.
//  Copyright © 2017 jk. All rights reserved.
//

#import "TransitPointAnnotationView.h"

@implementation TransitPointAnnotationView

#define kCalloutWidth       180.0
#define kCalloutHeight      120.0

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected) {
        return;
    }
    
    if (selected) {
        if (self.calloutView == nil)
        {
            // 初始化 CalloutView
            CGRect frame = CGRectMake(self.calloutOffset.x - 12.0f, self.calloutOffset.y - kCalloutHeight, kCalloutWidth, kCalloutHeight);
            self.calloutView = [[CustomCalloutView alloc] initWithFrame: frame];
        }

        //
        NSLog(@"** Annotation : \n ** title:%@ \n ** subtitle:%@", self.annotation.title, self.annotation.subtitle);
        [self.calloutView setTitle: self.annotation.title];
        [self.calloutView setSubTitle: self.annotation.subtitle];
        
        [self addSubview:self.calloutView];
    }
    else {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
