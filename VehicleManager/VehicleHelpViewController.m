//
//  VehicleHelpViewController.m
//  G-NetLink-v1.0
//
//  Created by jk on 3/16/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "VehicleHelpViewController.h"
#import "public.h"

@interface VehicleHelpViewController ()

@end

@implementation VehicleHelpViewController {
    UILabel * la_context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_backgroud"]];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"使用帮助";
    
    la_context = [self newContextLable:0.0f Y:0.0f Title:@"\t您无法使用手机APP远程关窗的原因，可能是您通过车机设置了“闭锁玻璃自动升降”有效。\n\n\t在此状态下，若您仍希望远程关窗，则须首先“开启车锁”，再“关闭车锁”。如此，可关闭车窗。"];
    
    CGFloat wx = [UIScreen mainScreen].bounds.size.width;
    CGFloat laHeight = CGRectGetHeight(la_context.bounds);
    [la_context setFrame:CGRectMake(16.0f, 130.0f, wx - (2 * 16.0f), laHeight)];
    [self.view addSubview:la_context];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *) newContextLable:(CGFloat)xx Y:(CGFloat)yy Title:(NSString *)title {
    UILabel * label = [[UILabel alloc]init];
    [label setFont: [UIFont fontWithName:FONT_MM size:17.0f]];
    [label setTextColor:[UIColor whiteColor]];
    [label setLineBreakMode:NSLineBreakByCharWrapping];
    [label setNumberOfLines:0];
    [label setText:title];
    CGSize size = [label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - (2 * 16.0f), 1000.0f)];
    [label setFrame:CGRectMake(xx, yy, size.width, size.height + 20.0f)];
    
    return label;
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
