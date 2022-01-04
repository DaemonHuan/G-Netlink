//
//  ChangeDefaultVehicleViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "ChangeDefaultVehicleViewController.h"
#import "VehicleTableViewCell.h"
#import "VehicleDetailViewController.h"
#import "public.h"

@interface ChangeDefaultVehicleViewController ()

@end

@implementation ChangeDefaultVehicleViewController {
    IBOutlet UITableView * m_tableview;
    NSDictionary * m_dicForVehicles;
    NSArray * m_arrVehicles;
    
    VehicleDetailViewController * m_detailviewcontroller;
}

- (id) init {
    if (self = [super init]) {
        m_dicForVehicles = [self.UserInfo gVehicleList];
        m_arrVehicles = [m_dicForVehicles allKeys];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"切换车辆";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    m_tableview.tableFooterView = [[UIView alloc]init];
    m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    m_detailviewcontroller = [[VehicleDetailViewController alloc]init];
    
    if ([self.UserInfo isRunDemo]) {
        [self.view addSubview: [ExtendStaticView MarkDemoView]];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [m_tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


// tableview load
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_arrVehicles count];
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"VehicleTableViewCell";
    VehicleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if ([[m_arrVehicles objectAtIndex:indexPath.row] isEqualToString:[self.UserInfo gDefaultVehicleVin]]) {
        [cell setItemValue:[NSString stringWithFormat:@"车辆 %zi",(indexPath.row + 1)] Checked:YES];
    }
    else {
        [cell setItemValue:[NSString stringWithFormat:@"车辆 %zi",(indexPath.row + 1)] Checked:NO];
    }
    
    VehicleInformations * one = [m_dicForVehicles objectForKey:[m_arrVehicles objectAtIndex:indexPath.row]];
    [cell setItemCode: one.lisence];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 去除选中行的被选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VehicleInformations * one = [m_dicForVehicles objectForKey:[m_arrVehicles objectAtIndex:indexPath.row]];
    
    m_detailviewcontroller.vehiclecode = [NSString stringWithFormat:@"车辆 %zi",indexPath.row + 1];
    m_detailviewcontroller.color = one.color;
    m_detailviewcontroller.lisense = one.lisence;
    m_detailviewcontroller.type = one.type;
    m_detailviewcontroller.vin = one.vin;
    [self.navigationController pushViewController:m_detailviewcontroller animated:YES];
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
