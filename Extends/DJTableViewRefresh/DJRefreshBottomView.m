//
//  DJRefresh.h
//
//  Copyright (c) 2014 YDJ ( https://github.com/ydj/DJRefresh )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "DJRefreshBottomView.h"

@implementation DJRefreshBottomView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self setup];
    }
    
    return self;
}



- (void)setup{
    
//    self.backgroundColor=[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:237.0/255.0];
    self.backgroundColor = [UIColor clearColor];
    
    _activityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped=YES;
    _activityIndicatorView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_activityIndicatorView];
    
    _promptLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _promptLabel.backgroundColor = [UIColor clearColor];
    _promptLabel.textColor = [UIColor whiteColor];
    _promptLabel.font=[UIFont systemFontOfSize: 15];
    _promptLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_promptLabel];

    NSLayoutConstraint *promptLabelTop=[NSLayoutConstraint constraintWithItem:_promptLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:13];
    NSLayoutConstraint *promptLabelCenterX=[NSLayoutConstraint constraintWithItem:_promptLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self addConstraints:@[promptLabelTop,promptLabelCenterX]];
    
    /////
    NSLayoutConstraint * activityTop=[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:10];
    NSLayoutConstraint * activityRight=[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_promptLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:-20];
    [self addConstraints:@[activityTop,activityRight]];
    
    [self reset];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
///????????????
- (void)reset{
    [super reset];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _promptLabel.text=kDJRefreshBottomTypeDefine;
        if ([_activityIndicatorView isAnimating])
        {
            [_activityIndicatorView stopAnimating];
        }
    });
    
}

- (void)didDisengageRefresh{
    [self reset];
}

///???????????????
- (void)canEngageRefresh{
    [super canEngageRefresh];
    
    _promptLabel.text=kDJRefreshBottomTypeCanRefresh;
}

///????????????
- (void)startRefreshing{
    [super startRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^{
        _promptLabel.text=kDJRefreshBottomTypeRefreshing;
        [self.activityIndicatorView startAnimating];
    });
   
}

- (void)finishRefreshing{
    [super finishRefreshing];
    
    [self reset];
}




@end
