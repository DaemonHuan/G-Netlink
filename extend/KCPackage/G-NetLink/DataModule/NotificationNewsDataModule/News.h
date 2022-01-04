//
//  News.h
//  G-NetLink
//
//  Created by jayden on 14-4-22.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"
enum ReadStauts
{
    ReadStauts_NoRead = 0,
    ReadStauts_Read,
};

enum MessageType
{
    MessageType_Normal = 0,
    MessageType_Control
};

@interface News : BaseDataModule
@property(nonatomic,readonly)NSString *newsId;
@property(nonatomic,readonly,assign) int sendNo;
@property(nonatomic,readonly)NSString *mobileNumber;
@property(nonatomic,readonly)NSString *title;
@property(nonatomic,readonly)NSString *content;
@property(nonatomic,readonly)NSString *detailContent;
@property(nonatomic,readonly)NSString *source;
@property(nonatomic,readonly)NSString *platform;
@property(nonatomic,readonly)NSString *clientId;
@property(nonatomic,readonly)NSString *receiver;
@property(nonatomic,readonly)NSString *addTime;
@property(nonatomic,readonly,assign)enum ReadStauts isRead;
@property(nonatomic,readonly,assign)enum MessageType messageType;
-(id)initWithDic:(NSDictionary*)dic;
-(void)getDetailInfo:(NSString*)newsId;
-(void)updateReadStatus;
@end
