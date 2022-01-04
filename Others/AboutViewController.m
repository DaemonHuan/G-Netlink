//
//  AboutViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/5/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "AboutViewController.h"
#import "public.h"

@interface AboutViewController ()

@end

@implementation AboutViewController {
    IBOutlet UILabel * la_version;
    IBOutlet UILabel * la_copyright;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"关于";
    
    [la_version setFont: [UIFont fontWithName:FONT_MM size:18.0f]];
    [la_version setTextColor:[UIColor whiteColor]];
    [la_version setLineBreakMode:NSLineBreakByCharWrapping];
    [la_version setNumberOfLines:0]; 
    [la_version setText:@"G-Netlink手机客户端\n\nV4.3.4"];
    [la_version setTextAlignment:NSTextAlignmentCenter];

//    [la_copyright setFont: [UIFont fontWithName:FONT_MM size:12.0f]];
    [la_copyright setTextColor:[UIColor whiteColor]];
    [la_copyright setLineBreakMode:NSLineBreakByCharWrapping];
    [la_copyright setNumberOfLines:0];
    [la_copyright setText:@"吉利控股 版权所有\nCopyright © 2014-2019 Geely Holding Group"];
    [la_copyright setTextAlignment:NSTextAlignmentCenter];
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
