//
//  NotationsDetailViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "NotationsDetailViewController.h"
#import "public.h"

@interface NotationsDetailViewController ()

@end

@implementation NotationsDetailViewController {
    IBOutlet UILabel * la_title;
    IBOutlet UILabel * la_time;
    IBOutlet UILabel * la_from;
    
    UILabel * la_contains;
}

@synthesize itemTime, itemSource, itemTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息详情";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [la_title setText: self.itemTitle];
    [la_title setTextColor:[UIColor whiteColor]];
    [la_title setFont:[UIFont fontWithName:FONT_XI size:16.0f]];
    
    NSString * str = [NSString stringWithFormat:@"%@  %@", [self.itemTime substringWithRange:NSMakeRange(0, 10)], [self.itemTime substringWithRange:NSMakeRange(11, 8)]];
    NSLog(@"%@ %@", self.itemTime, str);
    [la_time setText: str];
    [la_time setTextColor:[UIColor whiteColor]];
    [la_time setFont:[UIFont fontWithName:FONT_XI size:16.0f]];
    
    [la_from setText: self.itemSource];
    [la_from setTextColor:[UIColor whiteColor]];
    [la_from setFont:[UIFont fontWithName:FONT_XI size:16.0f]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setItemValue:(NSString *)time From:(NSString *)source Title:(NSString *)title {
    [la_title setText: title];
    [la_from setText: source];
    [la_time setText: time];
}

- (void) setItemDetail:(NSString *)value {
    [la_contains removeFromSuperview];
    la_contains = [self newContextLable:16.0f Y:270.0f Title: value];
    [self.view addSubview: la_contains];
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
