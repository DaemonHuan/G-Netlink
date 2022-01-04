////
////  MBNaviDataManager.h
////  iNaviCore
////
////  Created by fanyl on 14-8-8.
////  Copyright (c) 2014年 Mapbar. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//@protocol MBNaviDataManagerDelegate <NSObject>
//@optional
//-(void)datastoreRefreshed;
//-(void)datastoreRefreshFailed;
//
//-(void)dataEntitiesChanged;
//
//-(void)applyStarted;
//-(void)applyProgressChanged;
//-(void)applySucceed;
//-(void)applyFailed;
//
//// unfinished
//-(void)schemeUpdateStarted;
//-(void)schemeUpdateProgressChanges;
//-(void)schemeUpdateFinished;
//@end
//
//@class MBNaviDataEntity;
//@interface MBNaviDataManager : NSObject
//+(id)sharedNaviDataManager;
//@property(nonatomic,retain) NSString* baseURL;
//@property(nonatomic,assign) id<MBNaviDataManagerDelegate> delegate;
//-(NSInteger)dataEntityNumber;
//-(MBNaviDataEntity*)dataEntityByIndex:(NSInteger)index;
//-(MBNaviDataEntity*)dataEntityByDataId:(NSString*)dataId;
//-(void)deleteLocalDataByDataId:(NSString*)dataId;
//-(void)refreshDatastore;
//-(void)applyDataByDataId:(NSString*)dataId;
//-(void)setPurchasedDataIds:(NSArray*)dataIds;
//
//#pragma mark - TEST FUNCTIONS
//-(void)setVersionLimit:(NSInteger)version;
//-(void)loadDataStoreFromFile:(NSString*)filename;
//-(NSString*)getLocalEntityFile;
//@end
