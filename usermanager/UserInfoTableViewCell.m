//
//  UserInfoTableViewCell.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/14/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import "public.h"

@implementation UserInfoTableViewCell {
    IBOutlet UILabel * la_title;
    IBOutlet UILabel * la_value;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
    [la_value setFont: [UIFont fontWithName: FONT_XI size: 18.0f]];
    [la_title setFont: [UIFont fontWithName: FONT_MM size: 18.0f]];
}

- (void) setItemValue:(NSString *)title Value:(NSString *)value {
    [la_title setText:title];
    [la_value setText:value];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
