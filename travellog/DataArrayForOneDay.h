//
//  DataArrayForOneDay.h
//  G-NetLink-v1.0
//
//  Created by jk on 12/22/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataArrayForOneDay : NSObject

- (void) addArrayObject:(NSDictionary *) dic;
- (NSMutableArray *) getCurrentArray;

@end
