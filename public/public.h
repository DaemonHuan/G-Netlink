//
//  public.h
//  G-NetLink-beta0.1
//
//  Created by jk on 10/20/15.
//  Copyright © 2015 jk. All rights reserved.
//

#ifndef G_NETLINK_BETA_PUBLIC_HH
#define G_NETLINK_BETA_PUBLIC_HH

#define APP_VERSION_MAJOR 1
#define APP_VERSION_MINOR 0

//#define HTTP_GET_POST_ADDRESS @"https://123.56.193.45:8443"
#define HTTP_GET_POST_ADDRESS @"https://gnetlink.yesway.cn"
//#define HTTP_GET_POST_ADDRESS @"https://220.181.190.216:8443"

#define FONT_XI @"FZLanTingHei-EL-GBK"
#define FONT_MM @"FZLanTingHei-M-GBK"


#define SERVICE_CODE "022-55555555"

#define MAP_BUNDLEIDENTIFIER @"18ea8b8d315b22ca5adcb86dbd391d74"

#define XIB_FRAME_FONT_SIZE 20

// 风格颜色
#import "UIColor+Hex.h"
#import "ServicesPro.h"
#define BackGroudColor @"171E26"
#define WordColor @"E8D39C"
#define SkinColor @"B4B481"

#define WORD_COLOR @"F0AF5F"


#define FONT_S_TITLE 18.0f
#define FONT_S_TITLE2 17.0f
#define FONT_S_WORD 15.0f

// alert view messages
#define NETWORK_ERROR @"连接服务器失败\n请稍后重试"
#define NETWORK_TIMEOUT @"连接服务器超时\n请稍后重试"
#define DATA_LOAD_ERROR @"数据加载失败\n请重新刷新"
#define DATA_ERROR @"数据错误\n请重新刷新"

#define POST_TIME_OUT 30
#define POST_WHILE_SPACE 2.0f
#define USERINFO_CAR_LATITUDE @"USERINFO_LOCATION_CAR_LATITUDE"
#define USERINFO_CAR_LONGITUDE @"USERINFO_LOCATION_CAR_LONGITUDE"

#endif // G_NETLINK_BETA_PUBLIC_HH
