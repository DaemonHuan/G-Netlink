//
//  VehicleInfoViewController.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/14/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "VehicleInfoViewController.h"
#import "public.h"
#import "GNLUserInfo.h"
#import "jkAlertController.h"
#import "MainNavigationController.h"

@interface VehicleInfoViewController ()

@end

@implementation VehicleInfoViewController {
    IBOutlet UILabel * la_num;
    IBOutlet UILabel * la_type;
    IBOutlet UILabel * la_color;
    IBOutlet UIButton * bt_setdefault;
}

@synthesize ttCode, ttColor, ttType, ttVin;

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%@ %@ %@", self.ttType, self.ttCode, self.ttColor);
    
     self.navigationItem.title = self.ttCode;
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    [la_num setFont: [UIFont fontWithName:FONT_XI size: 18.0f]];
    [la_num setText: self.ttCode];
    [la_type setFont: [UIFont fontWithName:FONT_XI size: 18.0f]];
    [la_type setText: self.ttType];
    [la_color setFont: [UIFont fontWithName:FONT_XI size: 18.0f]];
    [la_color setText: self.ttColor];
    
    if ([GNLUserInfo isDemo]) {
        [self.view addSubview: [ServicesPro loadMarkDemoView]];
    }
}

- (void) setThisValue: (NSString *)code Type:(NSString *)type Color:(NSString *)color {
    [la_num setText: code];
    [la_type setText: type];
    [la_color setText: color];
    self.navigationController.title = code;
}

- (IBAction) doSetDefaultCar:(id)sender {
    NSLog(@"do default car ..");
    [GNLUserInfo setDefaultCarVin: self.ttVin];
    [GNLUserInfo setDefaultCarLisence: self.ttCode];
    
    MainNavigationController * main = (MainNavigationController *)self.navigationController;
    [main setTtilelisence];
    
    jkAlertController * view = [[jkAlertController alloc] initWithOKButton:@"设置已生效。"];
    view.okBlock = ^() {
        [self.navigationController popViewControllerAnimated:YES];
    };
    [view show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
