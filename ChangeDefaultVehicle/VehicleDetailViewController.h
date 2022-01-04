//
//  VehicleDetailViewController.h
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@interface VehicleDetailViewController : BasicViewController {
}

@property (nonatomic, strong) NSString * vehiclecode;
@property (nonatomic, strong) NSString * lisense;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * color;
@property (nonatomic, strong) NSString * vin;

@end
