//
//  UserInformations.m
//  G-NetLink-v2.0
//
//  Created by jk on 3/16/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import "UserInformations.h"

@implementation UserInformations {
    UserCurrentStatus _usercurrentstatus;
    NSMutableDictionary * m_dictionaryForVehicles;
    BOOL _isrundemo;
    BOOL _isautologin;
    BOOL _issaveuserkey;
    BOOL _isconfirmprotocol;
    BOOL _iskcuser;
    BOOL _ismapflag;
    
    NSString * _accesstoken;
    NSString * _username;
    NSString * _uservin;
    NSString * _userid;
    NSString * _usertype;
    NSString * _userbrandID;
    NSString * _telephonenum;
    NSString * _defaultvehicletype;
    NSString * _defaultvehiclelisence;
    NSString * _defaultvehiclevin;
    
    NSString * _kcuuid;
    NSString * _kctuid;
    NSString * _kcsname;
    NSString * _kcsaddr;
    NSString * _kcstel;
    NSString * _kcutel;
    NSMutableDictionary * m_dictForKCSim;
}

- (id) init {
    if (self = [super init]) {
        _isrundemo = NO;
        _isautologin = NO;
        _issaveuserkey = NO;
        _isconfirmprotocol = NO;
        _iskcuser = NO;
        
        _ismapflag = NO;
    }
    return self;
}


- (void) doSetValueForUserInformationsWithKey:(UserInformationsKey)key Value:(NSString *)value {
    if (key == InformationsKeyAccessToken) {
        _accesstoken = value;
    }
    
    if (key == InformationsKeyUserID) {
        _userid = value;
    }
    
    if (key == InformationsKeyUserName) {
        _username = value;
    }
    
    if (key == InformationsKeyUserVin) {
        _uservin = value;
    }
    
    if (key == InformationsKeyUserType) {
        _usertype = value;
        
        if ([value isEqualToString:@"KC"]) _iskcuser = YES;
        else _iskcuser = NO;
    }
    
    if (key == InformationsKeyUserBrandID) {
        _userbrandID = value;
    }
    
    if (key == InformationsKeyTelePhoneNum) {
        _telephonenum = value;
    }
    
    if (key == InformationsKeyDefaultVehicleVin) {
        _defaultvehiclevin = value;
    }
    
    if (key == InformationsKeyDefaultVehicleType) {
        _defaultvehicletype = value;
    }
    
    if (key == InformationsKeyDefaultVehicleLisence) {
        _defaultvehiclelisence = value;
    }
    
    if (key == InformationsKeyRunMode) {
        _isrundemo = [value isEqualToString:@"DEMO"];
    }
    
    if (key == InformationsKeyMaplineFlag) {
        _ismapflag = [value isEqualToString:@"ON"];
    }
    
    if (key == InformationsKeyAutoLogin) {
        _isautologin = [value isEqualToString:@"OK"];
    }
    
    if (key == InformationsKeySaveUserKey) {
        _issaveuserkey = [value isEqualToString:@"OK"];
    }
    
    if (key == InformationsKeyConfirmProtocol) {
        _isconfirmprotocol = [value isEqualToString:@"OK"];
    }
    
    if (key == InformationsKeyKCUuid) {
        _kcuuid = value;
    }
    
    if (key == InformationsKeyKCTuid) {
        _kctuid = value;
    }
    
    if (key == InformationsKeyKCsName) {
        _kcsname = value;
    }
    
    if (key == InformationsKeyKCsAddr) {
        _kcsaddr = value;
    }
    
    if (key == InformationsKeyKCsTel) {
        _kcstel = value;
    }
    
    if (key == InformationsKeyKCuTel) {
        _kcutel = value;
    }
    
    if (key == InformationsKeyRunStatus) {
        if ([value isEqualToString:@"OFFLINE"]) {
            _usercurrentstatus = UserStatusIsOffline;
        }
        else if ([value isEqualToString:@"ONLINE"]) {
            _usercurrentstatus = UserStatusIsOnline;
        }
        else if ([value isEqualToString:@"OTHERLINE"]) {
            _usercurrentstatus = UserStatusIsOtherline;
        }
        else if ([value isEqualToString:@"EXITLINE"]) {
            _usercurrentstatus = UserStatusIsExitline;
        }
    }
}

- (BOOL) isRunDemo{
    return _isrundemo;
}

- (BOOL) isMapFlag {
    return _ismapflag;
}

- (BOOL) isAutoLogin{
    return _isautologin;
}

- (BOOL) isSaveUserKey{
    return _issaveuserkey;
}

- (BOOL) isConfirmProtocol{
    return _isconfirmprotocol;
}

- (BOOL) isKCUser {
    return _iskcuser;
}

- (UserCurrentStatus) gUserCurrentStatus {
    return _usercurrentstatus;
}

- (NSString *) gAccessToken {
    return _accesstoken;
}

- (NSString *) gUserName {
    return _username;
}

- (NSString *) gUserVin {
    return _uservin;
}

- (NSString *) gUserID {
    return _userid;
}

- (NSString *) gUserType {
    return _usertype;
}

- (NSString *) gUserBrandID {
    return _userbrandID;
}

- (NSString *) gTelePhoneNum {
    return _telephonenum;
}

- (NSString *) gDefaultVehicleType {
    return _defaultvehicletype;
}

- (NSString *) gDefaultVehicleLisence {
    return _defaultvehiclelisence;
}
- (NSString *) gDefaultVehicleVin {
    return _defaultvehiclevin;
}

- (NSString *) gKCUuid {
    return _kcuuid;
}

- (NSString *) gKCTuid {
    return _kctuid;
}

- (NSString *) gKCsName {
    return _kcsname;
}

- (NSString *) gKCsAddr {
    return _kcsaddr;
}

- (NSString *) gKCsTel {
    return _kcstel;
}

- (NSString *) gKCuTel {
    return _kcutel;
}

- (void) addVehicleForUserList:(VehicleInformations *)value {
    if ([value.vin isEqualToString:@""] || value.vin == nil) return;
    if (m_dictionaryForVehicles == nil) {
        m_dictionaryForVehicles = [[NSMutableDictionary alloc]init];
    }
    [m_dictionaryForVehicles setObject:value forKey:value.vin];
}

- (void) resetVehicleForUserList {
    m_dictionaryForVehicles = [[NSMutableDictionary alloc]init];
    _defaultvehiclevin = nil;
    _defaultvehiclelisence = nil;
//    _defaultvehicletype = nil;
}

- (NSDictionary *) gVehicleList {
    return m_dictionaryForVehicles;
}

- (void) addUserInfoForKCSim:(NSString *)value Key:(NSString *)key {
    if ([value isEqualToString:@""] || value == nil) return;
    if (m_dictForKCSim == nil) {
        m_dictForKCSim = [[NSMutableDictionary alloc]init];
    }
    [m_dictForKCSim setObject:value forKey:key];
}

- (NSDictionary *) gKCUserSim {
    return m_dictForKCSim;
}

- (void) clearData {
    
}

@end
