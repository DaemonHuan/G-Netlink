//
//  testVersionAndNotificationViewController.h
//  G-NetLink
//
//  Created by jayden on 14-4-22.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseViewController.h"
#import "ClientVersion.h"
#import "NotificationNews.h"

@interface testVersionAndNotificationViewController : BaseViewController
{
    @protected
    ClientVersion *clientVersion;
    NotificationNews *notificationNews;
}

- (IBAction)btn_back_click:(id)sender;

- (IBAction)btn_getNewVersion_click:(id)sender;
- (IBAction)btn_getCount_click:(id)sender;
- (IBAction)btn_getNotifications_click:(id)sender;
- (IBAction)btn_setNotRead_click:(id)sender;
- (IBAction)btn_deleteNot_click:(id)sender;
@end
