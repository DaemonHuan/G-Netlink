//
//  CarInfoTableViewCell.m
//  G-NetLink-v1.0
//
//  Created by jk on 2/24/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "CarInfoTableViewCell.h"
#import "public.h"

@implementation CarInfoTableViewCell {
    IBOutlet UILabel * la_title;
    IBOutlet UILabel * la_value;
    IBOutlet UIImageView * iv_car;
    IBOutlet UIImageView * iv_in;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
    [la_value setFont: [UIFont fontWithName: FONT_XI size: 18.0f]];
    [la_title setFont: [UIFont fontWithName: FONT_MM size: 18.0f]];
    [iv_car setHidden:YES];
    [iv_in setHidden: YES];
}

- (void) setItemValue:(NSString *)title Value:(NSString *)value {
    [la_title setText:title];
    [la_value setText:value];
}

- (void) setItemIconHidden:(BOOL)car IntoIcon:(BOOL)into {
    [iv_car setHidden: car];
    [iv_in setHidden: into];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
