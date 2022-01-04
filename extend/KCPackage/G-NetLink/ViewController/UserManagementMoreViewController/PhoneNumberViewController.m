//
//  PhoneNumberViewController.m
//  G-NetLink
//
//  Created by liuxiaobo on 15/1/21.
//  Copyright (c) 2015年 95190. All rights reserved.
//

#import "PhoneNumberViewController.h"
#import "PhoneNumberTabelViewCellTableViewCell.h"
#import "PhoneNumberView.h"
#import "User.h"
#import "UserPhone.h"
#import "StringUtils.h"
#import "BaseCustomMessageBox.h"
@interface PhoneNumberViewController ()
{
    NSArray * _phoneNumberArray;
    PhoneNumberView * phoneNmuberView;
     BeforeIos7StyleOfTableView  * _tableView;
}
@end

@implementation PhoneNumberViewController
-(void)loadView
{
    phoneNmuberView = [[PhoneNumberView alloc]initWithFrame:[self createViewFrame]];
    phoneNmuberView.tableView.dataSource = self;
    phoneNmuberView.tableView.delegate = self;
    phoneNmuberView.customTitleBar.buttonEventObserver = self;
    self.view = phoneNmuberView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    user.observer = self;
    [user getMobilePhone];
    [self lockView];
    _phoneNumberArray = [[NSArray alloc]init];
    
    _tableView = [[BeforeIos7StyleOfTableView alloc]init];
    UIImage * cell_background_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_cell_background", Res_Image, @"")];
            _tableView.frameImage=cell_background_img;
    UIImage *separated_img = [UIImage imageNamed:NSLocalizedStringFromTable(@"user_cell_separated",Res_Image,@"")];
    _tableView.separatorLineImage=separated_img;
    
    _tableView.frame = CGRectMake(20, phoneNmuberView.customTitleBar.frame.origin.y+20+phoneNmuberView.customTitleBar.frame.size.height, phoneNmuberView.frame.size.width-40, 44*5);
    _tableView.scrollEnabled=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    

    
    
    
    // Do any additional setup after loading the view.
}
-(void)didDataModuleNoticeSucess:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    [super didDataModuleNoticeSucess:baseDataModule forBusinessType:businessID];
    
    BaseCustomMessageBox *baseCustomMessageBox;
   
    
    if (businessID == BUSINESS_PHONENUMBERGET)
    {
        _phoneNumberArray = user.phoneNumberArray;
       
    }
    else if ( businessID == BUSINESS_PHONENUMBERREMOVE)
    {
        _phoneNumberArray = user.phoneNumberArray;
      
      baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:NSLocalizedStringFromTable(@"解除成功",Res_String,@"") forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
        
        [user getMobilePhone];
        [self lockView];
        
    }
    else if ( businessID == BUSINESS_PHONENUMBERBINDING)
    {
        _phoneNumberArray = user.phoneNumberArray;
       
        baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:NSLocalizedStringFromTable(@"绑定成功",Res_String,@"") forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
        [user getMobilePhone];
        [self lockView];
    }
    baseCustomMessageBox.animation = YES;
    baseCustomMessageBox.autoCloseTimer = 1;
    [self.view addSubview:baseCustomMessageBox];
    
      [_tableView reloadData];


}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
#pragma mark - tableView的section和cell的设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString  *CellIdentifier = @"CellIdentifier";
    PhoneNumberTabelViewCellTableViewCell *cell = [[PhoneNumberTabelViewCellTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.backgroundView=nil;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if (_phoneNumberArray && _phoneNumberArray.count >indexPath.row)
    {
        UserPhone * userPhone;
        userPhone = [_phoneNumberArray objectAtIndex:indexPath.row];
        [cell loadCellView:YES andPhoneTitle:[NSString stringWithFormat:@"已绑定号码%d:",indexPath.row+1] PhoneNumber:userPhone.mobile_phone];
    }else
    {
        [cell loadCellView:NO andPhoneTitle:nil  PhoneNumber:nil];
    }

    return cell;
}

-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_PHONENUMBER;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)rightButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_HALL;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)leftButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_RETURN;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}

-(void)buttonOnClickDelegate:(NSString*)mobile_phone andOperate:(BOOL)operate
{
    
    if (![mobile_phone isValidateMobile]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"您输入的手机号格式有误，请重新输入！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
   
    
    if (operate)
    {
        [user removeMobilePhone:mobile_phone];
        [self lockView];
    }
    else
    {
        [user bindingMobilePhone:mobile_phone];
        [self lockView];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
