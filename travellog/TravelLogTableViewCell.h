//
//  TravelLogTableViewCell.h
//  G-Netlink-beta0.2
//
//  Created by jk on 11/2/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelLogTableViewCell : UITableViewCell {
}

@property (nonatomic, retain) IBOutlet UILabel * lb_starttime;
@property (nonatomic, retain) IBOutlet UILabel * lb_endtime;
@property (nonatomic, retain) IBOutlet UILabel * lb_distance;
@property (nonatomic, retain) IBOutlet UILabel * lb_consume;

- (void) setTime:(NSString*) start endtime:(NSString*) end;
- (void) setMessage:(NSString*) distance oilconsume:(NSString*) oilconsume;

@end
