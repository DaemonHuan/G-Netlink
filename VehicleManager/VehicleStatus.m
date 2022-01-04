//
//  VehicleStatus.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/17/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "VehicleStatus.h"

@implementation VehicleStatus {
    NSInteger m_frontldoor;
    NSInteger m_frontrfoor;
    NSInteger m_rearldoor;
    NSInteger m_rearrdoor;
    
    NSInteger m_dormer;
    NSInteger m_trunk;
    
    NSInteger m_lock;
    NSInteger m_window;
}

- (void) setFrontLDoorStatus:(NSInteger) currentone {
    m_frontldoor = currentone;
}
- (NSInteger) getFrontLDoorStatus {
    return m_frontldoor;
}

- (void) setFrontRDoorStatus:(NSInteger) currentone {
    m_frontrfoor = currentone;
}
- (NSInteger) getFrontRDoorStatus {
    return m_frontrfoor;
}

- (void) setRearLDoorStatus:(NSInteger) currentone {
    m_rearldoor = currentone;
}
- (NSInteger) getRearLDoorStatus {
    return m_rearldoor;
}

- (void) setRearRDoorStatus:(NSInteger) currentone {
    m_rearrdoor = currentone;
}
- (NSInteger) getRearRDoorStatus {
    return m_rearrdoor;
}

- (void) setDormerStatus:(NSInteger) currentone {
    m_dormer = currentone;
}
- (NSInteger) getDormerStatus {
    return m_dormer;
}

- (void) setTrunkStatus:(NSInteger) currentone {
    m_trunk = currentone;
}
- (NSInteger) getTrunkStatus {
    return m_trunk;
}

- (void) setLockStatus:(NSInteger) currentone {
    m_lock = currentone;
}

- (NSInteger) getLockStatus {
    return m_lock;
}

- (void) setWindowStatus:(NSInteger) currentone {
    m_window = currentone;
}

- (NSInteger) getWindowStatus {
    return m_window;
}

- (void) showAllStatus {
    NSLog(@"** Vehicle Status 4 Door: %ld %ld %ld %ld", (long)m_frontldoor, (long)m_frontrfoor, (long)m_rearldoor, (long)m_rearrdoor);
    NSLog(@"** Vehicle Status D T W L: %zi %zi %zi %zi", m_dormer, m_trunk, m_window, m_lock);
}
- (void) clearAllStatus {
    m_frontldoor = 0;
    m_frontrfoor = 0;
    m_rearldoor = 0;
    m_rearrdoor = 0;
    
    m_dormer = 0;
    m_trunk = 0;
    
    m_window = 0;
    m_lock = 0;
}

@end
