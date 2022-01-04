//
//  VehicleControlHistoryView.h
//  G-NetLink
//
//  Created by jayden on 14-4-24.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarAndPullRefreshTableView.h"
#import "CustomUIDatePicker.h"

@interface VehicleControlHistoryView : TitleBarAndPullRefreshTableView
@property(nonatomic,strong)NSDate *currentData;
@property(nonatomic,weak)id<CustomUIDatePickerDelegate> eventObserver;
@end
