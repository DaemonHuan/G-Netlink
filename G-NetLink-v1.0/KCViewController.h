//
//  KCViewController.h
//  gnl
//
//  Created by jk on 1/4/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "RootViewController.h"
// 15605842516

@protocol KCLoginDelegate <NSObject>
- (void) doKCLoginActions:(NSInteger) flag;
@end


@interface KCViewController : RootViewController {
    id<KCLoginDelegate> delegate;
}

@property (nonatomic, retain) id<KCLoginDelegate> delegate;

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;

- (void) douserlogin;

@end
