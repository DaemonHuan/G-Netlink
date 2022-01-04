//
//  ClientVersion.m
//  G-NetLink
//
//  Created by jayden on 14-4-22.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "ClientVersion.h"

#define SAVE_FILE_NAME @"clientVersionSeting.json"

@interface ClientVersion()
{
    NSString *saveNewPassword;
    NSString *saveFilePath;
}
-(void)writeLocalFile;
-(void)readLocalFile;
@end

@implementation ClientVersion

-(void)writeLocalFile
{ 
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (_nowVersion)
    {
        [dic setObject:_nowVersion forKey:@"nowVersion"];
    }
    if (_latestVersion)
    {
        [dic setObject:_latestVersion forKey:@"latestVersion"];
    }

    
    if (_upgrade)
    {
        [dic setObject:_upgrade forKey:@"upgrade"];
    }
    
    if (_introduction)
    {
        [dic setObject:_introduction forKey:@"introduction"];
    }

    if (_url)
    {
         [dic setObject:_url forKey:@"url"];
    }
   
    if (_versionname)
    {
         [dic setObject:_versionname forKey:@"versionname"];
    }
    [dic setObject:[NSNumber numberWithBool:_autoUpdateFlag] forKey:@"autoUpdateFlag"];

    if(![NSJSONSerialization isValidJSONObject:dic])
        return;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [data writeToFile:saveFilePath atomically:YES];
}

-(void)readLocalFile
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:saveFilePath];
    if(data==nil)
        return;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if(dic==nil)
        return;
    
    _nowVersion = [dic objectForKey:@"nowVersion"];
    _latestVersion = [dic objectForKey:@"latestVersion"];
    _upgrade = [dic objectForKey:@"upgrade"];
    _introduction = [dic objectForKey:@"introduction"] ;
    _url = [dic objectForKey:@"url"];
    _versionname = [dic objectForKey:@"versionname"];
    _autoUpdateFlag = [[dic objectForKey:@"autoUpdateFlag"] boolValue];
    
}

-(id)init
{
    if (self = [super init]) {
        _nowVersion = CLIENT_VERSION;
        _autoUpdateFlag = YES;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        saveFilePath = [paths objectAtIndex:0];
        saveFilePath = [saveFilePath stringByAppendingString:@"/"];
        saveFilePath = [saveFilePath stringByAppendingString:SAVE_FILE_NAME];
        [self readLocalFile];
        
    }
    return self;
}

-(void)getLatestVersion
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[CLIENT_TYPE,CLIENT_VERSION] forKeys:@[@"versiontype",@"version"]];
    [self creatBusinessWithId:BUSINESS_OTHER_CLIENTVERSION andExecuteWithData:dic];
}

-(void)setAutoUpdateFlag:(BOOL)autoUpdateFlag
{
    _autoUpdateFlag=autoUpdateFlag;
    [self writeLocalFile];
}


-(BOOL)isNeedUpdate
{
//    //若服务器版本号为空，或异常，则不升级
//    if((self.versionname == nil) || ([self.versionname length] <= 0))
//        return NO;
//    
//    //本地软件版本号
////    NSString *selfVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    
//    NSString * selfVersion = CLIENT_VERSION;
//    
//    //如果本地软件版本号和服务器版本号相同，不升级
//    if([self.versionname isEqualToString: selfVersion])
//    {
//        return NO;
//    }
//    
//    //如果本地软件版本号和服务器版本号长度不一样，升级
////    if([self.versionname length] != [selfVersion length])
////    {
////        return YES;
////    }
//    
//    int leng = [self.versionname length];
//    //版本号长度一致，则逐个比较，任一服务器号码大于本地版本号，则升级
//    for (int i=0; i<leng; i++)
//    {
//        NSInteger serviceVersion = [[self.versionname substringWithRange:NSMakeRange(i, 1)] intValue];
//        NSInteger localVersion = [[selfVersion substringWithRange:NSMakeRange(i, 1)] intValue];
//        if(serviceVersion > localVersion)
//        {
//            return YES;
//        }
//    }
//    
//    return NO;
    if([self.upgrade isEqualToString:@"N"])
        return NO;
    return YES;
}

#pragma mark - BusinessProtocl
- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary*)businessData
{
    if(business.businessId == BUSINESS_OTHER_CLIENTVERSION)
    {
        if((NSNull *)businessData!=[NSNull null])
        {
            NSDictionary *infoDic = [businessData valueForKey:@"data"];
            
            if((NSNull *)[infoDic valueForKey:@"version"]!=[NSNull null])
                _latestVersion = [infoDic valueForKey:@"version"];
            
            if((NSNull *)[infoDic valueForKey:@"upgrade"]!=[NSNull null])
                _upgrade = [infoDic valueForKey:@"upgrade"];
            
            if((NSNull *)[infoDic valueForKey:@"url"]!=[NSNull null])
                _url = [infoDic valueForKey:@"url"];
            
            if((NSNull *)[infoDic valueForKey:@"introduction"]!=[NSNull null])
                _introduction = [infoDic valueForKey:@"introduction"];
            
            if((NSNull *)[infoDic valueForKey:@"versionname"]!=[NSNull null])
                _versionname = [infoDic valueForKey:@"versionname"];
        }
    }
    [super didBusinessSucess:business withData:businessData];
}

@end
