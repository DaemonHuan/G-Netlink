//
//  CommandID.h
//  MessageFrame
//
//  Created by 95190 on 13-4-1.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#ifndef MessageFrame_CommandID_h
#define MessageFrame_CommandID_h

enum CommandID
{
    //MC是message command的首字母大写
    MC_CREATE_NORML_VIEWCONTROLLER = 1,              //普通建立
    MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER,       //滚动建立从左
    MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER,      //滚动建立从右
    MC_CREATE_GRADUALLYINTO_VIEWCONTROLLER,          //渐入建立
    MC_CREATE_GRADUALLYOUT_VIEWCONTROLLER,           //淡出建立
    MC_CREATE_FLIPFROMLEFT_VIEWCONTROLLER,           //翻滚建立从左
    MC_CREATE_PUSHFROMLEFT_VIEWCONTROLLER,           //推入建立从左
    MC_CREATE_PUSHFROMRIGHT_VIEWCONTROLLER,          //推入建立从右
    MC_CREATE_OPENFROMRIGHT_VIEWCONTROLLER,          //打开方式建立
    MC_CREATE_CLOSEFROMRIGHT_VIEWCONTROLLER,         //关闭方式建立
    MC_CHILD_NODE_CLEAR_VALUE,                       //删除所属所有子节点的保存值
    MC_SHOW_ROOT_TABBAR,
    MC_HIDE_ROOT_TABBAR,
    MC_TABBAR_0,
    MC_TABBAR_1,
    MC_TABBAR_2,
    MC_TABBAR_3,
};

#endif
