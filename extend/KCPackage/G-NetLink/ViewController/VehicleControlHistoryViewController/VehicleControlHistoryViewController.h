//
//  VehicleControlHistoryViewController.h
//  G-NetLink
//
//  Created by jayden on 14-4-24.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseViewController.h"
#import "VehicleControlHistoryView.h"
#import "Vehicle.h"

@interface VehicleControlHistoryViewController : BaseViewController<CustomUIDatePickerDelegate,UITableViewDelegate,UITableViewDataSource,PullRefreshTableViewDelegate>
{
    @private
        Vehicle *vehicle;
}
@end
