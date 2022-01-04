//
//  NotificationNews.h
//  G-NetLink
//
//  Created by jayden on 14-4-22.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseDataModule.h"

@interface NotificationNews : BaseDataModule
{
    @protected
    NSMutableArray *_news;
    NSArray *_deleteNews;
    BOOL _bReadNews;
}
@property(nonatomic,readonly)NSArray *news;
@property(nonatomic,readonly,assign)int pagecount;
@property(nonatomic,readonly,assign)int recordcount;
//@property(readonly, nonatomic) NSInteger unReadNewsNum;
@property(nonatomic,readonly,assign)int readcount;
@property(nonatomic,readonly,assign)int unreadcount;
//不清楚有无筛选机制，如需要后期添加参数
-(void)getNews:(int)pageindex forpagesize:(int)pagesize;
-(void)deleteNews:(NSArray*)newsArray;
//-(void) getUnReadNewsNum;
-(void)getNewsCount;
@end
