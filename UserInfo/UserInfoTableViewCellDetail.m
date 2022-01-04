//
//  UserInfoTableViewCellDetail.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/29/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "UserInfoTableViewCellDetail.h"
#import "public.h"

@implementation UserInfoTableViewCellDetail {
    IBOutlet UIImageView * iv_icon;
    IBOutlet UILabel * la_title;
}

- (void)awakeFromNib {
    [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_bg"]]];
    [la_title setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE2]];
    [la_title setTextColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setCellWithIcon:(NSString *)icon Title:(NSString *)title {
    [iv_icon setImage:[UIImage imageNamed:icon]];
    [la_title setText:title];
}

@end
