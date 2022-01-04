//
//  TravelLogRangeViewController.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/13/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "TravelLogRangeViewController.h"
#import "public.h"


@interface TravelLogRangeViewController ()

@end

@implementation TravelLogRangeViewController {
    IBOutlet UILabel * la_startTime;
    IBOutlet UIButton * bt_setStartTime;
    IBOutlet UILabel * la_endTime;
    IBOutlet UIButton * bt_setEndTime;
    IBOutlet UIButton * bt_reset;
    IBOutlet UIDatePicker * dp_dateSelector;
    IBOutlet UIView * vi_datePicker;
    
    NSInteger m_flag;
}

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"日志范围"];
    
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    [leftitem setTintColor: [UIColor colorWithHexString: WORD_COLOR_BLUE]];
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finished:)];
    [rightitem setTintColor: [UIColor colorWithHexString: WORD_COLOR_BLUE]];
    self.navigationItem.leftBarButtonItem = leftitem;
    self.navigationItem.rightBarButtonItem = rightitem;
    
    [bt_setStartTime setTag:1000];
    [la_startTime setFont: [UIFont fontWithName:FONT_XI size:FONT_S_WORD]];
    [la_startTime setTextAlignment:NSTextAlignmentRight];
    [bt_setEndTime setTag:1001];
    [la_endTime setFont: [UIFont fontWithName:FONT_XI size:FONT_S_WORD]];
    [la_endTime setTextAlignment:NSTextAlignmentRight];

    dp_dateSelector.datePickerMode = UIDatePickerModeDate;
    [dp_dateSelector setBackgroundColor:[UIColor clearColor]];
    [dp_dateSelector setValue:[UIColor whiteColor] forKey:@"textColor"];
    [dp_dateSelector setTintColor:[UIColor whiteColor]];
    [dp_dateSelector setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [dp_dateSelector setEnabled:YES];       // this is enabled in ios 10.  2016.11.30
    [dp_dateSelector addTarget:self action:@selector(didDateEdit:) forControlEvents:UIControlEventValueChanged];
    [dp_dateSelector setMaximumDate:[NSDate date]];
    [vi_datePicker setHidden:YES];
    
    SEL selector = NSSelectorFromString(@"setHighlightsToday:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:dp_dateSelector];

}

- (void) viewWillAppear:(BOOL)animated {
    [vi_datePicker setHidden:YES];
    m_flag = 0;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [la_startTime setText: [formatter stringFromDate:self.startTime]];
    [la_endTime setText: [formatter stringFromDate:self.endTime]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction) finished:(id)sender {
    NSDateFormatter * formartter = [[NSDateFormatter alloc] init];
    [formartter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    [formartter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSString * staDateStr = [NSString stringWithFormat:@"%@ 00:00:00",la_startTime.text];
    NSString * endDateStr = [NSString stringWithFormat:@"%@ 23:59:59", la_endTime.text];
    NSDate * staDate = [formartter dateFromString: staDateStr];
    NSDate * endDate = [formartter dateFromString: endDateStr];
    
    NSTimeInterval secondsInterval = [endDate timeIntervalSinceDate:staDate]
    ;
    NSLog(@"** choose Date : %@ ~ %@ %f", staDate, endDate, secondsInterval);
    
    // 时间范围小于 30 天
    if (secondsInterval / 86400.0f > 30.0f) {
        AlertBoxView * view = [[AlertBoxView alloc] initWithOKButton:@"时间间隔不要超过30天,\n请重新选择。"];
        [view show];
        return;
    }
    else if (secondsInterval >= 0) {
        [self.delegate showRangeForTravelLogs:staDateStr EndTime:endDateStr];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        AlertBoxView * view = [[AlertBoxView alloc] initWithOKButton:@"时间区间选择错误,\n请重新选择。"];
        [view show];
        return;
    }
}

- (IBAction) cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) setTime:(id)sender {
    UIButton * button = (UIButton *)sender;
    m_flag = button.tag;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    if (button.tag == bt_setStartTime.tag) {
        [dp_dateSelector setDate:[formatter dateFromString:la_startTime.text]];
    }
    else if (button.tag == bt_setEndTime.tag) {
        [dp_dateSelector setDate:[formatter dateFromString:la_endTime.text]];
    }
    
    [vi_datePicker setHidden:NO];
}

- (IBAction) didDateEdit:(id)sender {
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    
    NSDate * date = dp_dateSelector.date;
    NSString * res = [formatter stringFromDate: date];
    
    NSLog(@"%@ %@ %@", dp_dateSelector.date, [formatter stringFromDate:dp_dateSelector.date], [formatter stringFromDate:dp_dateSelector.date]);
    if (m_flag == bt_setStartTime.tag) {
        [la_startTime setText: res];
    }
    else if (m_flag == bt_setEndTime.tag) {
        [la_endTime setText: res];
    }
}

- (IBAction) didDateReset:(id)sender {
    [vi_datePicker setHidden:YES];
    m_flag = 0;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [la_startTime setText: [formatter stringFromDate:self.startTime]];
    [la_endTime setText: [formatter stringFromDate:self.endTime]];
}

- (IBAction) didView_TouchDown:(id)sender {
    [vi_datePicker setHidden:YES];
    m_flag = 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
