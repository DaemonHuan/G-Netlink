//
//  TravelLogTableViewCell.h
//  G-Netlink-beta0.2
//
//  Created by jk on 11/2/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelLogTableViewCell : UITableViewCell {
}

- (void) setTime:(NSString*) start endtime:(NSString*) end;
- (void) setItemCount:(NSString *)value;
- (void) setMessage:(NSString*) location Destination:(NSString*) destination;

@end
