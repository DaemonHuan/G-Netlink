//
//  NotationsTableViewCell.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "NotationsTableViewCell.h"
#import "public.h"



@implementation NotationsTableViewCell {
    IBOutlet UILabel * la_title;
    IBOutlet UILabel * la_contains;
    IBOutlet UILabel * la_time;
    IBOutlet UIImageView * im_flag;
    IBOutlet UIImageView * im_icon;
    
}

- (void)awakeFromNib {
    [self setBackgroundColor:[UIColor clearColor]];
    
    [la_title setText:@""];
    [la_title setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE1]];
    [la_title setTextColor:[UIColor whiteColor]];
    
    [la_contains setText:@""];
    [la_contains setTextColor:[UIColor lightTextColor]];
    [la_contains setFont:[UIFont fontWithName:FONT_XI size:FONT_S_WORD]];
    
    [la_time setText:@""];
    [la_time setTextColor:[UIColor lightTextColor]];
    [la_time setFont:[UIFont fontWithName:FONT_MM size:12.0f]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setItemFlagIcon:(BOOL)flag Icon:(NSString *)icon {
    [im_flag setHidden: !flag];
    [im_icon setImage:[UIImage imageNamed:icon]];
}

- (void) setItemTitle:(NSString *)title Contains:(NSString *)contains {
    [la_title setText:title];
    [la_contains setText:contains];
}

- (void) setItemTime:(NSString *)time {
    [la_time setText:time];
}

@end
