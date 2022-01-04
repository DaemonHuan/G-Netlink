//
//  RefreshView.m
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



#import "SampleRefreshView.h"

@implementation SampleRefreshView {
    UILabel * title;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
       
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];

    _imageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.image=[UIImage imageNamed:@"public_circle"];
    _imageView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_imageView];
    
    
    NSLayoutConstraint * centX=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-40];
    NSLayoutConstraint * width=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:32];
    NSLayoutConstraint *bottom=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-8];
    NSLayoutConstraint *height=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:32];
    
    NSArray * list=@[centX,width,bottom,height];
    
    [self addConstraints:list];
    
    
    title=[[UILabel alloc] initWithFrame:CGRectZero];
    [title setTextColor: [UIColor whiteColor]];
    title.backgroundColor=[UIColor clearColor];
    title.font=[UIFont systemFontOfSize:17];
    title.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:title];
    
    NSLayoutConstraint * tLeft=[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint * tBottom=[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    NSLayoutConstraint * tRight=[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint * tHeight=[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:32];
    
    NSArray * tList=@[tLeft,tBottom,tRight,tHeight];
    
    [self addConstraints:tList];
    
    [self reset];
    
}


- (void)reset
{
    [super reset];
    
    [self resetViews];
}


- (void)resetViews
{
    [UIView animateWithDuration:0.25 animations:^{
        _imageView.transform=CGAffineTransformIdentity;
        _imageView.image=[UIImage imageNamed:@"public_circle"];
        [title setText: kDJRefreshTopTypeDefine];
    }];
    
}


- (void)canEngageRefresh
{
    [super canEngageRefresh];
    
    [UIView animateWithDuration:0.25 animations:^{
        _imageView.transform=CGAffineTransformMakeRotation(M_PI);
        [title setText: kDJRefreshTopTypeCanRefresh];
    }];
    
}

- (void)startRefreshing
{
    [super startRefreshing];
    
    _imageView.image=[UIImage imageNamed:@"public_circle"];
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatDuration=INFINITY;
    
    [title setText: kDJRefreshTopTypeRefreshing];
    
    [_imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}
- (void)finishRefreshing
{
    [super finishRefreshing];
    
    [_imageView.layer removeAnimationForKey:@"rotationAnimation"];
    _imageView.transform=CGAffineTransformIdentity;
    _imageView.image=[UIImage imageNamed:@"public_circle"];
    
}


@end
