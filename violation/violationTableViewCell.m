//
//  violationTableViewCell.m
//  G-Netlink-beta0.2
//
//  Created by jk on 11/19/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "violationTableViewCell.h"
#import "public.h"

@interface violationTableViewCell () {
    IBOutlet UILabel * lb_title;
    IBOutlet UILabel * lb_time;
    IBOutlet UILabel * lb_payValue;
    IBOutlet UILabel * lb_payMoney;
    IBOutlet UILabel * lb_detail;
}

@end

@implementation violationTableViewCell

- (void)awakeFromNib {
    [lb_title setFont:[UIFont fontWithName:FONT_MM size:18.0f]];
    [lb_title setTextColor: [UIColor colorWithHexString: WordColor]];
    [lb_detail setFont:[UIFont fontWithName:FONT_MM size:16.0f]];
    [lb_time setFont:[UIFont fontWithName:FONT_XI size:14.0f]];
    [lb_payValue setFont:[UIFont fontWithName:FONT_MM size:14.0f]];
    [lb_payMoney setFont:[UIFont fontWithName:FONT_MM size:14.0f]];
    
    [lb_detail setLineBreakMode:NSLineBreakByWordWrapping];
    lb_detail.numberOfLines = 0;

    self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCellDetail: (NSString *)title Detail:(NSString *)detail {
    [lb_title setText:title];
    [lb_detail setText:detail];
}

- (void) setCellValue:(NSString *)time Value:(NSString *)value Pay:(NSString *)money {
    
    double sep = [time doubleValue];
    NSDate * date = [[NSDate alloc] initWithTimeIntervalSince1970:sep];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
//    NSLog(@"date :: %@", date);
    [lb_time setText: [formatter stringFromDate:date]];
    [lb_payValue setText: [NSString stringWithFormat:@"%@分", value]];
    [lb_payMoney setText: [NSString stringWithFormat:@"%@元", money]];
}

@end
