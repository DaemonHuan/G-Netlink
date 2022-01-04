//
//  DataArrayForOneDay.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/22/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "DataArrayForOneDay.h"

@implementation DataArrayForOneDay {
    NSMutableArray * m_data;
}

- (void) addArrayObject:(NSArray *) dic {
    if (m_data == nil) {
        m_data = [[NSMutableArray alloc]init];
    }
    
    [m_data addObject: dic];
}

- (NSMutableArray *) getCurrentArray {
    return m_data;
}

@end
