//
//  TransitPointAnnotationView.h
//  G-NetLink-v2.0
//
//  Created by jk on 4/11/17.
//  Copyright © 2017 jk. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
//#import "TransitPointCalloutView.h"
#import "CustomCalloutView.h"

@interface TransitPointAnnotationView : MAAnnotationView

@property (nonatomic, strong, readwrite) CustomCalloutView * calloutView;

@end
