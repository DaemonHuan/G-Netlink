//
//  VehicleControlViewController.h
//  G-NetLink
//
//  Created by jayden on 14-4-24.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseViewController.h"
#import "VehicleControlView.h"
#import "BaseCustomMessageBox.h"
#import "StripCustomMessageBox.h"
#import "VehicleWindow.h"
#import "VehicleDoor.h"
#import "VerifyCode.h"
#import "Vehicle.h"

@interface VehicleControlViewController : BaseViewController<VehicleControlViewDelegate,TextFiledReturnEditingDelegate>
{
    @private
        
        VehicleWindow *vehicleWindow;
        VehicleDoor *vehicleDoor;
        VerifyCode *verifyCode;
        Vehicle *vehicle;
}
@end
