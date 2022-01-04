//
//  public.h
//  G-NetLink-v2.0
//
//  Created by jk on 3/17/16.
//  Copyright © 2016 jk. All rights reserved.
//

#ifndef G_NETLINK_BETA_PUBLIC_HH
#define G_NETLINK_BETA_PUBLIC_HH

// Header Files
#import "UIColor+Hex.h"     // HEX 颜色值转换UIColor
#import "GetPostSessionData.h"      // Post Session 接口
#import "SCGIFImageView.h"      // GIF UIImageView 显示
#import "DJRefresh.h"           // TableView 下拉刷新

#import "ExtendStaticView.h"
#import "ExtendStaticFunctions.h"

#import "ProcessBoxView.h"      // 进度提示窗口
#import "ProcessBoxCommandView.h"   // 命令进度提示窗
#import "AlertBoxView.h"        // 消息提示窗口
#import "PinEditorView.h"         // PIN 码输入窗口

#import "HttpHead.h"        // KC Http Header
#import <objc/runtime.h>        // UIDatePicker 当前时间颜色问题解决

// Public Data
//#define HTTP_GET_POST_ADDRESS @"https://gnetlink.yesway.cn"
#define HTTP_GET_POST_ADDRESS @"http://111.207.49.72:9080"      // Test
//#define HTTP_GET_POST_ADDRESS @"https://123.56.193.135/"      // Produce
//#define HTTP_GET_POST_ADDRESS_KC @"http://geely.yesway.cn:8093"     // kc 地址
#define HTTP_GET_POST_ADDRESS_KC @"http://101.201.29.64:8093"

#define FONT_XI @"FZLanTingHei-EL-GBK"
#define FONT_MM @"FZLanTingHei-M-GBK"

#define SERVICE_CODE "022-55555555"
#define APP_VERSION_CODE @"4.3.3"

//
#define NL_VERSION_CODE @"4.3.3"

//
#define MAP_BUNDLEIDENTIFIER @"18ea8b8d315b22ca5adcb86dbd391d74"

// 风格颜色
#define WORD_COLOR_GLODEN @"D4B481"
#define WORD_COLOR_BLUE @"007AFF"
#define COLOR_BG_DARK @"171717"

#define FONT_S_TITLE1 20.0f
#define FONT_S_TITLE2 18.0f
#define FONT_S_WORD 17.0f
#define FONT_S_DETAIL 15.0f

// alert view messages
#define NETWORK_ERROR @"连接服务器失败\n请稍后重试"
#define NETWORK_TIMEOUT @"连接服务器超时\n请稍后重试"
#define DATA_LOAD_ERROR @"数据加载失败\n请重新刷新"
#define DATA_ERROR @"数据错误\n请重新刷新"

#define USERINFO_CAR_LATITUDE @"USERINFO_LOCATION_CAR_LATITUDE"
#define USERINFO_CAR_LONGITUDE @"USERINFO_LOCATION_CAR_LONGITUDE"

//
#define POST_TIME_OUT 30
#define POST_WHILE_SPACE 2.0f
#define POST_TIME_FOR_VEHICLESTATUS 90.0f
#define POST_TIME_FOR_COMMANDRESULT 60.0f
#define POST_TIME_FOR_COMMANDSTATUS 90.0f



#endif /* public_h */
