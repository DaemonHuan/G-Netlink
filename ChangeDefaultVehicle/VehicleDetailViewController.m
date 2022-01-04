//
//  VehicleDetailViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "VehicleDetailViewController.h"
#import "public.h"

@interface VehicleDetailViewController () 

@end

@implementation VehicleDetailViewController {
    IBOutlet UILabel * la_title;
    IBOutlet UILabel * la_num;
    IBOutlet UILabel * la_type;
    IBOutlet UILabel * la_color;
    IBOutlet UIButton * bt_setdefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"切换车辆";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [la_title setText: ((self.vehiclecode == nil) ? @"" : self.vehiclecode)];
    [la_title setTextColor:[UIColor whiteColor]];
    [la_title setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE1]];
    
    [la_color setText: ((self.color == nil) ? @"" : self.color)];
    [la_color setTextColor:[UIColor whiteColor]];
    [la_color setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE2]];
    
    [la_num setText: ((self.lisense == nil) ? @"" : self.lisense)];
    [la_num setTextColor:[UIColor whiteColor]];
    [la_num setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE2]];
    
    [la_type setText: ((self.type == nil) ? @"" : self.type)];
    [la_type setTextColor:[UIColor whiteColor]];
    [la_type setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE2]];
    
    if ([self.UserInfo isRunDemo]) {
        [self.view addSubview: [ExtendStaticView MarkDemoView]];
    }
    
}

- (void) viewDidAppear:(BOOL)animated {
    [la_title setText: ((self.vehiclecode == nil) ? @"" : self.vehiclecode)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) setDefaultVehicle:(id)sender {
    [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyDefaultVehicleLisence Value: self.lisense];
    [self.UserInfo doSetValueForUserInformationsWithKey:InformationsKeyDefaultVehicleVin Value: self.vin];
    
    [self.navigationController popViewControllerAnimated:YES];
//    AlertBoxView * view = [[AlertBoxView alloc]initWithOKButton:@"设置已生效。"];
//    view.okBlock = ^() {
//        
//    };
//    [view show];
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
