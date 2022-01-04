//
//  VehicleConditionViewController.h
//  G-NetLink
//
//  Created by jayden on 14-5-4.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseViewController.h"
#import "VehicleConditionView.h"
#import "Vehicle.h"
#import "VehicleConditionOfDoorsOrWindowsViewController.h"

@interface VehicleConditionViewController : BaseViewController<VehicleConditionViewDelegate>
{
    @private
    Vehicle *_vehicle;
}
@end
