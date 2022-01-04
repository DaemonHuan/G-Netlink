//
//  HomePageTableViewCell.h
//  G-Netlink-beta0.2
//
//  Created by jk on 11/2/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageTableViewCell : UITableViewCell {
    
}

@property (nonatomic, retain) IBOutlet UIImageView * image_itemIcon;
@property (nonatomic, retain) IBOutlet UILabel * lb_item;
@property (nonatomic, retain) IBOutlet UILabel * lb_value;

- (void) setLabelIcon: (NSString*) iconname;
- (void) setLabelText: (NSString*) item value:(NSString*)value;
- (void) setLabelSingleText:(NSString *)item;

@end
