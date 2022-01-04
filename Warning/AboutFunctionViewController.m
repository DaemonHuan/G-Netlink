//
//  AboutFunctionViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/5/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "AboutFunctionViewController.h"
#import "public.h"

@interface AboutFunctionViewController ()

@end

@implementation AboutFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"关于此功能"];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor colorWithHexString:WORD_COLOR_BLUE]];
    self.navigationItem.leftBarButtonItem = leftItem;
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
