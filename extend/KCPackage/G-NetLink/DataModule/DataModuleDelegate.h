//
//  DataModuleDelegate.h
//  MessageFrame
//
//  Created by 95190 on 13-4-7.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessType.h"
@class BaseDataModule;

@protocol DataModuleDelegate <NSObject>
-(void)didDataModuleNoticeSucess:(BaseDataModule*)baseDataModule forBusinessType:(enum BusinessType)businessID;
-(void)didDataModuleNoticeFail:(BaseDataModule*)baseDataModule forBusinessType:(enum BusinessType)businessID forErrorCode:(int)errorCode forErrorMsg:(NSString*)errorMsg;
@end


@protocol DataModuleTransferFileDelegate <NSObject>
-(void)didDataModuleNoticeDownLoadFileing:(BaseDataModule*)baseDataModule forByteCount:(long long)byteCount forTotalByteCount:(long long)totalByteCount;
@end