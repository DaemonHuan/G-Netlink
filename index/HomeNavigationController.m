//
//  HomeNavigationController.m
//  G-Netlink-beta0.2
//
//  Created by jk on 10/29/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "HomeNavigationController.h"
#import "REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface HomeNavigationController ()


@end

@implementation HomeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    
//    self.navigationBar.barTintColor = [UIColor colorWithRed:80/255.0 green:196/255.0 blue:211/255.0 alpha:0.2f];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)showMenu
{
    [self.frostedViewController presentMenuViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    [self.frostedViewController panGestureRecognized:sender];
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
