//
//  HomePageTableViewCell.m
//  G-Netlink-beta0.2
//
//  Created by jk on 11/2/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "HomePageTableViewCell.h"
#import "public.h"

@implementation HomePageTableViewCell {
    IBOutlet UILabel * la_date;
    IBOutlet UILabel * la_time;
}

- (void)awakeFromNib {
    // Initialization code
    [self.lb_item setTextColor:[UIColor whiteColor]];
    [self.lb_item setFont:[UIFont fontWithName:FONT_MM size: FONT_S_TITLE2]];
    [self.lb_value setFont:[UIFont fontWithName:FONT_MM size: FONT_S_TITLE1]];
    [self.lb_value setTextColor:[UIColor colorWithHexString: WORD_COLOR_GLODEN]];
    self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
    
//    [la_date setHidden: YES];
    [la_date setText:@""];
    [la_date setTextColor: [UIColor colorWithHexString: @"7B7B7B"]];
    [la_date setFont: [UIFont fontWithName:FONT_XI size:12.0f]];
//    [la_time setHidden: YES];
    [la_time setText:@""];
    [la_time setTextColor: [UIColor colorWithHexString: @"7B7B7B"]];
    [la_time setFont: [UIFont fontWithName:FONT_XI size:12.0f]];
}

- (void) setItemTime: (NSString *)date Time: (NSString *)time {
//    [la_time setHidden: NO];
//    [la_date setHidden: NO];
    
    [la_date setText: date];
    [la_time setText: time];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setLabelIcon:(NSString *)iconname {
    [self.image_itemIcon setImage:[UIImage imageNamed:iconname]];
}

- (void)setLabelText:(NSString *)item value:(NSString *)value {
    [self.lb_item setText:item];
    [self.lb_value setText:value];
}

- (void) setLabelSingleText:(NSString *)item {
    [self.lb_value setHidden:YES];
    
//    CGFloat yy = self.contentView.center.y - self.lb_item.bounds.size.height*2/3 ;
//    CGFloat xx = self.lb_item.frame.origin.x;
//    CGFloat ww = self.lb_item.frame.size.width;
//    CGFloat hh = self.lb_item.frame.size.height;
//    
//    [self.lb_item removeFromSuperview];
//    self.lb_item = [[UILabel alloc]initWithFrame:CGRectMake(xx, yy, ww, hh)];
    [self.lb_item setText:item];
//    [self.contentView addSubview: self.lb_item];
}

@end
