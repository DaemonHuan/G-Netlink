//
//  NotificationCell.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-5-6.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "NotificationCell.h"
#import "ResDefine.h"


#define HEIGTH 50
@interface NotificationCell()
{
        UIButton *btn_select;
        UILabel * titleLabel;
        UILabel * textLabel;
        UIImageView * imageViewSelected;
}
-(IBAction)selectButton_onClick:(id)sender;
@end
@implementation NotificationCell
@synthesize textString,titleString;
@synthesize editStatus = _editStatus;
@synthesize selectStatus = _selectStatus;
@synthesize readStatus = _readStatus;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        _readStatus = YES;
        self.backgroundColor=[UIColor clearColor];
        imageViewSelected=[[UIImageView alloc]init];
        return self;
}
-(IBAction)selectButton_onClick:(id)sender
{
        if(!_editStatus)
        return;
        self.selectStatus =!_selectStatus;
        [self.observer selectButton_onClick:self];
}

-(void)setEditStatus:(BOOL)editStatus isRead:(BOOL)readStatus
{
    
    _editStatus=editStatus;
    UIImage*  select_img;
    if(_editStatus)
    {
        select_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"check_box_frame", Res_Image, @"")];
        _selectStatus=YES;
    }
    else
    {
        if (readStatus)
        {
            select_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"notification_readstatus", Res_Image, @"")];
        }
        else
        {
            select_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"cell_nav_logo", Res_Image, @"")];
        }
    }
    
    float ax = [UIScreen mainScreen].bounds.size.width;
    
    imageViewSelected.frame=CGRectMake(ax-select_img.size.width-10, self.frame.size.height/2-select_img.size.height/2, select_img.size.width, select_img.size.height);
    float  imgWidth = 30;
    float imgHeight = 20;
    

    
    if (readStatus)
    {
        imageViewSelected.frame=CGRectMake(ax-imgWidth-10, self.frame.size.height/2-imgHeight/2, imgWidth, imgHeight);
    }
    
    
        imageViewSelected.image=select_img;
        [self addSubview:imageViewSelected];
}
-(void)setSelectStatus:(BOOL)selectStatus
{
        if(!_editStatus)
        return;
        _selectStatus = selectStatus;
        UIImage *image;
        if(_selectStatus)
        {
        image = [UIImage imageNamed:NSLocalizedStringFromTable(@"check_box_frame_checked",Res_Image,@"")];
        }
        else
        {
        image = [UIImage imageNamed:NSLocalizedStringFromTable(@"check_box_frame",Res_Image,@"")];

        }
        imageViewSelected.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-image.size.width-10, self.frame.size.height/2-image.size.height/2, image.size.width, image.size.height);
        imageViewSelected.image=image;

}
+(double)calculateCellHeight
{
        return HEIGTH;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
[super setSelected:selected animated:animated];

// Configure the view for the selected state
}

@end
