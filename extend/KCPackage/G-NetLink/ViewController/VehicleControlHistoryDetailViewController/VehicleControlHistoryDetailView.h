//
//  VehicleControlHistoryDetailView.h
//  G-NetLink
//
//  Created by jayden on 14-4-25.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarView.h"

@interface VehicleControlHistoryDetailView : TitleBarView
@property(nonatomic,assign)int status;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *time;
@end
