//
//  VehicleLocationView.h
//  G-NetLink
//
//  Created by a95190 on 14-10-11.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "TitleBarView.h"
#import <iNaviCore/MBMapView.h>
#import <iNaviCore/MBIconOverlay.h>
#import "CustomMapCalloutView.h"

#import <MAMapKit/MAMapKit.h>
#import "public.h"

/*
enum MapViewShowType
{
    MapViewShowType_2D,
    MapViewShowType_3D
    
}; */

@interface VehicleLocationView : TitleBarView <MAMapViewDelegate>

//@property (nonatomic,strong)MBMapView *mapView;
//@property(nonatomic)enum MapViewShowType mapViewShowType;
@property(nonatomic,readonly)UILabel *lbl_recordTime;
@property(nonatomic,strong)CustomMapCalloutView *currentMapPoiView;

- (void) insertPointForMap:(CGFloat) lat Long:(CGFloat)lon Msg:(NSString *)msg;

@end
