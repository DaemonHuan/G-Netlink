//
//  VehicleConditionOfDoorsOrWindowsView.h
//  G-NetLink
//
//  Created by jayden on 14-5-5.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarView.h"

enum CurrentConditionType
{
    CurrentType_Windows,
    CurrentType_Doors,
};

@protocol VehicleConditionOfDoorsOrWindowsDelegate <NSObject>
@optional
-(IBAction)commandButton_onClick:(id)sender;
@end
@interface VehicleConditionOfDoorsOrWindowsView : TitleBarView
@property (nonatomic,strong)UIView *backPlance;
@property(nonatomic,weak)id<VehicleConditionOfDoorsOrWindowsDelegate> eventObserver;
@property(nonatomic)NSString *carImageName;
@property(nonatomic)NSString *lightImageName;
@property(nonatomic)NSString *commandButtonImageName;
@property(nonatomic,assign)BOOL isSuccess;
@property(nonatomic,assign) enum CurrentConditionType currentType;
@property(nonatomic,readonly) UILabel *lbl_recordTime;
@end
