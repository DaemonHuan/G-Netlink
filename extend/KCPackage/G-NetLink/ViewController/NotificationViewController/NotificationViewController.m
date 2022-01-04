//
//  NotificationViewController.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-5-5.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationView.h"
#import "NotificationNews.h"
#import "BaseCustomMessageBox.h"
#import "News.h"
#import "NotificationCell.h"
@interface NotificationViewController ()
{
    NSMutableArray * dataSource;
    NotificationView *notificationView;
    NSMutableArray *selectDataArray;
    int currentPage;
    BOOL  edit;
    BOOL cellCheck;
    BOOL selected;
    NotificationNews *  _notificationNews;
    
}
@end
@implementation NotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)leftButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_HALL;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)rightButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_HALL;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _notificationNews=[[NotificationNews alloc]init];
    _notificationNews.observer=self;
    [self getDataSource];
}
-(void)loadView
{
    currentPage=10;
    selectDataArray =[[NSMutableArray alloc]init];
    dataSource = [[NSMutableArray alloc] init];
    dataSource=[[NSMutableArray alloc]init];
    notificationView=[[NotificationView alloc] initWithFrame:[self createViewFrame]];
    notificationView.customTitleBar.buttonEventObserver = self;
    notificationView.delegate=self;
    //    notificationView.tableView.backgroundColor = [UIColor ]
    notificationView.tableView.observer = self;
    notificationView.tableView.dataSource=self;
    self.view = notificationView;
    edit=notificationView.editing;
}
//获取新闻的方法
-(void)getDataSource{
    //    currentPage 一开始默认为10
    [_notificationNews getNews:1 forpagesize:currentPage];
    currentPage=currentPage+5;
}
-(void)didDataModuleNoticeSucess:(BaseDataModule*)baseDataModule forBusinessType:(enum BusinessType)businessID{
    if(businessID== BUSINESS_NOTIFICATIONNEWS_DELETE){
        currentPage=10;
        [self getDataSource];
        [notificationView.tableView reloadData];
        selectDataArray=[[NSMutableArray alloc]init];
        BaseCustomMessageBox *baseCustomMessageBox = [[BaseCustomMessageBox alloc] initWithText:@"删除成功" forBackgroundImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"base_messagebox_background",Res_Image,@"")]];
        baseCustomMessageBox.animation = YES;
        baseCustomMessageBox.autoCloseTimer = 1;
        [self.view addSubview:baseCustomMessageBox];
        
    }
    else if(businessID== BUSINESS_NOTIFICATIONNEWS_QUERY)
    {
        if (0 == _notificationNews.recordcount) {
            notificationView.backgroundImgView.hidden = YES;
            notificationView.editBtn.hidden = YES;

            notificationView.editing = NO;
            [notificationView setEditStatus: NO];
            edit = NO;
        } else {
            notificationView.backgroundImgView.hidden = NO;
            notificationView.editBtn.hidden = NO;
        }
    }
    dataSource=[[NSMutableArray alloc]initWithArray:_notificationNews.news];
    [notificationView.tableView reloadData];
}
- (CGFloat)pullRefreshTableView:(PullRefreshTableView *)pullRefreshTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_NOTIFICATIONNEWS;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}
//上拉刷新的方法
-(void)pullRefreshTableViewRefresh:(PullRefreshTableView*)pullRefreshTableView{
    [self getDataSource];
    [pullRefreshTableView stopRefresh];
}
#pragma 暂时没问题
-(void)tableViewEdit {
    edit=YES;
    [notificationView.tableView reloadData];
}
-(void)tableViewCancel{
    edit=NO;
    selected=NO;
    [self getDataSource];
    [notificationView.tableView reloadData];
}
-(void)tableViewDelete{
    NSArray * array=[self removeOfDuplicateArray:selectDataArray];
    [_notificationNews deleteNews:array];
}

-(void)tableViewSelect{
    selected=!selected;
    
    [notificationView.tableView reloadData];
    
}
-(NSArray*)removeOfDuplicateArray:(NSMutableArray*)array{
    NSSet *set = [NSSet setWithArray:array];
    NSArray * arrays=[[NSArray alloc]initWithArray:[set allObjects]];
    return arrays;
}


#pragma 有问题的代码
- (void)pullRefreshTableView:(PullRefreshTableView *)pullRefreshTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (edit) {
        NotificationCell * cell=(NotificationCell*)[pullRefreshTableView cellForRowAtIndexPath:indexPath];
        cell.selectStatus=!cell.selectStatus;
        [cell setSelectStatus:cell.selectStatus];
        [self isAddArrayNewId:[dataSource objectAtIndex:indexPath.row]];
        
        
    }else{
        News *news=[dataSource objectAtIndex:indexPath.row];
        [self goDetailedView:news];
    }
    
}
-(void)goDetailedView:(News*)news{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_NOTIFICATIONNEWS_DETAIL;
    msg.commandID=MC_CREATE_PUSHFROMRIGHT_VIEWCONTROLLER;
    msg.externData=news;
    [self sendMessage:msg];
}
-(void)isAddArrayNewId:(News*)news{
    BOOL isDelegate=NO;
    if (selectDataArray.count==0) {
        isDelegate=NO;
    }
    for (int num=0; num<selectDataArray.count; num++) {
        NSString * arrrayId=[selectDataArray objectAtIndex:num];
        if ([news.newsId isEqualToString:arrrayId]) {
            isDelegate=YES;
        }
    }
    if(isDelegate){
        [selectDataArray removeObject:news];
    }else{
        [selectDataArray addObject:news];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString  *CellIdentifier = @"CellIdentifier";
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        UILabel*   titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-35, 9)];
        UILabel*  textLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 20+titleLabel.frame.size.height, self.view.frame.size.width-46, 12)];
        titleLabel.tag=1001;
        textLabel.tag=1002;
        titleLabel.font=[UIFont systemFontOfSize:11];
        textLabel.font=[UIFont systemFontOfSize:13];
        titleLabel.textColor=[UIColor colorWithRed:204/250 green:204/250 blue:204/250 alpha:1];
        titleLabel.textColor = [UIColor lightGrayColor];
        textLabel.textColor=[UIColor whiteColor];
        textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        UIImage * cell_background_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_cell_background", Res_Image, @"")];        UIImage *separated_img = [UIImage imageNamed:NSLocalizedStringFromTable(@"user_cell_separated",Res_Image,@"")];
        UIImageView *separated_imgView= [[UIImageView alloc] initWithImage:[separated_img stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        separated_imgView.frame = CGRectMake(0,50-separated_img.size.height, self.view.frame.size.width , separated_img.size.height);
        titleLabel.backgroundColor = [UIColor clearColor];
        textLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:titleLabel];
        [cell addSubview:textLabel];
        [cell addSubview:separated_imgView];
        UIImageView * cell_background_img_view = [[UIImageView alloc]initWithImage:cell_background_img];
        cell.backgroundView=cell_background_img_view;
    }
    
    UILabel * titleLabel=(UILabel*)[cell viewWithTag:1001];
    UILabel * textLabel=(UILabel*)[cell viewWithTag:1002];
    News* newData=[dataSource objectAtIndex:indexPath.row];
    textLabel.text=newData.content;
    titleLabel.text=[NSString  stringWithFormat:@"%@ %@",newData.source,newData.addTime];
    CGRect rect = CGRectMake(textLabel.frame.origin.x+textLabel.frame.size.width+2, 0, 9, 50);  //截取图片大小
    //开始取图，参数：截图图片大小
    UIGraphicsBeginImageContext(rect.size);
    //截图层放入上下文中
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    //从上下文中获得图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束截图
    UIGraphicsEndImageContext();
    UIImageView * alphaImg=[[UIImageView alloc]initWithFrame:CGRectMake(textLabel.frame.origin.x+textLabel.frame.size.width-5, 0, 8, 50)];
    alphaImg.image=image;
    alphaImg.alpha=0.8;
    [cell addSubview:alphaImg];
    
    if (newData.isRead == ReadStauts_Read)
    {
        [cell setEditStatus:edit isRead:NO];
    }
    else
    {
        [cell setEditStatus:edit isRead:YES];
    }
    [cell setSelectStatus:selected];
    if(selected){
        [selectDataArray addObject:newData];
    }else{
        selectDataArray=[[NSMutableArray alloc]init];
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
