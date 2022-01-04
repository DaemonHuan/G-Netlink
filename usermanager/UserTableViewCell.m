//
//  UserTableViewCell.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/14/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "UserTableViewCell.h"
#import "public.h"

@implementation UserTableViewCell {
    IBOutlet UIImageView * im_icon;
    IBOutlet UILabel * la_title;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setCellValue: (NSString *)imageName TitleName:(NSString *)title {
    [im_icon setImage: [UIImage imageNamed:imageName]];
    [la_title setText: title];
    [la_title setFont: [UIFont fontWithName:FONT_MM size:17.0f]];
}

@end
