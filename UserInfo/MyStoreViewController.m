//
//  MyStoreViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "MyStoreViewController.h"
#import "public.h"

@interface MyStoreViewController ()

@end

@implementation MyStoreViewController {
    IBOutlet UILabel * la_name;
    IBOutlet UILabel * la_addr;
    IBOutlet UILabel * la_tel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"经销店信息";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [la_name setText:[self.UserInfo gKCsName]];
    [la_addr setText:[self.UserInfo gKCsAddr]];
    [la_tel setText:[self.UserInfo gKCsTel]];
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
