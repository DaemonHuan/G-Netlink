//
//  NotificationView.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-5-5.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "NotificationView.h"
#import "NotificationCell.h"
#import "PullRefreshShowView.h"
#import "PullRefreshTableView.h"
#import "BeforeIos7StyleOfTableView.h"
@interface NotificationView()
{
    NSMutableArray * dataSource;
    NSMutableArray *selectDataArray;
    int currentPage;
//    UIButton * editBtn;
    UIButton* allBtn;
    UIButton* cancelBtn;
    UIButton * deleteBtn;
    BOOL _editStatus;
}

@end

@implementation NotificationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.editing=NO;
       _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
       _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_back_to_home",Res_Image,@"")];
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"notification_title", Res_String, @"");
        _backgroundImgView = [[UIImageView alloc] initWithFrame:frame];
        _backgroundImgView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"vehicle_control_back",Res_Image,@"")];
            [self insertSubview:_backgroundImgView atIndex:0];
        UIImageView * bottomBackgroundView=[[UIImageView alloc]init];
        UIImage *img_tabbar=[UIImage imageNamed:NSLocalizedStringFromTable(@"notification_bottom_img", Res_Image, @"")];
        
        UIImage *g_NetLinkImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
        UIImageView *bottomitemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - g_NetLinkImage.size.height, self.bounds.size.width, g_NetLinkImage.size.height)];
        bottomitemImageView.image = g_NetLinkImage;
        bottomitemImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomitemImageView];
        
        bottomBackgroundView.frame=CGRectMake(0, self.frame.size.height-img_tabbar.size.height - g_NetLinkImage.size.height, self.frame.size.width, img_tabbar.size.height);
        bottomBackgroundView.image=img_tabbar;
        [self addSubview:bottomBackgroundView];
        _editBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 35, 15)];
        [_editBtn setTitle:NSLocalizedStringFromTable(@"edit", Res_String, @"") forState:UIControlStateNormal];
        _editBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        _editBtn.center=bottomBackgroundView.center;
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnOnclick:) forControlEvents:UIControlEventTouchUpInside];
        allBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, bottomBackgroundView.frame.size.height/2-15/2+bottomBackgroundView.frame.origin.y, 35, 15)];
        [allBtn setTitle:NSLocalizedStringFromTable(@"all", Res_String, @"") forState:UIControlStateNormal];
         allBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [allBtn addTarget:self action:@selector(allBtnOnclick:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(allBtn.frame.size.width+allBtn.frame.origin.x+40,  bottomBackgroundView.frame.size.height/2-15/2+bottomBackgroundView.frame.origin.y, 35, 15)];
        [cancelBtn setTitle:NSLocalizedStringFromTable(@"cancel", Res_String, @"") forState:UIControlStateNormal];
         cancelBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnOnclick:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(bottomBackgroundView.frame.size.width-35-15, bottomBackgroundView.frame.size.height/2-15/2+bottomBackgroundView.frame.origin.y,  35, 15)];
        [deleteBtn setTitle:NSLocalizedStringFromTable(@"delete", Res_String, @"") forState:UIControlStateNormal];
         deleteBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_editBtn];
        [self addSubview:allBtn];
        [self addSubview:deleteBtn];
        [self addSubview:cancelBtn];
        [self setEditStatus:_editStatus];
        CGRect  frame =  self.tableView.frame;
        
        frame.size.height = frame.size.height - bottomBackgroundView.frame.size.height- g_NetLinkImage.size.height + 10;
        self.tableView.frame = frame;
        _editBtn.hidden = YES;
        _backgroundImgView.hidden = YES;
    }
    return  self;
}
//按钮的隐藏状态
-(void)setEditStatus:(BOOL)status{
    if(_editing){
        deleteBtn.alpha=1;
        allBtn.alpha=1;
        cancelBtn.alpha=1;
        _editBtn.alpha=0;
    }
    else{
        deleteBtn.alpha=0;
        allBtn.alpha=0;
        cancelBtn.alpha=0;
        _editBtn.alpha=1;
    }
}
-(void)editBtnOnclick:(id)sender{
        _editing=YES;
        [self setEditStatus:_editing];
        [self.delegate tableViewEdit];
}
-(void)deleteBtnOnclick:(id)sender{
    [self.delegate tableViewDelete];
}
-(void)allBtnOnclick:(id)sender{
    [self.delegate tableViewSelect];
}
-(void)cancelBtnOnclick:(id)sender{
    _editing=NO;
        [self setEditStatus:_editing];
        [self.delegate tableViewCancel];
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
