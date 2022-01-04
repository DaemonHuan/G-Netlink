//
//  CustomActivityIndicatorView.m
//  ZhiJiaX
//
//  Created by 95190 on 13-6-6.
//  Copyright (c) 2013年 95190. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "CustomActivityIndicatorView.h"
#define ActivityIndicatorViewWidth   60
#define ActivityIndicatorViewHeight  60

@implementation CustomActivityIndicatorView
@synthesize color = _color;
@synthesize showText = _showText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-ActivityIndicatorViewWidth/2,self.bounds.size.height/2-ActivityIndicatorViewHeight/2,ActivityIndicatorViewWidth,ActivityIndicatorViewHeight)];
        _backgroundView.layer.masksToBounds = YES;
        _backgroundView.layer.cornerRadius = 6.0;
        _backgroundView.layer.borderWidth = 0.7;
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
        
        
        activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(_backgroundView.bounds.size.width/2-ActivityIndicatorViewWidth/2,_backgroundView.bounds.size.height/2-ActivityIndicatorViewHeight/2,ActivityIndicatorViewWidth,ActivityIndicatorViewHeight)];
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [_backgroundView addSubview:activityIndicatorView];
        
        
        self.hidden = YES;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)startAnimating
{
    self.hidden = NO;
    [activityIndicatorView startAnimating];
}
-(void)stopAnimating
{
    self.hidden = YES;
    [activityIndicatorView stopAnimating];
}
-(BOOL)isAnimating
{
    return [activityIndicatorView isAnimating];
}
-(void)setColor:(UIColor *)color
{
    _color = color;
    _backgroundView.backgroundColor = color;
}
-(void)setShowText:(NSString *)showText
{
    _showText = showText;
    
    if(_showText==nil)
    {
        if(_lbl_text!=nil)
        {
            _backgroundView.frame = CGRectMake((self.bounds.size.width-ActivityIndicatorViewWidth) / 2,(self.bounds.size.height-ActivityIndicatorViewHeight)/2,ActivityIndicatorViewWidth,ActivityIndicatorViewHeight);
            
            activityIndicatorView.frame = CGRectMake(_backgroundView.bounds.size.width/2-ActivityIndicatorViewWidth/2,_backgroundView.bounds.size.height/2-ActivityIndicatorViewHeight/2,ActivityIndicatorViewWidth,ActivityIndicatorViewHeight);
            [_lbl_text removeFromSuperview];
            _lbl_text = nil;
        }
        return;
    }
    
    CGSize size = [_showText sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, MAXFLOAT)  lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect backgroundViewFrame = _backgroundView.frame;
    backgroundViewFrame.size.width = size.width + 20;
    backgroundViewFrame.size.height = size.height+activityIndicatorView.bounds.size.height+20;
    backgroundViewFrame.origin.x = (self.bounds.size.width - backgroundViewFrame.size.width) * 0.5;
    backgroundViewFrame.origin.y = (self.bounds.size.height - backgroundViewFrame.size.height) * 0.5;
    _backgroundView.frame = backgroundViewFrame;
    
    CGRect activityIndicatorViewFrame = activityIndicatorView.frame;
    activityIndicatorViewFrame.origin.x = (backgroundViewFrame.size.width - activityIndicatorViewFrame.size.width) / 2;
    activityIndicatorViewFrame.origin.y = 10;
    activityIndicatorView.frame = activityIndicatorViewFrame;
    
    _lbl_text = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(activityIndicatorViewFrame),size.width, size.height)];
    _lbl_text.backgroundColor = [UIColor clearColor];
    _lbl_text.textAlignment = NSTextAlignmentCenter;
    _lbl_text.text = _showText;
    _lbl_text.font = [UIFont systemFontOfSize:15];
    _lbl_text.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f  blue:153.0f/255.0f  alpha:1];
    _lbl_text.numberOfLines = 0;
    [_backgroundView addSubview:_lbl_text];
}
-(void)setAlpha:(CGFloat)alpha
{
    _backgroundView.alpha = alpha;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
