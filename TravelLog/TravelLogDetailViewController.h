//
//  TravelLogDetailViewController.h
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "DataForDrivingLog.h"

@interface TravelLogDetailViewController : BasicViewController {
}

@property (nonatomic, strong) DataForDrivingLog * __nonnull oneDetailData;
@property (nonatomic, strong) NSMutableArray * __nonnull arrayForAllDrivingLog;

- (void) fixAllDrivingLogForPointName;
- (void) setValueForDetail:(DataForDrivingLog * __nonnull) data;
- (void) setValueForPoint:(DataForDrivingLog * __nonnull) data;

@end
