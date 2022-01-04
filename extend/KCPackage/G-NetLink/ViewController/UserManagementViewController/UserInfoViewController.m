//
//  UserInfoViewController.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-28.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoView.h"
#import "BeforeIos7StyleOfTableView.h"
#import "User.h"
#import "GNLUserInfo.h"
#import "VehicleInfo.h"
#import "CustomMarqueeView.h"

@interface UserInfoViewController ()
{
    UserInfoView *_userInfoView;
    VehicleInfo *vehicleInfo;
}
@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    user.observer=self;
    user.userInfo.observer=self;
    [user.userInfo getInfo];
    [self lockView];
    
    vehicleInfo = [self.parentNode getNodeOfSaveDataAtKey:@"vehicleInfo"];
    if (vehicleInfo == nil) {
        vehicleInfo = [[VehicleInfo alloc] init];
        vehicleInfo.observer = self;
        [vehicleInfo getInfo];
        [self.parentNode addNodeOfSaveData:@"vehicleInfo" forValue:vehicleInfo];
    }
    else if (vehicleInfo.vehNo == nil || (NSNull *)vehicleInfo.vehNo == [NSNull null]|| vehicleInfo.vehNo.length == 0)
    {
        vehicleInfo.observer = self;
        [vehicleInfo getInfo];
        [self.parentNode addNodeOfSaveData:@"vehicleInfo" forValue:vehicleInfo];
    }
}

-(void)loadView
{
    _userInfoView=[[UserInfoView alloc] initWithFrame:[self createViewFrame] tableViewStyle:UITableViewStyleGrouped];
    _userInfoView.customTitleBar.buttonEventObserver = self;
    self.view=_userInfoView;
    CGRect   table_frame;
    table_frame = CGRectMake(20, _userInfoView.customTitleBar.frame.origin.y+_userInfoView.customTitleBar.frame.size.height, self.view.frame.size.width-40, self.view.frame.size.height-_userInfoView.customTitleBar.frame.size.height-30);
    [_userInfoView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _userInfoView.tableView.separatorColor = [UIColor clearColor];
    _userInfoView.tableView.delegate=self;
    _userInfoView.tableView.dataSource=self;
    UIImage * cell_background_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_cell_background", Res_Image, @"")];
    _userInfoView.tableView.frameImage=cell_background_img;
    UIImage *separated_img = [UIImage imageNamed:NSLocalizedStringFromTable(@"user_cell_separated",Res_Image,@"")];
    _userInfoView.tableView.separatorLineImage=separated_img;
    _userInfoView.tableView.backgroundColor=[UIColor clearColor];
    _userInfoView.tableView.sectionFooterHeight = 0;
    _userInfoView.tableView.sectionHeaderHeight=42;
}

-(void)didDataModuleNoticeSucess:(BaseDataModule*)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    [super didDataModuleNoticeSucess:baseDataModule forBusinessType:businessID];
    
    if (businessID ==   BUSINESS_GETUSERINFO ) {
        [_userInfoView.tableView reloadData];
        
    }
}
-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_USERINFO;
}

-(void)leftButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_USERMANAGEMENT;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)rightButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_HALL;
    msg.commandID=MC_CREATE_GRADUALLYINTO_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)userInfoViewDelageat_cell{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_UPDATEPHONE;
    msg.commandID=MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
    [self sendMessage:msg];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

#pragma mark - tableView的section和cell的设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString  *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    cell.backgroundView=nil;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor whiteColor];

    if (indexPath.section==0) {
        if(indexPath.row==0){
            [self createUserInfoCell:cell forTableView:tableView forText:NSLocalizedStringFromTable(@"userManagement_user_info_table_section0_row0", Res_String, @"") forUserText:user.userInfo.realname];
        }else if (indexPath.row==1){
            [self createUserInfoCell:cell forTableView:tableView forText:NSLocalizedStringFromTable(@"userManagement_user_info_table_section0_row1", Res_String, @"") forUserText:user.userInfo.certificate_num];
        }
        else if (indexPath.row==2){
            [self createUserInfoCell:cell forTableView:tableView forText:NSLocalizedStringFromTable(@"userManagement_user_info_table_section0_row2", Res_String, @"") forUserText:vehicleInfo.frameNo];
        }
        else if (indexPath.row==3){
            [self createUserInfoCell:cell forTableView:tableView forText:NSLocalizedStringFromTable(@"userManagement_user_info_table_section0_row3", Res_String, @"") forUserText:user.mobileNumber];
        }else if(indexPath.row==4){
            [self createUserInfoCell:cell forTableView:tableView forText:NSLocalizedStringFromTable(@"userManagement_user_info_table_section0_row4", Res_String, @"") forUserText:user.userInfo.mobilephone];
        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) { 
            [self createUserInfoCell:cell forTableView:tableView forText:NSLocalizedStringFromTable(@"userManagement_user_info_table_section1_row0", Res_String, @"") forUserText:vehicleInfo.vehNo];
        }else if(indexPath.row==1){
            [self createUserInfoCell:cell forTableView:tableView forText:NSLocalizedStringFromTable(@"userManagement_user_info_table_section1_row1", Res_String, @"") forUserText:vehicleInfo.vehicleType];
      }else if (indexPath.row==2){
            [self createUserInfoCell:cell forTableView:tableView forText:NSLocalizedStringFromTable(@"userManagement_user_info_table_section1_row2", Res_String, @"") forUserText:vehicleInfo.bodyColor];
        }    
    }
    if(indexPath.section==2){
        if(indexPath.row==0){
            [self createUserInfoCell:cell forTableView:tableView forText:NSLocalizedStringFromTable(@"userManagement_user_info_table_section2_row0", Res_String, @"") forUserText:vehicleInfo.salesName];
        }else if (indexPath.row==1){
            [self createUserInfoCell:cell forTableView:tableView forText:NSLocalizedStringFromTable(@"userManagement_user_info_table_section2_row1", Res_String, @"") forUserText:vehicleInfo.salesPhone];
        }else if (indexPath.row==2) {
            [self createUserInfoCell:cell forTableView:tableView forText:NSLocalizedStringFromTable(@"userManagement_user_info_table_section2_row2", Res_String, @"") forUserText:vehicleInfo.salesAddress];
        }
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 5;
    }else if (section==1) {
        return 3;
    }else {
        return 3;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(_userInfoView.tableView.frame.origin.x, 0, _userInfoView.tableView.frame.size.width, 42)];
    headView.backgroundColor=[UIColor clearColor];
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(5, 20, 100, 12)];
    switch (section) {
        case 0:
            label.text=NSLocalizedStringFromTable(@"userManagement_user_info_title",Res_String,@"");
            break;
        case 1:
            label.text=NSLocalizedStringFromTable(@"userManagement_user_info_title1",Res_String,@"");
            break;
        case 2:
            label.text=NSLocalizedStringFromTable(@"userManagement_user_info_title2",Res_String,@"");
            break;
        default:
            break;
    }
    label.textColor=[UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font=[UIFont systemFontOfSize:12];
    [headView addSubview:label];
    return headView;
}
/*
-(void)createLongUserInfoCell:(UITableViewCell*)cell forTableView:(UITableView*)tableView forText:(NSString*)title forUserText:(NSString*)userText
 {
     UILabel * cell_left_label=[[UILabel alloc]initWithFrame:CGRectMake(10, (cell.frame.size.height-15)/2,  15*5+20, 15)];
     cell_left_label.text=title;
     cell_left_label.textColor=[UIColor whiteColor];
     cell_left_label.font=[UIFont systemFontOfSize:15];
     cell_left_label.textAlignment=NSTextAlignmentLeft;
     cell_left_label.backgroundColor = [UIColor clearColor];
     [cell addSubview:cell_left_label];
     
     UILabel * cell_right_label=[[UILabel alloc]initWithFrame:CGRectMake(120,  (cell.frame.size.height-15)/2, _userInfoView.tableView.frame.size.width-120-15, 15)];
     
     if (userText ==nil ||userText== NULL  ||[userText isKindOfClass:[NSNull class]]) {
     cell_right_label.text = @"";
     }else{
     cell_right_label.text = userText;
     }
     cell_right_label.font=[UIFont systemFontOfSize:15];
     cell_right_label.textAlignment=NSTextAlignmentRight;
     cell_right_label.textColor= [UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:193.0f/255.0f alpha:1.0f];
     cell_right_label.backgroundColor = [UIColor clearColor];
     
     CGRect frame = cell_right_label.frame;
     frame.size.width = [cell_right_label.text sizeWithFont: cell_right_label.font].width;
     cell_right_label.frame = frame;
     
     CustomMarqueeView *rightView = [[CustomMarqueeView alloc] initWithFrame:cell_right_label.frame];
     rightView.backgroundColor = [UIColor clearColor];
     rightView.contentViews = @[cell_right_label];
     
     [cell addSubview:rightView];
}*/

-(void)createUserInfoCell:(UITableViewCell*)cell forTableView:(UITableView*)tableView forText:(NSString*)title forUserText:(NSString*)userText
{
    UILabel * cell_left_label=[[UILabel alloc]initWithFrame:CGRectMake(10, (cell.frame.size.height-15)/2,  15*5+20, 15)];
    cell_left_label.text=title;
    cell_left_label.textColor=[UIColor whiteColor];
    cell_left_label.font=[UIFont systemFontOfSize:15];
    cell_left_label.textAlignment=NSTextAlignmentLeft;
    UILabel * cell_right_label=[[UILabel alloc]initWithFrame:CGRectMake(70,  (cell.frame.size.height-15)/2, _userInfoView.tableView.frame.size.width-70-15, 15)];
    
    if (userText ==nil ||userText== NULL  ||[userText isKindOfClass:[NSNull class]]) {
        cell_right_label.text = @"";
    }else{
        cell_right_label.text = userText;
    }
    cell_right_label.font=[UIFont systemFontOfSize:13];
    cell_right_label.textAlignment=NSTextAlignmentRight;
    cell_right_label.textColor= [UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:193.0f/255.0f alpha:1.0f];
    cell_left_label.backgroundColor = [UIColor clearColor];
    cell_right_label.backgroundColor = [UIColor clearColor];
    [cell addSubview:cell_right_label];
    [cell addSubview:cell_left_label];
}
-(void)createModificationPhoneCell:(UITableViewCell*)cell forTableView:(UITableView*)tableView forText:(NSString*)title forUserText:(NSString*)userText
{
 UILabel * cell_left_label=[[UILabel alloc]initWithFrame:CGRectMake(10, (cell.frame.size.height-15)/2, 15*5+20, 15)];
    cell_left_label.text=title;
    cell_left_label.textColor=[UIColor whiteColor];
    cell_left_label.font=[UIFont systemFontOfSize:15];
    cell_left_label.textAlignment=NSTextAlignmentLeft;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"cell_nav_logo",Res_Image,@"")]];
    cell.accessoryView = imageView;
    UILabel * cell_right_label=[[UILabel alloc]initWithFrame:CGRectMake(120, (cell.frame.size.height-15)/2, _userInfoView.tableView.frame.size.width-120-30-imageView.image.size.width, 15)];
    if (userText ==nil ||userText== NULL  ||[userText isKindOfClass:[NSNull class]]) {
        cell_right_label.text=user.mobileNumber;
    }else{
        cell_right_label.text=userText;
    }
    cell_right_label.textColor= [UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:193.0f/255.0f alpha:1.0f];
    cell_right_label.font=[UIFont systemFontOfSize:15];
    cell_right_label.textAlignment=NSTextAlignmentRight;
    [cell addSubview:cell_right_label];
    [cell addSubview:cell_left_label];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row==4){
//            Message *msg=[[Message alloc] init];
//            msg.receiveObjectID=VIEWCONTROLLER_UPDATEPHONE;
//            msg.commandID=MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
//            [self sendMessage:msg];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")].size.height + 10;
    }
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
