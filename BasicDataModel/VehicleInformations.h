//
//  VechileInformations.h
//  G-NetLink-v2.0
//
//  Created by jk on 3/16/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleInformations : NSObject {
    
}

@property(nonatomic, retain) NSString * lisence;
@property(nonatomic, retain) NSString * type;
@property(nonatomic, retain) NSString * color;
@property(nonatomic, retain) NSString * vin;
@property(nonatomic, retain) NSString * extendinfo;
@property(nonatomic, assign) BOOL isDefaultVehicle;

@end
