//
//  WarningTableViewCell.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/15/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "WarningTableViewCell.h"
#import "public.h"

@implementation WarningTableViewCell {
    IBOutlet UILabel * la_title;
    IBOutlet UIImageView * im_icon;
    IBOutlet UIImageView * im_status;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
    [la_title setTextColor: [UIColor whiteColor]];
    [la_title setFont: [UIFont fontWithName:FONT_XI size:16.0f]];
}

- (void) setItemIconWithTitle:(NSString *)image Title:(NSString *)title {
    [im_icon setImage: [UIImage imageNamed: image]];
    [la_title setText: title];
}

- (void) setItemStatus:(NSString *)status {
    [im_status setImage: [UIImage imageNamed:status]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
