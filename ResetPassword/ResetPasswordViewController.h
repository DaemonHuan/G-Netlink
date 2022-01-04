//
//  ResetPasswordViewController.h
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController

@property (nonatomic, retain) NSString * userBrandId;
- (void) setIdentifyValue:(NSString *)name token:(NSString *)token;

@end
