//
//  OneKeyTableViewCell.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/10/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "OneKeyTableViewCell.h"
#import "public.h"

@implementation OneKeyTableViewCell {
}

- (void)awakeFromNib {
    [self.value setFont:[UIFont fontWithName:FONT_MM size:17.0f]];
    [self.value setTextColor: [UIColor whiteColor]];
    self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setSingleCell:(NSString *)imageName Value:(NSString *)titleValue {
    [self.image setImage: [UIImage imageNamed: imageName]];
    [self.value setText: titleValue];
}

@end
