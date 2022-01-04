//
//  TravelLogTableViewCell.m
//  G-Netlink-beta0.2
//
//  Created by jk on 11/2/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "TravelLogTableViewCell.h"
#import "public.h"

@implementation TravelLogTableViewCell {
    IBOutlet UILabel * lb_starttime;
    IBOutlet UILabel * lb_endtime;
    IBOutlet UILabel * la_count;
//    IBOutlet UILabel * lb_location;
//    IBOutlet UILabel * lb_destination;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    
    [lb_starttime setFont:[UIFont fontWithName:FONT_XI size:15.0f]];
    [lb_starttime setTextColor:[UIColor whiteColor]];
    [lb_endtime setFont:[UIFont fontWithName:FONT_XI size:15.0f]];
    [lb_endtime setTextColor:[UIColor whiteColor]];
    
    [la_count setFont:[UIFont fontWithName:FONT_XI size:17.0f]];
    [la_count setTextColor:[UIColor whiteColor]];
//    [lb_location setFont:[UIFont fontWithName:FONT_XI size:17.0f]];
//    [lb_location setTextColor:[UIColor whiteColor]];
//    [lb_destination setFont:[UIFont fontWithName:FONT_XI size:17.0f]];
//    [lb_destination setTextColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

- (void) setItemCount:(NSString *)value {
    [la_count setText:value];
}

- (void) setTime:(NSString *)start endtime:(NSString *)end {
    [lb_starttime setText:start];
    [lb_endtime setText:end];
}

- (void) setMessage:(NSString *)location Destination:(NSString *)destination {
//    [lb_location setText:location];
//    [lb_destination setText:destination];
}

@end
