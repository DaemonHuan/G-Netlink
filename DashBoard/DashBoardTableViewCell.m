//
//  DashBoardTableViewCell.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/14/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "DashBoardTableViewCell.h"
#import "public.h"

@implementation DashBoardTableViewCell {
    IBOutlet UIImageView * im_icon;
    IBOutlet UILabel * la_item;
    IBOutlet UILabel * la_value;
}

- (void)awakeFromNib {
    [la_item setFont: [UIFont fontWithName:FONT_XI size:20.0f]];
    [la_item setTextColor: [UIColor whiteColor]];
    [la_value setFont: [UIFont fontWithName:FONT_XI size:24.0f]];
    [la_value setTextColor: [UIColor colorWithHexString: WORD_COLOR_GLODEN]];
    self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
}

- (void) setItemIcon: (NSString *)name {
    [im_icon setImage: [UIImage imageNamed: name]];
}

- (void) setItemTitle:(NSString *)text {
    [la_item setText: text];
}

- (void) setItemValue:(NSString *)value {
    [la_value setText: value];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
