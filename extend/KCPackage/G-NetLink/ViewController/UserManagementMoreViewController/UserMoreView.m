//
//  UserMoreView.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserMoreView.h"
#import "UIHyperlinksButton.h"

@implementation UserMoreView
{
    UIHyperlinksButton * _cancleBtn;
    UISwitch * _upDataSwitch;
}
- (id)initWithFrame:(CGRect)frame tableViewStyle:(UITableViewStyle)style{
    self = [super initWithFrame:frame tableViewStyle:style];
    if (self) {
        // Initialization code
        _customTitleBar.titleText=NSLocalizedStringFromTable(@"user_more_title", Res_String, @"");
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
        backgroundImageView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"vehicle_control_back",Res_Image,@"")];
        [self insertSubview:backgroundImageView atIndex:0];
        _customTitleBar.leftButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_btn_right_return",Res_Image,@"")];
        _customTitleBar.rightButtonImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"nav_back_to_home",Res_Image,@"")];
        UIImage *g_NetLinkImage = [UIImage imageNamed:NSLocalizedStringFromTable(@"bottom_bar_back",Res_Image,@"")];
        UIImageView *bottomitemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - g_NetLinkImage.size.height, self.bounds.size.width, g_NetLinkImage.size.height)];
        bottomitemImageView.image = g_NetLinkImage;
        bottomitemImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomitemImageView];
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        UIImage * cell_background_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"user_cell_background", Res_Image, @"")];
        self.tableView.frameImage=cell_background_img;
        UIImage *separated_img = [UIImage imageNamed:NSLocalizedStringFromTable(@"user_cell_separated",Res_Image,@"")];
        self.tableView.separatorLineImage=separated_img;
        self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y+15, self.tableView.frame.size.width, self.tableView.frame.size.height);
        self.tableView.scrollEnabled=NO;;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [self.tableView sendSubviewToBack:self];
    }
    return self;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
            cell.textLabel.text = NSLocalizedStringFromTable(@"user_more_table_cell_text0",Res_String,@"");
            break;
        case 1:
            cell.textLabel.text = NSLocalizedStringFromTable(@"user_more_table_cell_text1",Res_String,@"");
            break;
//        case 2:
////            cell.textLabel.text = NSLocalizedStringFromTable(@"user_more_table_cell_text2",Res_String,@"");
////            break;
//            cell.textLabel.text = NSLocalizedStringFromTable(@"user_more_table_cell_text3",Res_String,@"");
//            _upDataSwitch=[[UISwitch alloc]init];
//            _upDataSwitch.on = _autoUpdateFlag;
//            //            [_upDataSwitch setOnImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"user_switch_on",Res_Image,@"")] ];
//            //            [_upDataSwitch setOffImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"user_switch_off",Res_Image,@"")] ];
//            [_upDataSwitch addTarget:self action:@selector(switchAction:)forControlEvents:UIControlEventValueChanged];
//            cell.accessoryView = _upDataSwitch;
//            break;
        case 2:
//            cell.textLabel.text = NSLocalizedStringFromTable(@"user_more_table_cell_text3",Res_String,@"");
//            _upDataSwitch=[[UISwitch alloc]init];
////            [_upDataSwitch setOnImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"user_switch_on",Res_Image,@"")] ];
////            [_upDataSwitch setOffImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"user_switch_off",Res_Image,@"")] ];
//            [_upDataSwitch addTarget:self action:@selector(switchAction:)forControlEvents:UIControlEventValueChanged];
//            cell.accessoryView = _upDataSwitch;
            
            cell.textLabel.text = NSLocalizedStringFromTable(@"user_more_table_cell_text4",Res_String,@"");
            break;
        case 3:
//            cell.textLabel.text = NSLocalizedStringFromTable(@"user_more_table_cell_text4",Res_String,@"");
            cell.textLabel.text = NSLocalizedStringFromTable(@"user_more_table_cell_text5",Res_String,@"");
            break;
//        case 5:
//            cell.textLabel.text = NSLocalizedStringFromTable(@"user_more_table_cell_text5",Res_String,@"");
//            
//            break;
        default:
            break;
    }
    return cell;
}
//自动更新的开关
//-(void)switchAction:(id)sender {
//    UISwitch *switchButton = (UISwitch*)sender;
//    BOOL isButtonOn = [switchButton isOn];
//    if (isButtonOn) {
//        showSwitchValue.text = @"是";
//    }else {
//        showSwitchValue.text = @"否";
//    }
//    UISwitch *switchButton = (UISwitch*)sender;
//    BOOL isButtonOn = [switchButton isOn];
//    [self.delegate clientVersionAutoUpdate:isButtonOn];
//}
-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (section>4) {
         [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
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
