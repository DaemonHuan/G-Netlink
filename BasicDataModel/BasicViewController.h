//
//  BasicViewController.h
//  G-NetLink-v2.0
//
//  Created by jk on 3/17/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformations.h"
#import "ViewsManager.h"
#import "MainNavigationController.h"

@interface BasicViewController : UIViewController

- (void) setCurrentViewControllerFlag:(ViewsDiscription) flag;
- (NSDictionary *) fixDictionaryForKCSession: (NSDictionary *)dict;
- (NSDictionary *) fetchPostSession:(NSString *)str Body:(NSString *)body;
- (NSDictionary *) fetchPostSessionForKC:(NSString *)str Body:(NSDictionary *)dict;

- (void) clearDataForUser;

@property (nonatomic, strong) UserInformations * UserInfo;
@property (nonatomic, strong) ViewsManager * ViewsManager;
@property (nonatomic, assign) ViewsDiscription thisflag;
@property (nonatomic, strong) UIView * demoLogoView;

@property (nonatomic, strong) NSString * userfixstr;
@property (nonatomic, strong) NSArray * vehicletypes;
@property (nonatomic, strong) NSArray * vehicletypesforKC;
@property (nonatomic, assign) BOOL flagForViewHidden;


@end
