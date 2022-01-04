//
//  TravelLogDetailViewController.m
//  G-NetLink-v1.0
//
//  Created by jk on 1/20/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "TravelLogDetailViewController.h"

#import <MAMapKit/MAMapKit.h>

#import "public.h"
#import "GNLUserInfo.h"
#import "jkAlertController.h"

@interface TravelLogDetailViewController () <MAMapViewDelegate> {
    MAMapView * mamapview;
}
@end

@implementation TravelLogDetailViewController {
    IBOutlet UIView * m_mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    CGFloat extend = 0.0f;
    if ([GNLUserInfo isDemo]) {
        extend = 30.0f;
        [self.view addSubview: [ServicesPro loadMarkDemoView]];
    }
    
    [MAMapServices sharedServices].apiKey = MAP_BUNDLEIDENTIFIER;
    mamapview = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - extend)];
    mamapview.delegate = self;
    [m_mapView addSubview: mamapview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    mamapview.showsCompass = NO;
    mamapview.showsScale = NO;
    mamapview.userTrackingMode = MAUserTrackingModeNone;
    [mamapview setZoomLevel:16.1 animated:YES];
    [mamapview setZoomEnabled:NO];
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
