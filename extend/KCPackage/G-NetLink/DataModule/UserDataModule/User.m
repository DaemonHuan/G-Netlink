//
//  User.m
//  G-NetLink
//
//  Created by jayden on 14-4-14.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "User.h"
#import "UserInfo.h"
#import "NtspHeader.h"
#import "BusinessFactory.h"
#import "UserPhone.h"
#import "JPushNotification.h"

#define SAVE_FILE_NAME @"userSeting.json"

static User *user;

@interface User()
{
    NSString *saveNewPassword;
    NSString *saveFilePath;
}
-(void)destroyUser;
-(void)writeLocalFile;
-(void)readLocalFile;
@end

@implementation User

+(User*)shareUser
{
    if(user == nil)
        user = [[User alloc] init];
    return user;
}

-(id)init
{
    if (self = [super init]) {
        _userInfo=[[UserInfo alloc]init];
        _phone_num = 0;
        _phoneNumberArray = [[NSArray alloc]init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        saveFilePath = [paths objectAtIndex:0];
        saveFilePath = [saveFilePath stringByAppendingString:@"/"];
        saveFilePath = [saveFilePath stringByAppendingString:SAVE_FILE_NAME];
        [self readLocalFile];
    }
    return self;
}

-(void)login:(NSString  *)mobileNumber withPassword:(NSString  *)password
{
    _mobileNumber=mobileNumber;
    _password=password;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:mobileNumber forKey:@"mobilenumber"];
    [dict setObject:password forKey:@"password"];
    //[dict setObject:[SHA1 stringConvertSHA1:self.userPassword] forKey:@"password"];
    
    [self creatBusinessWithId:BUSINESS_LOGIN andExecuteWithData:dict];
}

-(void)logout
{
//     [self creatBusinessWithId:BUSINESS_LOGOUT andExecuteWithData:nil];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:saveFilePath error:&error];
//        NSLog(@"文件移除成功");
    
    [((JPushNotification*)[PushNotification sharePushNotification]) registerUserTags:nil andAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
    
    [self destroyUser];
}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

-(void)commitFeed:(NSString  *)feed withContract:(NSString  *)contact
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:feed forKey:@"feedback_content"];
    [dict setObject:contact forKey:@"contact"];
    NSDictionary *feedinfo= [NSDictionary dictionaryWithObject:dict forKey:@"feedbackInfo"];
    [self creatBusinessWithId:BUSINESS_COMMITFEEDBACK andExecuteWithData:feedinfo];
}


-(void)destroyUser
{
    _userInfo=[[UserInfo alloc]init];
    _userLoginStatus=UserLoginStatus_Logout;
}

-(void)writeLocalFile
{
    if(_mobileNumber == nil || _password == nil)
        return;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithBool:self.autoLoginFlag] forKey:@"autoLoginFlag"];
    [dic setObject:[NSNumber numberWithBool:self.rememberFlag] forKey:@"rememberFlag"];
    [dic setObject:_mobileNumber forKey:@"mobileNumber"];
    [dic setObject:_password forKey:@"password"];
    [dic setObject:[NSNumber numberWithBool:self.wifiCheck] forKey:@"wifiCheck"];
    
    [dic setObject:[NSNumber numberWithInteger:_phone_num] forKey:@"phone_num"];
    [dic setObject: _phoneNumberArray forKey:@"phoneNumberArray"];
    
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
    _mobileNumber = [dic objectForKey:@"mobileNumber"];
    _password = [dic objectForKey:@"password"];
    _autoLoginFlag = [[dic objectForKey:@"autoLoginFlag"] boolValue];
    _rememberFlag = [[dic objectForKey:@"rememberFlag"] boolValue];
    _wifiCheck = [[dic objectForKey:@"wifiCheck"] boolValue];
    if([dic objectForKey:@"phoneNumberArray"])
    _phoneNumberArray = [dic objectForKey:@"phoneNumberArray"];
    if ([dic objectForKey:@"phone_num"])
    _phone_num = [[dic objectForKey:@"phone_num"]integerValue];
}

-(void)setAutoLoginFlag:(BOOL)autoLogin
{
    _autoLoginFlag=autoLogin;
    [self writeLocalFile];
}

-(void)setRememberFlag:(BOOL)remember
{
    _rememberFlag=remember;
    [self writeLocalFile];
}

#pragma mark - BusinessProtocl
- (void)didBusinessSucess:(BaseBusiness *)business withData:(NSDictionary*)businessData
{
    if(business.businessId == BUSINESS_LOGIN)
    {
        NSDictionary *data=[businessData objectForKey:@"data"];
        _accesst_token=[data objectForKey:@"access_token"];
        _uuid=[data objectForKey:@"uuid"];
        _tuid=[data objectForKey:@"tuid"];
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:data];
        [dic setObject:_mobileNumber forKey:@"mobilenumber"];
        [NtspHeader setWithJson:dic];
        if (_rememberFlag) {
            [self writeLocalFile];
        }
        _userLoginStatus=UserLoginStatus_Login;
    }
    else if (business.businessId == BUSINESS_LOGOUT)
    {
     
    }
    else if (business.businessId == BUSINESS_COMMITFEEDBACK)
    {
        
    }
    else if (business.businessId == BUSINESS_LOGINCOUNT)
    {
        // 获取登录次数
        
    }
    else if (business.businessId == BUSINESS_PHONENUMBERGET)
    {
        NSDictionary * dictionary=[businessData objectForKey:@"data"];
           _phone_num = [[dictionary objectForKey:@"phone_num"]integerValue];

        NSArray * phone_list = [dictionary objectForKey:@"phone_list"];
        NSMutableArray * phone_list_array= [[NSMutableArray alloc]init];
        
        for (NSDictionary * dict in phone_list) {
            UserPhone * userPhone = [[UserPhone alloc]init];;
           userPhone.mobile_phone =  [dict objectForKey:@"mobile_phone"];
           userPhone.bnd_time =  [dict objectForKey:@"bind_time"];
            [phone_list_array addObject:userPhone];
        }
        _phoneNumberArray = phone_list_array;

        if (_rememberFlag) {
            [self writeLocalFile];
        }

    }
    else if (business.businessId == BUSINESS_PHONENUMBERREMOVE)
    {
        
    }
    else if (business.businessId == BUSINESS_PHONENUMBERBINDING)
    {
        
    }
    
    [super didBusinessSucess:business withData:businessData];
}

-(void)getLoginCount
{
    [self creatBusinessWithId:BUSINESS_LOGINCOUNT andExecuteWithData:nil];
}


-(void)getMobilePhone
{

    [self creatBusinessWithId:BUSINESS_PHONENUMBERGET andObserver:self andExecuteWithData:nil];
}

-(void)removeMobilePhone:(NSString * )phoneNumber
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:phoneNumber forKey:@"mobilephone"];
    [self creatBusinessWithId:BUSINESS_PHONENUMBERREMOVE andExecuteWithData:dic];
}

-(void)bindingMobilePhone:(NSString * )phoneNumber
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:phoneNumber forKey:@"mobilephone"];
    [self creatBusinessWithId:BUSINESS_PHONENUMBERBINDING andExecuteWithData:dic];
}


@end
