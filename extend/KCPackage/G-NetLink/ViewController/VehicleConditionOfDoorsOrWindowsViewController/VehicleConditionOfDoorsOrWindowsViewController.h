//
//  VehicleConditionOfDoorsOrWindowsViewController.h
//  G-NetLink
//
//  Created by jayden on 14-5-5.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseCustomMessageBox.h"
#import "StripCustomMessageBox.h"
#import "VehicleConditionOfDoorsOrWindowsView.h"
#import "VehicleWindow.h"
#import "VehicleDoor.h"
#import "VerifyCode.h"
typedef enum
{
    ViewContentType_Window = 0,
    ViewContentType_Door
}ViewContentType;

@interface VehicleConditionOfDoorsOrWindowsViewController : BaseViewController<VehicleConditionOfDoorsOrWindowsDelegate>
{
    @private
    VehicleWindow *_windows;
    ViewContentType  _viewContentType;
    VehicleDoor *_doors;
    VerifyCode *_verifyCode;
}
@end
