//
//  VehicleStatus.h
//  G-NetLink-v1.0
//
//  Created by jk on 12/17/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleStatus : NSObject

/* Status: 
 door: status > 1  
 window: status/2 == 0
 
 0 - 关门关窗
 1 - 关门开窗
 2 - 开门关窗
 3 - 开门开窗 */

- (void) setFrontLDoorStatus:(NSInteger) currentone;
- (NSInteger) getFrontLDoorStatus;

- (void) setFrontRDoorStatus:(NSInteger) currentone;
- (NSInteger) getFrontRDoorStatus;

- (void) setRearLDoorStatus:(NSInteger) currentone;
- (NSInteger) getRearLDoorStatus;

- (void) setRearRDoorStatus:(NSInteger) currentone;
- (NSInteger) getRearRDoorStatus;

- (void) setDormerStatus:(NSInteger) currentone;
- (NSInteger) getDormerStatus;

- (void) setTrunkStatus:(NSInteger) currentone;
- (NSInteger) getTrunkStatus;

- (void) setLockStatus:(NSInteger) currentone;
- (NSInteger) getLockStatus;

- (void) setWindowStatus:(NSInteger) currentone;
- (NSInteger) getWindowStatus;

- (void) showAllStatus;
- (void) clearAllStatus;

@end
