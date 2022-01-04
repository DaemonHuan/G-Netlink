//
//  VehicleCtrlTableViewCell.m
//  G-NetLink-v2.0
//
//  Created by jk on 5/19/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "VehicleCtrlTableViewCell.h"
#import "public.h"

@implementation VehicleCtrlTableViewCell {
    IBOutlet UILabel * la_time;
    IBOutlet UILabel * la_title;
    IBOutlet UILabel * la_status;
}

- (void)awakeFromNib {
//    [self setBackgroundColor: [UIColor clearColor]];
    [la_time setFont:[UIFont fontWithName:FONT_XI size:15.0f]];
    [la_time setTextColor:[UIColor whiteColor]];
    [la_title setFont:[UIFont fontWithName:FONT_XI size:15.0f]];
    [la_title setTextColor:[UIColor whiteColor]];
    
    [la_status setFont:[UIFont fontWithName:FONT_XI size:15.0f]];
}

- (void) setItemValue:(NSString *)time Title:(NSString *)title {
    [la_time setText:time];
    [la_title setText: title];
}

- (void) setItemStatus:(BOOL) flag {
    if (flag) {
        [la_status setText:@"成功"];
        [la_status setTextColor:[UIColor greenColor]];
    }
    else {
        [la_status setText:@"失败"];
        [la_status setTextColor:[UIColor redColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
