//
//  TravelLogTableViewCell.m
//  G-Netlink-beta0.2
//
//  Created by jk on 11/2/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "TravelLogTableViewCell.h"
#import "public.h"

@implementation TravelLogTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
    
    self.lb_starttime.font = [UIFont fontWithName:FONT_XI size:12.0f];
    [self.lb_starttime setTextColor:[UIColor whiteColor]];
    self.lb_endtime.font = [UIFont fontWithName:FONT_XI size:12.0f];
    [self.lb_endtime setTextColor:[UIColor whiteColor]];

    self.lb_distance.font = [UIFont fontWithName:FONT_MM size:17.0f];
    self.lb_consume.font = [UIFont fontWithName:FONT_MM size:17.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setTime:(NSString *)start endtime:(NSString *)end {
    [self.lb_starttime setText:start];
    [self.lb_endtime setText:end];
}

- (void) setMessage:(NSString *)distance oilconsume:(NSString *)consume {
    [self.lb_distance setText:distance];
    [self.lb_consume setText:consume];
}

@end
