//
//  DateSelectorView.m
//  G-Netlink-beta0.2
//
//  Created by jk on 11/4/15.
//  Copyright © 2015 jk. All rights reserved.
//

#import "DateSelectorView.h"

@implementation DateSelectorView {
    BOOL startEdit;
    BOOL endEdit;
}

- (void) createView {
    [self setFrame:CGRectMake(0, 0, 280.0f, 320.0f)];
    startEdit = YES;
    endEdit = NO;
    
//    UIButton * allDone = [[UIButton alloc]initWithFrame:CGRectMake(200.0f, 8.0f, 60.0f, 30.0f)];
//    [allDone setTitle:@"DONE" forState:UIControlStateNormal];
//    [allDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [allDone setBackgroundColor:[UIColor greenColor]];
//    [allDone addTarget:self action:@selector(didchoose:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:allDone];
    UILabel * startLabel = [[UILabel alloc]initWithFrame:CGRectMake(8.0f, 10.0f, 70.0f, 30.0f)];
    [startLabel setText:@"开始日期"];
    UILabel * endLabel = [[UILabel alloc]initWithFrame:CGRectMake(8.0f, 50.0f, 70.0f, 30.0f)];
    [endLabel setText:@"结束日期"];
    
    [self addSubview:startLabel];
    [self addSubview:endLabel];
    
    tfStartTime = [[UITextField alloc] initWithFrame:CGRectMake(80.0f, 10.0f, 180.0f, 30.0f)];
    [tfStartTime setBorderStyle:UITextBorderStyleRoundedRect];
    [tfStartTime addTarget:self action:@selector(didtfStartEdit) forControlEvents:UIControlEventTouchDown];
    tfEndTime = [[UITextField alloc] initWithFrame:CGRectMake(80.0f, 50.0f, 180.0f, 30.0f)];
    [tfEndTime setBorderStyle:UITextBorderStyleRoundedRect];
    [tfEndTime addTarget:self action:@selector(didtfEndEdit) forControlEvents:UIControlEventTouchDown];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString * str = [formatter stringFromDate:[NSDate date]];
    [tfStartTime setText:str];
    [tfEndTime setText:str];
    
    [self addSubview:tfStartTime];
    [self addSubview:tfEndTime];
    
    DateSelector = [[UIDatePicker alloc]initWithFrame:CGRectMake(8.0f, 90.0f, 270.0f, 200.0f)];
    [DateSelector setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    DateSelector.datePickerMode = UIDatePickerModeDate;
    [DateSelector setEnabled:NO];
    [DateSelector addTarget:self action:@selector(didDateEdit) forControlEvents:UIControlEventValueChanged];
//    [self dsSetDateFromString:@"2014-10-27"];
    [self addSubview:DateSelector];
}


- (NSString *) getStartTime {
    NSLog(@"%@", tfStartTime.text);
    return  nil;
}

- (NSString *) getEndTime {
    NSLog(@"%@", tfEndTime.text);
    return nil;
}

- (void) didtfStartEdit {
    startEdit = YES;
    endEdit = NO;
    if (tfStartTime.text != nil && ![tfStartTime.text isEqual: @""]) {
        [self dsSetDateFromString:tfStartTime.text];
    }
}

- (void) didtfEndEdit {
    startEdit = NO;
    endEdit = YES;
    if (tfEndTime.text != nil && ![tfEndTime.text isEqual: @""]) {
        [self dsSetDateFromString:tfEndTime.text];
    }
}

- (void) dsSetDateFromString: (NSString*)str {
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *dateone=[formatter dateFromString:str];
    [DateSelector setDate:dateone];
}

- (NSString *) dsDateToString {
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString * res = [formatter stringFromDate:DateSelector.date];
    return res;
}

- (void) didDateEdit {
    if (startEdit) {
        [tfStartTime setText:[self dsDateToString]];
    }
    if (endEdit) {
        [tfEndTime setText:[self dsDateToString]];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
