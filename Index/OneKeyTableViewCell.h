//
//  OneKeyTableViewCell.h
//  G-NetLink-v1.0
//
//  Created by jk on 12/10/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneKeyTableViewCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UILabel * value;
@property(nonatomic, retain) IBOutlet UIImageView * image;

- (void) setSingleCell:(NSString *)imageName Value:(NSString *)titleValue;

@end
