//
//  VehicleTableViewCell.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/7/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "VehicleTableViewCell.h"
#import "public.h"

@implementation VehicleTableViewCell {
    IBOutlet UILabel * la_itemname;
    IBOutlet UILabel * la_code;
    IBOutlet UIImageView * im_status;
}

- (void)awakeFromNib {
    [self setBackgroundColor:[UIColor clearColor]];
    
    [la_itemname setText:@""];
    [la_itemname setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE2]];
    [la_itemname setTextColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setItemValue:(NSString *)name Checked:(BOOL)value {
    [la_itemname setText:name];
    [im_status setHidden: !value];
}

- (void) setItemCode:(NSString *)code {
    [la_code setText: code];
}

@end
