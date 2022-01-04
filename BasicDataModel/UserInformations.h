//
//  UserInformations.h
//  G-NetLink-v2.0
//
//  Created by jk on 3/16/16.
//  Copyright © 2016 jk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VehicleInformations.h"

typedef NS_ENUM(NSInteger, UserInformationsKey) {
    InformationsKeyAccessToken = 0,
    InformationsKeyUserName,
    InformationsKeyUserID,
    InformationsKeyUserVin,
    InformationsKeyTelePhoneNum,
    InformationsKeyUserType,
    InformationsKeyUserBrandID,

    InformationsKeyRunMode,
    InformationsKeyRunStatus,
    
    InformationsKeyDefaultVehicleType,
    InformationsKeyDefaultVehicleLisence,
    InformationsKeyDefaultVehicleVin,
    
    InformationsKeyAutoLogin,
    InformationsKeySaveUserKey,
    InformationsKeyConfirmProtocol,
    InformationsKeyMaplineFlag,
    
    InformationsKeyKCUuid,
    InformationsKeyKCTuid,
    InformationsKeyKCsName,
    InformationsKeyKCsAddr,
    InformationsKeyKCsTel,
    InformationsKeyKCuTel
};

typedef NS_ENUM(NSInteger, UserCurrentStatus) {
    UserStatusIsOnline = 0,
    UserStatusIsOffline,
    UserStatusIsOtherline,
    UserStatusIsExitline
};

@interface UserInformations : NSObject

- (void) doSetValueForUserInformationsWithKey:(UserInformationsKey)key Value:(NSString *)value;

- (BOOL) isRunDemo;
- (BOOL) isAutoLogin;
- (BOOL) isSaveUserKey;
- (BOOL) isConfirmProtocol;
- (BOOL) isKCUser;
- (BOOL) isMapFlag;
- (UserCurrentStatus) gUserCurrentStatus;

- (NSString *) gAccessToken;
- (NSString *) gUserName;
- (NSString *) gUserVin;
- (NSString *) gUserID;
- (NSString *) gUserType;
- (NSString *) gUserBrandID;
- (NSString *) gTelePhoneNum;
- (NSString *) gDefaultVehicleType;
- (NSString *) gDefaultVehicleLisence;
- (NSString *) gDefaultVehicleVin;

- (NSString *) gKCUuid;
- (NSString *) gKCTuid;
- (NSString *) gKCsName;
- (NSString *) gKCsAddr;
- (NSString *) gKCsTel;
- (NSString *) gKCuTel;

- (void) addVehicleForUserList:(VehicleInformations *)value;
- (void) resetVehicleForUserList;
- (NSDictionary *) gVehicleList;

- (void) addUserInfoForKCSim:(NSString *)value Key:(NSString *)key;
- (NSDictionary *) gKCUserSim;

- (void) clearData;

@end
