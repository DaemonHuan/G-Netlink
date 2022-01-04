//
//  AlertViewForWarnDetail.m
//  G-NetLink-v2.0
//
//  Created by jk on 7/11/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "AlertViewForWarnDetail.h"
#import "public.h"

@implementation AlertViewForWarnDetail {
    UILabel * la_msg;
    NSTimer * m_Timer;
}

- (id) init {
    if (self = [super init]) {
        // config top
        CGFloat wx = [UIScreen mainScreen].bounds.size.width;
        CGFloat hy = [UIScreen mainScreen].bounds.size.height;
        
        self.backgroundColor = [UIColor clearColor];
        [self setFrame:CGRectMake(0.0f, 64.0f, wx, hy - 64.0f)];
//
        CGFloat hh = (hy - 64.0f) * 0.5f;
        CGRect centorRect = CGRectMake(30.0f, hh - 45.0f, wx - 60.0f, 90.0f);
        UIImageView * bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warn_detail"]];
        [bg setFrame:centorRect];
        [self addSubview: bg];

        la_msg = [[UILabel alloc] initWithFrame:centorRect];
        la_msg.textColor = [UIColor whiteColor];
        [la_msg setFrame:CGRectMake(40.0f, hh - 40.0f, wx - 80.0f, 80.0f)];
        [la_msg setText: @"TEEEESDSFLKJSD:JF:LSDJF:JDS:FJ:SDJ:FKJ"];
        [la_msg setLineBreakMode:NSLineBreakByWordWrapping];
        [la_msg setNumberOfLines:2];
        [la_msg setFont:[UIFont fontWithName:FONT_MM size:17.0f]];
        la_msg.adjustsFontSizeToFitWidth = YES;
        [self addSubview: la_msg];

        
        [self setHidden:YES];
    }
    return self;
}

- (void) setTextShow:(NSString *)msg {
    [la_msg setText: msg];
    [self setHidden: NO];
    
    m_Timer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(doHidden:) userInfo:nil repeats: YES];
    [[NSRunLoop mainRunLoop]addTimer:m_Timer forMode:NSDefaultRunLoopMode];
}

- (IBAction) doHidden:(id)sender {
    [m_Timer invalidate];
    [self setHidden: YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
