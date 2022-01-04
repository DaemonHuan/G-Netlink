//
//  DestinationDetailView.m
//  G-Netlink-beta0.2
//
//  Created by jk on 11/5/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "DestinationDetailView.h"
#import "public.h"

#import "GNLUserInfo.h"
#import "GetPostSessionData.h"
#import "jkAlertController.h"
#import "UIColor+Hex.h"

@interface DestinationDetailView () <PostSessionDataDelegate> {
    GetPostSessionData * postSession;
    NSString * platitude;
    NSString * plongitude;
    NSString * destinationName;
    
    UIButton * mbt_send;
    
    jkAlertController * m_alert;
}

@end

@implementation DestinationDetailView

- (void) loadView {
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    CGFloat sh = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, 0.75 * sh, sw, 0.3 * sh);
    [self setBackgroundColor:[UIColor colorWithHexString: BackGroudColor]];
    [self setHidden: YES];
    
    mbt_send = [[UIButton alloc]initWithFrame:CGRectMake(0.5*sw - 70.0f, 10.0f, 140.0f, 35.0f)];
    [mbt_send setTitle:@"" forState: UIControlStateNormal];
    [mbt_send setTitleColor:[UIColor colorWithHexString: WordColor] forState:UIControlStateNormal];
    [mbt_send setBackgroundImage:[UIImage imageNamed:@"destination_send"] forState:UIControlStateNormal];
    [mbt_send addTarget:self action:@selector(doSendDestination) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mbt_send];
    
    UIImageView * line = [[UIImageView alloc]initWithFrame:CGRectMake(30.0f, 55.0f, sw - 60.0f, 1.0f)];
    [line setImage:[UIImage imageNamed:@"public_seperateline02"]];
    [self addSubview: line];
    
    UIImageView * im_icon = [[UIImageView alloc]initWithFrame:CGRectMake(35.0f, 70.0f, 40.0f, 50.0f)];
    [im_icon setImage:[UIImage imageNamed:@"map_normalpoint"]];
    [self addSubview:im_icon];
    
    lb_title1 = [[UILabel alloc]initWithFrame:CGRectMake(100.0f, 75.0f, sw - 120.0f, 30.0f)];
    lb_title1.adjustsFontSizeToFitWidth = YES;
    [lb_title1 setTextColor:[UIColor whiteColor]];
    [lb_title1 setFont:[UIFont fontWithName:FONT_MM size:18.0f]];
    
    lb_title2 = [[UILabel alloc]initWithFrame:CGRectMake(100.0f, 100.0f, sw - 100.0f, 30.0f)];
    lb_title2.adjustsFontSizeToFitWidth = YES;
    [lb_title2 setTextColor:[UIColor whiteColor]];
    [lb_title2 setFont:[UIFont fontWithName:FONT_MM size:15.0f]];
//    [lb_title2 setLineBreakMode:NSLineBreakByCharWrapping];
//    [lb_title2 setNumberOfLines:0];
    
    [self addSubview:lb_title1];
    [self addSubview:lb_title2];
    
    postSession = [[GetPostSessionData alloc]init];
    postSession.delegate = self;
}

- (void) doSendDestination {
//    [mbt_send setTitle:@"目的地下发中 .." forState: UIControlStateNormal];
//    NSLog(@"do send ..");
    m_alert = [[jkAlertController alloc] initWithLoadingGif:@"指令下发中 .."];
    [m_alert show];

    NSString * url = [NSString stringWithFormat:@"%@/api/sendPOIToCar", HTTP_GET_POST_ADDRESS];
    NSString * body = [NSString stringWithFormat:@"accessToken=%@&vin=%@&poiName=%@&poiLontitude=%@&poiLatitude=%@&isdemo=%@", [GNLUserInfo accessToken], [GNLUserInfo defaultCarVin], destinationName,  plongitude, platitude, [GNLUserInfo isDemo] ? @"true" : @"false"];
    
    [postSession SendPostSessionRequest:url Body:body];
}

- (void) didPostSessionRequest:(NSString *)request {
    NSLog(@"send destination .. %@", request);
    NSDictionary * dicdata = [postSession getDictionaryFromRequest];
    NSString * flag = [[dicdata objectForKey:@"status"] objectForKey:@"description"];
    if ([flag isEqualToString:@"Success"]) {
        [m_alert close];
        m_alert = [[jkAlertController alloc] initWithOKButton:@"指令执行成功!"];
        [m_alert show];
    }
    else {
        [m_alert close];
        m_alert = [[jkAlertController alloc] initWithOKButton:@"指令执行失败。"];
        [m_alert show];
    }
}

- (void) setGeoPoint:(NSString *)latitude Longitude:(NSString *)longitude {
    platitude = latitude;
    plongitude = longitude;
}

- (void) setTitle:(NSString *)title1 title2:(NSString *)title2 {
    [lb_title1 setText:title1];
    [lb_title2 setText:title2];
    
    destinationName = title1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
