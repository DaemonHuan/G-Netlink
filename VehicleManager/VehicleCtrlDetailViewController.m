//
//  VehicleCtrlDetailViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 6/17/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "VehicleCtrlDetailViewController.h"

@interface VehicleCtrlDetailViewController ()

@end

@implementation VehicleCtrlDetailViewController {
    IBOutlet UILabel * la_exec;
    IBOutlet UILabel * la_time;
    IBOutlet UILabel * la_result;
    IBOutlet UILabel * la_detail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"控制详情";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [la_exec setText: self.exec];
    [la_time setText: self.time];
    [la_result setText: self.result];
    [la_detail setText: self.detail];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
