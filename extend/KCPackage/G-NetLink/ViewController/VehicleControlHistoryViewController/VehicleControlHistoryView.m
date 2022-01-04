//
//  VehicleControlHistoryView.m
//  G-NetLink
//
//  Created by jayden on 14-4-24.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleControlHistoryView.h"
@interface VehicleControlHistoryView()
{
    UILabel *date;
    CustomUIDatePicker *customUIDatePicker;
}
-(IBAction)btnDate_click:(id)sender;
@end
@implementation VehicleControlHistoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentData=[NSDate date];
        
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"VehicleControlHistoryTitle", Res_String, @"");
        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_home",Res_Image,@"")];
        CGRect frame=_customTitleBar.frame;
        double y=frame.size.height/2;
        frame.size.height+=y;
        _customTitleBar.frame=frame;
        
        CGRect tableFrame=_tableView.frame;
        tableFrame.origin.y+=y;
        _tableView.frame=tableFrame;
        
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        UIButton *dateBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2-73,_customTitleBar.frame.size.height-25, 146, 20)];
        dateBtn.userInteractionEnabled=YES;
        [dateBtn addTarget:self action:@selector(btnDate_click:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *dateTitle=[[UILabel alloc] initWithFrame:CGRectMake(-1, dateBtn.frame.size.height/2-6, 60, 12)];
        dateTitle.textAlignment=UITextAlignmentCenter;
        dateTitle.font=[UIFont systemFontOfSize:12];
        dateTitle.textColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
        dateTitle.backgroundColor = [UIColor clearColor];
        dateTitle.text=NSLocalizedStringFromTable(@"DateTitle",Res_String,@"");
        [dateBtn addSubview:dateTitle];
        date=[[UILabel alloc] initWithFrame:CGRectMake(dateTitle.frame.origin.x+dateTitle.frame.size.width+5, dateBtn.frame.size.height/2-6, 65, 12)];
        date.font=[UIFont systemFontOfSize:12];
        date.textColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
        date.backgroundColor = [UIColor clearColor];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        date.text=  [dateFormatter stringFromDate:_currentData];
        [dateBtn addSubview:date];
        
        UIImage *image=[UIImage imageNamed:NSLocalizedStringFromTable(@"btn_date_select",Res_Image,@"")];
        UIImageView *dateImageView=[[UIImageView alloc]initWithFrame:CGRectMake(date.frame.origin.x+date.frame.size.width+5, date.frame.origin.y+4, image.size.width, image.size.height)];
        dateImageView.image=image;
        [dateBtn addSubview:dateImageView];
        [self addSubview:dateBtn];
        
        image = [UIImage imageNamed:NSLocalizedStringFromTable(@"history_back",Res_Image,@"")];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(5,5,image.size.height-10,image.size.width-10)]];
        backgroundImageView.contentMode    = UIViewContentModeScaleToFill;
        backgroundImageView.userInteractionEnabled = YES;
        CGRect backgroundImageViewFrame = backgroundImageView.frame;
        backgroundImageViewFrame.size.width = self.bounds.size.width;
        backgroundImageViewFrame.size.height = self.bounds.size.height;
        backgroundImageView.frame = backgroundImageViewFrame;
        [self insertSubview:backgroundImageView atIndex:0];
//     
        UIImage *g_NetLinkImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
        UIImageView *bottomitemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - g_NetLinkImage.size.height,self.bounds.size.width , g_NetLinkImage.size.height)];
        bottomitemImageView.image = g_NetLinkImage;
        bottomitemImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomitemImageView];
    }
    return self;
}

-(void)btnDate_click:(id)sender
{
    if (!customUIDatePicker) {
         customUIDatePicker = [[CustomUIDatePicker alloc] initWithBottom];
    }
    customUIDatePicker.endDate = [NSDate date];
    customUIDatePicker.backgroundColor=[UIColor clearColor];
    customUIDatePicker.observer = self.eventObserver;
    if(_currentData != nil)
        customUIDatePicker.date = _currentData;
    
    [self addSubview:customUIDatePicker];
}

-(void)setCurrentData:(NSDate *)currentData
{
    _currentData=currentData;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    date.text=  [dateFormatter stringFromDate:currentData];
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
