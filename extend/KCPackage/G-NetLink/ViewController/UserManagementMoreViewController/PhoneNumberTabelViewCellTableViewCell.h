//
//  PhoneNumberTabelViewCellTableViewCell.h
//  G-NetLink
//
//  Created by liuxiaobo on 15/1/21.
//  Copyright (c) 2015年 95190. All rights reserved.
//
@protocol PhoneNumberTabelViewCellTableViewCellDelegate <NSObject>

-(void)buttonOnClickDelegate:(NSString*)mobile_phone andOperate:(BOOL)operate;

@end
#import <UIKit/UIKit.h>

@interface PhoneNumberTabelViewCellTableViewCell : UITableViewCell
@property (nonatomic)NSString * phoneNumber;
@property(nonatomic,assign)id<PhoneNumberTabelViewCellTableViewCellDelegate>delegate;
-(void)loadCellView:(BOOL)isExist    andPhoneTitle:(NSString*)title  PhoneNumber:(NSString *)phoneNumber;
@end
