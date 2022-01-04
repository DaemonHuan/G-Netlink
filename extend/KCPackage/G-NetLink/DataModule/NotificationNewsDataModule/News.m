//
//  News.m
//  G-NetLink
//
//  Created by jayden on 14-4-22.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "News.h"

@interface News()
{
    
}
-(void)fillData:(NSDictionary*)dic;
@end

@implementation News

-(id)init
{
    if(self = [super init]){
        _newsId = @"";
        _mobileNumber=@"";
        _sendNo=0;
        _title = @"";
        _content = @"";
        _detailContent=@"";
        _source = @"";
        _isRead = ReadStauts_NoRead;
        _platform=@"";
        _clientId=@"";
        _receiver=@"";
        _addTime = @"";
        _messageType = MessageType_Normal;
    }
    
    return self;
}
-(id)initWithDic:(NSDictionary*)dic
{
    if (self =[super init]) {
        if((NSNull *)dic==[NSNull null])
            return self;
        [self fillData:dic];
    }
    
    return self;
}
-(void)fillData:(NSDictionary*)dic
{
    _newsId = [dic objectForKey:@"msgid"];
    _mobileNumber =[dic objectForKey:@"mobilenumber"];
    _sendNo=[[dic objectForKey:@"sendno"] intValue];
    _title = [dic objectForKey:@"title"];
    _content = [dic objectForKey:@"content"];
    if ((NSNull *)[dic objectForKey:@"detail_content"] == [NSNull null]) {
        _detailContent = @"";
    } else {
        _detailContent=[dic objectForKey:@"detail_content"];
    }
    _source =[dic objectForKey:@"source"];
    _isRead = [[dic objectForKey:@"isread"] intValue];
    _messageType = [[dic objectForKey:@"messagetype"] intValue];
    _platform=[dic objectForKey:@"platform"];
    _clientId=[dic objectForKey:@"clientid"];
    _receiver=[dic objectForKey:@"receiver"];
    _addTime = [dic objectForKey:@"addtime"];
}
-(void)getDetailInfo:(NSString*)newsId
{
    if(newsId == nil)
        return;
    _newsId = newsId;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:newsId forKey:@"msgid"];
    [self creatBusinessWithId:BUSINESS_NOTIFICATIONNEWS_DETAIL andExecuteWithData:dic];
}

-(void)updateReadStatus
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:_newsId forKey:@"msgid"];
    [self creatBusinessWithId:BUSINESS_NOTIFICATIONNEWS_READ andExecuteWithData:dic];
}

#pragma mark - BusinessProtocl
- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary*)businessData
{
    if(business.businessId == BUSINESS_NOTIFICATIONNEWS_READ)
    {
        _isRead = ReadStauts_Read;
    }
    else if(business.businessId == BUSINESS_NOTIFICATIONNEWS_DETAIL)
    {
        NSDictionary *data=[businessData objectForKey:@"data"];
        [self fillData:data];
    }
    
    
    [super didBusinessSucess:business withData:businessData];
}
@end
