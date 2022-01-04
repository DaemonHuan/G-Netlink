//
//  SlideMenuTableViewCell.m
//  G-NetLink-v1.0
//
//  Created by jk on 1/14/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "SlideMenuTableViewCell.h"
#import "public.h"

@implementation SlideMenuTableViewCell {
    IBOutlet UIImageView * im_icon;
    IBOutlet UILabel * la_item;
}

- (void)awakeFromNib {
    [la_item setTextColor: [UIColor whiteColor]];
    [la_item setFont:[UIFont fontWithName:FONT_MM size: FONT_S_TITLE2]];
//    la_item.highlightedTextColor = [UIColor yellowColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    la_item.highlighted = selected;
    [la_item setTextColor: (selected ? [UIColor yellowColor] : [UIColor whiteColor])];
    // Configure the view for the selected state
}

- (void) setitem:(NSString *)iconname LabelText:(NSString *) str {
    [im_icon setImage:[UIImage imageNamed:iconname]];
    [la_item setText:str];
}

@end
