//
//  VehicleControlView.h
//  G-NetLink
//
//  Created by jayden on 14-4-24.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarView.h"
enum CurrentConditionType
{
    CurrentType_Windows,
    CurrentType_Doors,
    CurrentType_LightHorn
};

enum StatusEnum
{
    StatusNotOK,
    StatusOK
};

@protocol VehicleControlViewDelegate <NSObject>
@optional
-(IBAction)keyButton_onClick:(id)sender;
-(IBAction)keyButton_longPressGesture:(id)sender;
-(IBAction)lightButtonOnClick:(id)sender;
-(void)closeTipDelegate;
@end

@interface VehicleControlView : TitleBarView
@property (nonatomic,strong) UIView *backPlance;
@property(nonatomic,assign)BOOL isSuccess;
@property(nonatomic,weak)id<VehicleControlViewDelegate> eventObserver;
@property(nonatomic,assign) enum CurrentConditionType currentType;
@property(nonatomic,assign)enum StatusEnum windowsStatus;
@property(nonatomic,assign)enum StatusEnum doorsStatus;
@property(nonatomic,readonly)UILabel *lbl_vehNo;
@property(nonatomic,readonly)UILabel *tipLable;
@property(nonatomic,readonly)UIButton *closeTipBtn;
- (void)closeTip;
@end
