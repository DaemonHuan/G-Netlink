//
//  VehicleConditionView.h
//  G-NetLink
//
//  Created by jayden on 14-5-4.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarView.h"
enum StatusEnum
{
    StatusNotOK,
    StatusOK
};
@protocol VehicleConditionViewDelegate <NSObject>
@optional
-(IBAction)itemButton_onClick:(id)sender;
-(IBAction)refreshButton_onClick:(id)sender;
@end

@interface VehicleConditionView : TitleBarView
@property(nonatomic,weak)id<VehicleConditionViewDelegate> eventObserver;
@property(nonatomic,assign)enum StatusEnum windowsStatus;
@property(nonatomic,assign)enum StatusEnum doorsStatus;
@property(nonatomic,assign)enum StatusEnum powerStatus;
@property(nonatomic,readonly) UILabel *lbl_recordTime;

- (void)shutDownBtnUserInterface;
- (void)openBtnUserInterface;
@end
