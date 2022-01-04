//
//  VehicleLocationViewController.h
//  G-NetLink
//
//  Created by a95190 on 14-10-11.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseViewController.h"
#import "VehicleLocationView.h"
#import "VehicleLocation.h"
#import "CustomMapCalloutView.h"
#import "BaseCustomMessageBox.h"
#import <iNaviCore/MBGpsLocation.h>
#import "Location.h"
#import "LocationInfomation.h"

/*MBMapViewDelegate,LocationDelegate*/
@interface VehicleLocationViewController : BaseViewController<CustomTitleBar_ButtonDelegate,DataModuleDelegate>
{
    @private
    VehicleLocation *vehicleLocation;
    MBAnnotation *vehicleAnnotation;
    MBAnnotation *locationAnnotation;
    Location *location;
    LocationInfomation *nowLocationInfo;
    CustomMapCalloutView *vehicleCalloutView;
    MBPoint currentVehiclePoint;
}

@end
