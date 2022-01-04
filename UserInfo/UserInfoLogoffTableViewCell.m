//
//  UserInfoLogoffTableViewCell.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/29/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "UserInfoLogoffTableViewCell.h"

@implementation UserInfoLogoffTableViewCell

- (void)awakeFromNib {
    [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_bg"]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
