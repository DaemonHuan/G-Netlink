//
//  UserInfoTableViewCellWithMsg.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/29/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "UserInfoTableViewCellWithMsg.h"
#import "public.h"

@implementation UserInfoTableViewCellWithMsg {
    IBOutlet UIImageView * iv_icon;
    IBOutlet UILabel * la_title;
    IBOutlet UILabel * la_value;
}

- (void)awakeFromNib {
    [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_bg"]]];
    [la_title setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE2]];
    [la_title setTextColor:[UIColor whiteColor]];
    [la_value setFont:[UIFont fontWithName:FONT_XI size:FONT_S_TITLE2]];
    [la_value setTextColor:[UIColor whiteColor]];
    la_value.textAlignment = NSTextAlignmentRight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setCellWithTitle:(NSString *) title Icon:(NSString *)icon Value:(NSString *)value {
    [iv_icon setImage:[UIImage imageNamed:icon]];
    [la_title setText:title];
    [la_value setText:value];
}

@end
