//
//  MaplineTableViewCell.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/29/17.
//  Copyright © 2017 jk. All rights reserved.
//

#import "MaplineTableViewCell.h"
#import "public.h"

@implementation MaplineTableViewCell {
    IBOutlet UIImageView * iv_icon;
    IBOutlet UILabel * la_title;
    IBOutlet UIImageView * iv_swith;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_bg"]]];
    [la_title setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE2]];
    [la_title setTextColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCellWithTitle:(NSString *) title Icon:(NSString *)icon  {
    [iv_icon setImage:[UIImage imageNamed:icon]];
    [la_title setText:title];
}

- (void) setSwitchFlag:(BOOL) flag {
    if (flag) {
        [iv_swith setImage:[UIImage imageNamed:@"uctl_lineon"]];
    }
    else {
        [iv_swith setImage:[UIImage imageNamed:@"uctl_lineoff"]];
    }
}

@end
