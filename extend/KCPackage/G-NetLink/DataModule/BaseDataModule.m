//
//  BaseDataModule.m
//  MessageFrame
//
//  Created by 95190 on 13-4-7.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "BaseDataModule.h"
#import "BusinessFactory.h"

@implementation BaseDataModule

- (void)creatBusinessWithId:(NSInteger)businessId andExecuteWithData:(NSDictionary *)dic
{
    [self creatBusinessWithId:businessId andObserver:self andExecuteWithData:dic];
}

- (void)creatBusinessWithId:(NSInteger)businessId andObserver:(id<BusinessProtocl>)observer andExecuteWithData:(NSDictionary *)dic
{
    baseBusiness = [BusinessFactory createBusiness:businessId];
    baseBusiness.businessObserver = observer;
    [baseBusiness execute:dic];
}

#pragma mark - BusinessProtocl
- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary *)businessData
{
    [self.observer didDataModuleNoticeSucess:self forBusinessType:business.businessId];

    if(baseBusiness.baseBusinessHttpConnect.stauts==HttpContentStauts_DidStop || baseBusiness.baseBusinessHttpConnect.stauts == HttpContentStauts_DidFinishRespones)
        baseBusiness = nil;
}
- (void)didBusinessFail
{
    [self.observer didDataModuleNoticeFail:self forBusinessType:baseBusiness.businessId forErrorCode:-1 forErrorMsg:nil];
  
    if(baseBusiness.baseBusinessHttpConnect.stauts==HttpContentStauts_DidStop || baseBusiness.baseBusinessHttpConnect.stauts == HttpContentStauts_DidFinishRespones)
        baseBusiness = nil;
}
- (void)didBusinessError:(BaseBusiness *)business 
{
    [self.observer didDataModuleNoticeFail:self forBusinessType:business.businessId forErrorCode:business.errCode forErrorMsg:business.errmsg];
    
    if(baseBusiness.baseBusinessHttpConnect.stauts==HttpContentStauts_DidStop || baseBusiness.baseBusinessHttpConnect.stauts == HttpContentStauts_DidFinishRespones)
        baseBusiness = nil;
}
-(void)dealloc
{
    if(baseBusiness!=nil)
    {
        baseBusiness.businessObserver = nil;
        [baseBusiness cancel];
    }
}
@end
