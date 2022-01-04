//
//  VehicleInfoViewController.h
//  G-NetLink-v1.0
//
//  Created by jk on 12/14/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleInfoViewController : UIViewController {
}

@property (nonatomic, retain) NSString * ttCode;
@property (nonatomic, retain) NSString * ttType;
@property (nonatomic, retain) NSString * ttColor;
@property (nonatomic, retain) NSString * ttVin;

- (void) setThisValue: (NSString *)code Type:(NSString *)type Color:(NSString *)color;

@end
