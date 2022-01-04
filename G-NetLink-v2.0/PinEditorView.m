//
//  PinEditorView.m
//  G-NetLink-v2.0
//
//  Created by jk on 4/6/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "PinEditorView.h"
#import "public.h"

@implementation PinEditorView {
    UITextField * textfield;
}

@synthesize bt_OK, bt_NO, code;

- (id) init {
    if (self = [super init]) {
        CGFloat wx = [UIScreen mainScreen].bounds.size.width;
        CGFloat hx = [UIScreen mainScreen].bounds.size.height;
        
        self.backgroundColor = [UIColor clearColor];
        [self setFrame:CGRectMake(0.0f, 0.0f, wx, hx)];
        
        UIControl * controller = [[UIControl alloc]initWithFrame:CGRectMake(0.0f, 0.0f, wx, hx)];
        [controller addTarget:self action:@selector(textfield_TouchDown:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:controller];
        
        CGFloat tw = wx * 0.8f;
        CGFloat th = (hx - 64.0f) * 0.3f;
        UIView * centerView = [[UIView alloc]initWithFrame:CGRectMake((wx - tw) * 0.5f, (hx - th) * 0.5f, tw, th)];
        [centerView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView * bg = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, tw, th)];
        [bg setImage:[UIImage imageNamed:@"public_alertview1"]];
        [centerView addSubview:bg];
        [self addSubview:centerView];
        
        CGRect frame0 = CGRectMake(8.0f, 8.0f, tw - 16.0f, th * 0.3f);
        UILabel * label = [[UILabel alloc]initWithFrame:frame0];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:@"请输入PIN码"];
        [label setFont: [UIFont fontWithName:FONT_XI size:FONT_S_TITLE1]];
        [centerView addSubview:label];
        
        CGRect frame1 = CGRectMake(8.0f, th * 0.3f + 16.0f, tw - 16.0f, th * 0.3f - 16.0f);
        textfield = [[UITextField alloc]initWithFrame:frame1];
        [textfield setBackground:[UIImage imageNamed:@"vctl_textfield"]];
        [textfield setBorderStyle:UITextBorderStyleNone];
        [textfield addTarget:self action:@selector(setTextFieldForCode:) forControlEvents:UIControlEventEditingChanged];
        [textfield addTarget:self action:@selector(setTextFieldForCode:) forControlEvents:UIControlEventEditingDidEnd];
        [textfield addTarget:self action:@selector(textfield_didEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [centerView addSubview: textfield];
        
        CGFloat width = tw / 2.0f - 16.0f;
        CGRect frame2 = CGRectMake(8.0f, th * 0.7f, width, th * 0.3f);
        CGRect frame3 = CGRectMake(width + 24.0f, th * 0.7f, width, th * 0.3f);
        
        self.bt_NO = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bt_NO.frame = frame2;
        [self.bt_NO.titleLabel setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE1]];
        [self.bt_NO setTitle:@"取 消" forState:UIControlStateNormal];
        [centerView addSubview: self.bt_NO];
        
        self.bt_OK = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bt_OK.frame = frame3;
        [self.bt_OK setTitleColor:[UIColor colorWithHexString:WORD_COLOR_GLODEN] forState:UIControlStateNormal];
        [self.bt_OK.titleLabel setFont:[UIFont fontWithName:FONT_MM size:FONT_S_TITLE1]];
        [self.bt_OK setTitle:@"确 定" forState:UIControlStateNormal];
        [centerView addSubview:bt_OK];
    }
    
    return self;
}

- (IBAction) setTextFieldForCode:(id)sender {
    self.code = textfield.text;
//    NSLog(@"code = %@", self.code);
}

- (void) showView {
    [textfield setText:@""];
    [self setHidden: NO];
}

- (void) hideView {
    [self setHidden: YES];
}

// 隐藏键盘.
- (IBAction) textfield_didEdit:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction) textfield_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
