//
//  MBNative.h
//  Navigation
//
//  Created by delon on 12-12-27.
//
//

#ifndef MBGLMAP_MBNativePrivate_h
#define MBGLMAP_MBNativePrivate_h

//#define Point cqPoint
//#define Rect cqRect
//#define Handle cqHandle
//#define Size cqSize
//
//#ifdef __cplusplus
//extern "C"
//{
//#endif
//    
//#include "cq_stdlib.h"
//    
//#ifdef __cplusplus
//};
//#endif
//
//#include "glmap/glmap_types.h"
//#include "glmap/map_render3.h"
//#include "glmap/overlay.h"
//#include "logic/track_overlay.h"
//#include "logic/route_overlay.h"
//
//#undef Point
//#undef Rect
//#undef Handle
//#undef Size


typedef enum _MBRenderQuality
{
    MBRenderQuality_low = 1,
    MBRenderQuality_medium = 2,
    MBRenderQuality_high = 3
} _MBRenderQuality;

typedef enum _MBUrlType
{
    MBUrlType_basicMap = 0,
    MBUrlType_tmcRoadShape,
    MBUrlType_model3d,
    MBUrlType_panorama,
    MBUrlType_tmcTraffic,
    MBUrlType_tmcProvinceList,
    MBUrlType_satellite
}_MBUrlType;
#ifndef MBRenderQuality
#define MBRenderQuality _MBRenderQuality
#endif
#ifndef MBUrlType
#define MBUrlType _MBUrlType
#endif

#define UNPACK_NATIVE(type) ((type*)_native)
#define STRING2WCHAR(text) ((wchar_t*)[text cStringUsingEncoding:NSUTF16LittleEndianStringEncoding])
#define WCHAR2STRING(wchars) ([[[NSString alloc] initWithBytes:wchars length:cq_wcslen(wchars) * sizeof(cqWCHAR) encoding:NSUTF16LittleEndianStringEncoding] autorelease])

CGFloat MBCoordinateScale();

#endif

