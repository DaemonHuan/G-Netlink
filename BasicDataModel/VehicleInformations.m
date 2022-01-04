//
//  VechileInformations.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/16/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "VehicleInformations.h"

@implementation VehicleInformations

@synthesize type, vin, color, lisence, extendinfo, isDefaultVehicle;

- (id) init {
    if (self = [super init]) {
        self.type = @"";
        self.vin = @"";
        self.color = @"";
        self.lisence = @"";
        self.extendinfo = @"";
        self.isDefaultVehicle = NO;
    }
    return self;
}

@end
