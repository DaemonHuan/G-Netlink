//
//  SimInfoTableViewCell.m
//  G-NetLink-v2.0
//
//  Created by jk on 6/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "SimInfoTableViewCell.h"
#import "public.h"

@implementation SimInfoTableViewCell {
    IBOutlet UILabel * la_key;
    IBOutlet UILabel * la_value;
}

- (void)awakeFromNib {
    [self setBackgroundColor:[UIColor clearColor]];
    
    [la_key setTextColor:[UIColor whiteColor]];
    [la_key setFont:[UIFont fontWithName:FONT_MM size:FONT_S_DETAIL]];
    [la_value setTextColor:[UIColor whiteColor]];
    [la_value setFont:[UIFont fontWithName:FONT_XI size:FONT_S_DETAIL]];
}

- (void) setItemValue:(NSString *)value Key:(NSString *)key {
    [la_key setText:key];
    [la_value setText:value];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
