//
//  TravelLogRangeViewController.h
//  G-NetLink-v2.0
//
//  Created by jk on 4/13/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol didChooseRangeForTravelLog <NSObject>
- (void) showRangeForTravelLogs:(NSString * _Nullable)startTime EndTime:(NSString * _Nullable)endTime;
@end

@interface TravelLogRangeViewController : UIViewController {
    id <didChooseRangeForTravelLog> delegate;
}

@property (nonatomic, strong) NSDate  * _Nullable startTime;
@property (nonatomic, strong) NSDate  * _Nullable endTime;

@property(nonatomic, retain) __nullable id<didChooseRangeForTravelLog>delegate;

@end
