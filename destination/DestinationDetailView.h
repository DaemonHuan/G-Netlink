//
//  DestinationDetailView.h
//  G-Netlink-beta0.2
//
//  Created by jk on 11/5/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DestinationDetailView : UIView {
    UILabel * lb_title1;
    UILabel * lb_title2;
}

- (void) loadView;
- (void) setTitle:(NSString*) title1 title2:(NSString *)title2;
- (void) setGeoPoint:(NSString *)latitude Longitude:(NSString *)longitude;

@end
