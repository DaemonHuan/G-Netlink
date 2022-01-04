//
//  VehicleControlHistoryViewController.m
//  G-NetLink
//
//  Created by jayden on 14-4-24.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "VehicleControlHistoryViewController.h"
#import "VehicleOperateHistoryRecord.h"


#define CurrentPageSize 11
@interface VehicleControlHistoryViewController ()
{
    BOOL isNewQuery;
    int currentPage;
    NSMutableArray *dataSource;
}
@end

@implementation VehicleControlHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    VehicleControlHistoryView *vehicleControlHistoryView=[[VehicleControlHistoryView alloc] initWithFrame:[self createViewFrame]];
    CGRect pullFrame = vehicleControlHistoryView.pullRefreshShowView.frame;
    pullFrame.origin.y -= 25;
    vehicleControlHistoryView.pullRefreshShowView.frame = pullFrame;
    vehicleControlHistoryView.customTitleBar.buttonEventObserver=self;
    vehicleControlHistoryView.eventObserver=self;
     dataSource = [[NSMutableArray alloc] init];
    vehicleControlHistoryView.tableView.observer = self;
    vehicleControlHistoryView.tableView.dataSource=self;
    self.view=vehicleControlHistoryView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPage = 0;
    isNewQuery=YES;
    vehicle=[[Vehicle alloc]init];
    vehicle.vehicleOperateHistory.observer=self;
    [vehicle.vehicleOperateHistory getHistoryRecordsWithDate:@"" forPageindex:currentPage forPagesize:CurrentPageSize];
    [self lockView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)settingViewControllerId
{
    _viewControllerId=VIEWCONTROLLER_VEHICLECONTROLHISTORY;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CustomTitleBar_ButtonDelegate
-(IBAction)leftButton_onClick:(id)sender
{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_RETURN;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}

-(IBAction)rightButton_onClick:(id)sender
{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_HALL;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}

#pragma mark - CustomUIDatePickerDelegate
-(IBAction)confirmButton_onClick:(id)sender forDate:(NSDate*)date
{
    ((VehicleControlHistoryView *)self.view).currentData=date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //执行查询
    isNewQuery = YES;
    currentPage = 0;
    [vehicle.vehicleOperateHistory getHistoryRecordsWithDate:[dateFormatter stringFromDate:date] forPageindex:currentPage forPagesize:CurrentPageSize];
    [self lockView];
}

- (BOOL)didReceivePushNotification:(NSDictionary *)userInfo
{
    return YES;
}

- (BOOL)didReceiveForegroundPushNotification:(NSDictionary *)userInfo
{
    return YES;
}

-(IBAction)cancelButton_onClick:(id)sender
{
    
}

#pragma mark - PullRefreshTableViewDelegate
- (CGFloat)pullRefreshTableView:(PullRefreshTableView *)pullRefreshTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)pullRefreshTableView:(PullRefreshTableView *)pullRefreshTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [[Message alloc] init];
    message.sendObjectID = _viewControllerId;
    message.commandID = MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER;
    message.receiveObjectID = VIEWCONTROLLER_VEHICLECONTROLHISTORYDETAIL;
    message.externData=[dataSource objectAtIndex:indexPath.row];
    
    if(dataSource.count>0)
    {
        message.externData = [dataSource objectAtIndex:indexPath.row];
    }
    
    [self sendMessage:message];
}

-(void)pullRefreshTableViewRefresh:(PullRefreshTableView*)pullRefreshTableView
{
    VehicleControlHistoryView *view=(VehicleControlHistoryView*)self.view;
    [view.pullRefreshShowView refresh];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSDate *date = [NSDate date];
    NSString * cv = [dateFormatter stringFromDate:date];
    NSString * vv = [dateFormatter stringFromDate:view.currentData];
    if ([cv isEqualToString:vv]) {
        [vehicle.vehicleOperateHistory getHistoryRecordsWithDate:@"" forPageindex:currentPage forPagesize:CurrentPageSize];
    }
    else {
        [vehicle.vehicleOperateHistory getHistoryRecordsWithDate: [dateFormatter stringFromDate:view.currentData] forPageindex:currentPage forPagesize:CurrentPageSize];
    }
}

#pragma mark - TableView dataSource
-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString  *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.backgroundView=nil;
        
        UIImage *image=[UIImage imageNamed:NSLocalizedStringFromTable(@"history_cell_separator",Res_Image,@"")];
        UIImageView *separatorView=[[UIImageView alloc] initWithImage:image];
        separatorView.tag=101;
        separatorView.userInteractionEnabled = YES;
        CGRect  separatorViewFrame=separatorView.frame;
        separatorViewFrame.origin.y=cell.frame.size.height-image.size.height-3;
        separatorView.frame=separatorViewFrame;
        [cell addSubview:separatorView];
        
         UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"cell_nav_logo",Res_Image,@"")]];
        cell.accessoryView=imageView;
    }
    
    if(dataSource.count>0)
    {
        VehicleOperateHistoryRecord *record = [dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text=record.sendTime;
    }
    return cell;
}

#pragma mark - DataModuleDelegate
-(void)didDataModuleNoticeSucess:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID
{
    [super didDataModuleNoticeSucess:baseDataModule forBusinessType:businessID];
    if (businessID==BUSINESS_VEHICLE_GETOPERATEHISTORY) {
        if (isNewQuery) {
            [dataSource removeAllObjects];
            isNewQuery=NO;
        }
        [dataSource addObjectsFromArray:vehicle.vehicleOperateHistory.historyRecords];
//        if(vehicle.vehicleOperateHistory.pagecount > currentPage-1)
//        {
//            [dataSource addObjectsFromArray:vehicle.vehicleOperateHistory.historyRecords];
//        }
        VehicleControlHistoryView *view = (VehicleControlHistoryView*)self.view;
        [view.tableView stopRefresh];
        [view.pullRefreshShowView ready];
        currentPage ++;
    }
}

-(void)didDataModuleNoticeFail:(BaseDataModule *)baseDataModule forBusinessType:(enum BusinessType)businessID forErrorCode:(int)errorCode forErrorMsg:(NSString *)errorMsg
{
    if(businessID == BUSINESS_VEHICLE_GETOPERATEHISTORY)
    {
        VehicleControlHistoryView *view = (VehicleControlHistoryView*)self.view;
        [view.tableView stopRefresh];
        [view.pullRefreshShowView ready];
    }
    
    [super didDataModuleNoticeFail:baseDataModule forBusinessType:businessID forErrorCode:errorCode forErrorMsg:errorMsg];
}
@end
