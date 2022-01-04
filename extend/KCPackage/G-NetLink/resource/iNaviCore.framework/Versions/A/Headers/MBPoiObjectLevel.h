//
//  MBPoiObjectLevel.h
//  iNaviCore
//
//  Created by delon on 13-2-27.
//
//

#ifndef NaviCore_MBPoiObjectLevel_h
#define NaviCore_MBPoiObjectLevel_h

//poi收藏类型
typedef enum MBPoiObjectLevel
{
    MBPoiObjectLevel_userFavorite,
    MBPoiObjectLevel_userShortcuts,
    MBPoiObjectLevel_historyDestination
} MBPoiObjectLevel;
//poi收藏类型的编辑模式
typedef enum MBPoiEditMode
{
    MBPoiEditMode_getlist,
    MBPoiEditMode_add,
    MBPoiEditMode_delete,
    MBPoiEditMode_modify
} MBPoiEditMode;

#endif
