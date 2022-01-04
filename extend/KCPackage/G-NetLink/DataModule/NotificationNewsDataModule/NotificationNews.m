//
//  NotificationNews.m
//  G-NetLink
//
//  Created by jayden on 14-4-22.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "NotificationNews.h"
#import "News.h"

@implementation NotificationNews
-(id)init
{
    self = [super init];
    _news = [[NSMutableArray alloc] init];
    _bReadNews = NO;
    return self;
}

-(void)getNews:(int)pageindex forpagesize:(int)pagesize
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageindex],@"pageindex",[NSString stringWithFormat:@"%d",pagesize],@"pagesize", nil];
    
    [self creatBusinessWithId:BUSINESS_NOTIFICATIONNEWS_QUERY andExecuteWithData:dic];
}

-(void)getNewsCount
{
    [self creatBusinessWithId:BUSINESS_NOTIFICATIONNEWS_COUNT_QUERY andExecuteWithData:nil];
}

-(void)deleteNews:(NSArray*)newsArray
{
    _deleteNews = newsArray;
    NSString *deleteID = @"";
    for(int n=0;n<newsArray.count;n++)
    {
        News *news = [newsArray objectAtIndex:n];
        if([news isKindOfClass:[News class]])
        {
            deleteID = [deleteID stringByAppendingString:news.newsId];
            if(n!=newsArray.count-1)
                deleteID = [deleteID stringByAppendingString:@","];
        }
        else
            continue;
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:deleteID,@"msgids", nil];
    [self creatBusinessWithId:BUSINESS_NOTIFICATIONNEWS_DELETE andExecuteWithData:dic];
}

#pragma mark - BusinessProtocl
- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary*)businessData
{
    if(business.businessId == BUSINESS_NOTIFICATIONNEWS_QUERY)
    {
        [_news removeAllObjects];
        
        NSDictionary *data=[businessData objectForKey:@"data"];
        _pagecount = [[data objectForKey:@"pagecount"] intValue];
        _recordcount = [[data objectForKey:@"rowcount"] intValue];
        NSArray *msgs=[data objectForKey:@"sendmsg"];
        if ((NSNull *)msgs!=[NSNull null]) {
            [msgs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                News *news=[[News alloc] initWithDic:obj];
                [_news addObject:news];
            }];
        }
        
        _bReadNews = NO;
    }
    else if(business.businessId == BUSINESS_NOTIFICATIONNEWS_DELETE)
    {
        [_news removeObjectsInArray:_deleteNews];
    }
    else if(business.businessId == BUSINESS_NOTIFICATIONNEWS_COUNT_QUERY)
    {
         NSDictionary *data=[businessData objectForKey:@"data"];
        _readcount = [[data objectForKey:@"readcount"] intValue];
        _unreadcount = [[data objectForKey:@"unreadcount"] intValue];
    }
    [super didBusinessSucess:business withData:businessData];
}
@end
