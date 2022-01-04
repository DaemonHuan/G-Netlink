//
//  UserManagementView.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-28.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserManagementView.h"
#import "UIHyperlinksButton.h"
#import "BeforeIos7StyleOfTableView.h"
@implementation UserManagementView
{
    BeforeIos7StyleOfTableView  * _userManagementTableView;
    UIHyperlinksButton * _cancleBtn;
    int isAlert;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isAlert=1;
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"userManagement_title", Res_String, @"");
        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"",Res_Image,@"")];
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"",Res_Image,@"")];

        _userManagementTableView = [[BeforeIos7StyleOfTableView alloc]init];
        UIImage * cell_background_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_cell_background", Res_Image, @"")];
      _userManagementTableView.frameImage=cell_background_img;
        UIImage *separated_img = [UIImage imageNamed:NSLocalizedStringFromTable(@"user_cell_separated",Res_Image,@"")];
        _userManagementTableView.separatorLineImage=separated_img;
        _userManagementTableView.frame = CGRectMake(20, _customTitleBar.frame.origin.y+20+_customTitleBar.frame.size.height, self.frame.size.width-40, 44*4);
        _userManagementTableView.scrollEnabled=NO;
        _userManagementTableView.dataSource=self;
        _userManagementTableView.delegate=self;
        _userManagementTableView.backgroundColor=[UIColor clearColor];
        [self addSubview:_userManagementTableView];
        _cancleBtn=[UIHyperlinksButton  hyperlinksButton ];
        [_cancleBtn setTitle:NSLocalizedStringFromTable(@"userManagement_button_text", Res_String, @"") forState:UIControlStateNormal];
        UIImage * btn_backgroud_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_cancle_btn_backgroud_img", Res_Image, @"")];
        _cancleBtn.frame=CGRectMake(20, _userManagementTableView.frame.origin.y+_userManagementTableView.frame.size.height+30, _userManagementTableView.frame.size.width, btn_backgroud_img.size.height);
        [_cancleBtn setBackgroundImage:btn_backgroud_img forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_cancleBtn addTarget:self action:@selector(cancleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancleBtn];
    }
    return self;
}

//注销登录的方法
-(void)cancleButton:(id)sender{
   [self.delegate userlogout];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
return 44;
}

#pragma mark - tableView的section和cell的设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString  *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.backgroundView=nil;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"cell_nav_logo",Res_Image,@"")]];
        cell.accessoryView = imageView;

  }
    switch (indexPath.row) {
        case 0:
             cell.textLabel.text = NSLocalizedStringFromTable(@"userManagement_table_cell_text0",Res_String,@"");
            break;
            case 1:
                cell.textLabel.text = NSLocalizedStringFromTable(@"userManagement_table_cell_text1",Res_String,@"");
            break;
        case 2:
            cell.textLabel.text = NSLocalizedStringFromTable(@"userManagement_table_cell_text2",Res_String,@"");
            break;
//        case 3:
//            cell.textLabel.text = NSLocalizedStringFromTable(@"userManagement_table_cell_text3",Res_String,@"");
//            break;
        case 3:
            cell.textLabel.text = NSLocalizedStringFromTable(@"userManagement_table_cell_text4",Res_String,@"");
            break;
        default:
            break;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate sendMessageDelegate:indexPath];
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
