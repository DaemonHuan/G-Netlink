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

#import "DJRefreshTopView.h"

@implementation DJRefreshTopView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self setup];
    }
    
    return self;
}

- (void)setup{
    
    self.backgroundColor=[UIColor clearColor];
    
//    _activityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    _activityIndicatorView.hidesWhenStopped=YES;
//    _activityIndicatorView.translatesAutoresizingMaskIntoConstraints=NO;
//    [self addSubview:_activityIndicatorView];
    
//    NSLayoutConstraint * aBottom=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
//    NSLayoutConstraint * aRight=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-5];
//    NSLayoutConstraint * aWith=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:35];
//    NSLayoutConstraint * aHeight=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:35];
    
//    NSArray * aList=@[aBottom,aRight,aWith,aHeight];
    
//    [self addConstraints:aList];
    
    
    _imageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.image=[UIImage imageNamed:@"public_circle"];
    _imageView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_imageView];
    
    
    NSLayoutConstraint * centX=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-60.0f];
    NSLayoutConstraint * width=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:32];
    NSLayoutConstraint *bottom=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-8];
    NSLayoutConstraint *height=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:32];
    
    NSArray * list=@[centX,width,bottom,height];
    
    [self addConstraints:list];
    
    
    
    _promptLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _promptLabel.backgroundColor=[UIColor clearColor];
    [_promptLabel setTextColor: [UIColor whiteColor]];
    _promptLabel.font=[UIFont systemFontOfSize:17];
    _promptLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_promptLabel];
    
    NSLayoutConstraint * tLeft=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-25.0f];
    NSLayoutConstraint * tBottom=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    NSLayoutConstraint * tRight=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint * tHeight=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:32];
    
    NSArray * tList=@[tLeft,tBottom,tRight,tHeight];
    
    [self addConstraints:tList];
    
    
    [self reset];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
///重新布局
- (void)reset{
    [super reset];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _imageView.hidden=NO;
        [UIView animateWithDuration:0.25 animations:^{
//            _imageView.transform=CGAffineTransformIdentity;
            _imageView.transform=CGAffineTransformIdentity;
            _imageView.image=[UIImage imageNamed:@"public_circle"];
        }];
//        if ([_activityIndicatorView isAnimating])
//        {
//            [_activityIndicatorView stopAnimating];
//        }
        _promptLabel.text = kDJRefreshTopTypeDefine;
    });
    
}

///松开可刷新
- (void)canEngageRefresh{
    [super canEngageRefresh];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _promptLabel.text = kDJRefreshTopTypeCanRefresh;
        [UIView animateWithDuration:0.25 animations:^{
            _imageView.transform=CGAffineTransformMakeRotation(M_PI);
        }];
    });
}

- (void)didDisengageRefresh{
    [self reset];
}

///开始刷新
- (void)startRefreshing{
    [super startRefreshing];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _promptLabel.text = kDJRefreshTopTypeRefreshing;
        _imageView.transform=CGAffineTransformIdentity;
//        [_activityIndicatorView startAnimating];
//        _imageView.hidden=YES;

        //
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 0.5;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatDuration=INFINITY;
        
        [_imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
   
}

- (void)finishRefreshing{
    [super finishRefreshing];
    [_imageView.layer removeAnimationForKey:@"rotationAnimation"];
    _imageView.transform=CGAffineTransformIdentity;
    [self reset];
}


@end
