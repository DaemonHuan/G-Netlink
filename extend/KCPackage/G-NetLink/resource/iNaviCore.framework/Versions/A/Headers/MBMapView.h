//
//  MBMapView.h
//  Navigation
//
//  Created by delon on 12-12-26.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBNaviCoreTypes.h"
#import "MBNativePrivate.h"
#import "MBAnnotation.h"


@class MBOverlay;
@class MBMapState;
@protocol MBMapViewDelegate;

typedef enum MBCameraSetting
{
    MBCameraSetting_worldCenter = 1,
    MBCameraSetting_scale       = 2,
    MBCameraSetting_heading     = 4,
    MBCameraSetting_elevation   = 8,
    MBCameraSetting_viewport    = 16,
    MBCameraSetting_viewShift   = 32,
    MBCameraSetting_dpiFactor   = 64,
    MBCameraSetting_zoomLevel   = 128
} MBCameraSetting;


/**
 
 地图模式，判断是正常显示模式还是导航模式。
 
 */
typedef enum MBMapMode{
    MapMode_normal = 0,
    MapMode_navigation = 1
}MBMapMode;


/**
 
 poi类型
 
 */
typedef enum MBPOIType
{
    POIType_NONE = 0,
    
    POIType_railwayStation = 0x1,
    POIType_airport = 0x2,
    POIType_dock = 0x4,
    POIType_subwayStation = 0x8,   ///< Drawn as the icon of the subway system of each city.
    
    POIType_community = 0x10,      ///< i.e. residential block
    POIType_school = 0x20,
    POIType_hospital = 0x40,
    POIType_park = 0x80,
    POIType_hotel = 0x100,
    POIType_seeingSite = 0x200,    ///< usually the historical buildings, such as each palace or gate in the Forbidden City.
    POIType_toilet = 0x400,
    
    POIType_gasStation = 0x800,
    POIType_parkingLot = 0x1000,
    POIType_trafficLight = 0x2000,
    
    /** 4 well-known country-wide banks are drawn with their own logo: ICBC, ABC, BC, and CBC; others are drawn with the RMB icon.
     Note it does NOT include the Postal Savings Bank of China.  */
    POIType_bank = 0x8000,
    POIType_chinaPost = 0x10000,   ///< China Post office, usually meaning an office of Postal Savings Bank of China too.
    
    POIType_McDonald = 0x20000,
    POIType_KFC = 0x40000,
    
    POIType_subwayExit = 0x80000,  ///< such as A, B, C, D
    
    POIType_others = 0x100000,     ///< all other kinds; will be drawn with a black dot.
    
    POIType_ALL = 0xFFFFFFFF
}MBPOIType;

/** MBMapView
 *
 *
 *      MBMapView 对象提供可嵌入的地图界面，类似于地图应用提供的界面。你直接使用这个类来显示地图信息、在应用中控制地图的
 *      内容。你可以给定一个坐标作为地图的中心，指定想要显示的范围的大小，使用自定义的信息标注地图。
 *
 *      在你初始化地图视图的时候，你需要指定地图显示的初始范围。你可以通过设置 region 属性来完成这个操作。范围是由中心点
 *      和水平与竖直距离（跨度）定义。跨度决定了在给定点的下多少地图可视，同时你可以用它设置缩放等级。指定一个大的跨度将导致
 *      用户看见一个大的地理区域对应一个低的缩放等级。指定一个小的跨度将导致用户看见一个更狭窄的地理区域对应一个高的缩放等级。
 *      
 *      除了通过编码设置跨度外， MBMapView 类支持许多标准接口用于改变地图的位置和缩放等级。特别的，地图视图支持双击和双
 *      指手势来滚动、放大和缩小地图。默认启用这些手势，但可以通过设置 scrollEnabled 和 zoomEnabled 属性来禁用手势。
 *      
 *      数据类型 MBMapPoint 、 MBMapSize 和 MBMapRect 用来指定地图上的位置和距离。你可以使用这些类型的数据来指定
 *      地图的可视范围和指定覆盖层的位置。
 *      
 *      你可以提供一个委托对象来获得地图视图运行的信息。地图视图调用你自定义委托的方法让委托知道地图状态的改变同时调整自定
 *      义标注的显示，
 *      下面的“标注地图”中将有更加详细的描述。委托的对象可以是你应用中的任何对象只要它遵从 MBMapViewDelegate 协议。参考
 *      MBMapViewDelegate 可以获得更多实现委托对象的信息。
 *
 *  标注地图
 *
 *      MBMapView类支持使用自定义的信息标注地图。因为地图可能有大量潜在的标注。地图视图区分管理标注数据的标注对象和在地图
 *      上展示这个数据的视图对象。
 *      \n标注对象可以上任何遵守 MBAnnotation 协议的对象。通常使用应用中数据模型已有的类来实现标注对象。这样你可以直接控制
 *      标注数据，而且还使它在地图视图中可用。每个标注对象包含了标注在地图的位置信息以及可以在弹出气泡中显示的描述信息。
 *      \n标注视图是一个 MBAnnotationView 类的实例，用于处理标注对象在地图中的表示。标注视图的负责用意义的方式展示标注数据。
 *      例如，地图应用使用一个大头针图标表示地图上的一个兴趣点。（Map Kit框架提供 MBPinAnnotationView 类作为应用中类似
 *      的标注）。你还可以创建的覆盖更大部分地图的标注视图。
 *      \n因为标注视图只有在屏幕内时才被需要， MBMapView 类采用了一个算法把未使用的标注视图放到队列。带有标识符的标注视图
 *      移出屏幕后将被地图视图内部的分离并放到队列。这个特征通过只让少量的标注视图保持在内存中及回收这些你有的视图的方式来提高
 *      内存的利用。同时这样还通过避免在地图滚动时创建新的视图来提高滚动的性能。
 *      \n在配置地图界面的时候，你需要立刻添加所有的标注对象。地图视图使用每个标注对象的坐标数据来决定对应的标注视图什么时候
 *      需要显示在屏幕上。当标注移进屏幕后，地图视图请求自己的委托来创建对应的标注视图。如果应用中有多种不同的标注，可以定义不
 *      同的标注视图类表示每种类型。
 *
 *  向地图中添加覆盖层
 *
 *      你可以使用覆盖层显示覆盖地图较大区域的内容。覆盖层可以是任何遵守 MBOverlay 协议的对象。覆盖层对象是一个包含了许多用
 *      于指定覆盖层形状和大小以及在地图中位置的点的数据对象。覆盖层可以表示圆形、矩形和多分割的线条，还有简单或复杂的多边形。
 *      你还可以定义自己的覆盖层来表示其它的形状。
 *      \n标注视图是一个 MBOverlayView 类的实例，用于处理覆盖层对象在地图中的显示。覆盖层视图的任务是在地图上层绘制表示覆
 *      盖层的形状。例如，一个表示公交路线的覆盖层可能的覆盖层视图绘制了路线的路径同时沿着路线带有显示公交站的图标。Map Kit
 *      框架给几种标准的覆盖层对象定义了覆盖层视图，如果有需要你可以定义别的覆盖层视图。在配置地图界面的时候，你可以在任何时候
 *      添加覆盖层对象。地图视图根据每个覆盖层的数据决定对应的覆盖层视图什么时候需要显示在屏幕上。当覆盖层移进屏幕时，地图视图
 *      请求自己的委托创建对应的覆盖层视图。
 */
@interface MBMapView : UIView
/**
 *  授权判断
 */
@property(nonatomic,readonly) MBSdkAuthError authErrorType;
/** @property   worldCenter
 *
 *  @brief  当前地图中心点经纬度坐标
 *  @note
 */
@property(nonatomic,assign) MBPoint worldCenter;

/** @property   zoomLevel
 *
 *  @brief  当前地图缩放级别
 *  @note
 */
@property(nonatomic,assign) CGFloat zoomLevel;

/** @property   scale
 *
 *  @brief  当前地图绘图标尺,会触发didChanged
 *  @note
 */
@property(nonatomic,assign) CGFloat scale;

/** @property   elevation
 *
 *  @brief  仰角角度
 *  @note   单位：度，范围：(MIN_ELEVATION, 90]<br>不同比例尺的仰角范围是不同的，但上限相同，比例尺越小，仰角范围的最小值越小
 */
@property(nonatomic,assign) CGFloat elevation;

/** @property   heading
 *
 *  @brief  地图的朝向
 *  @note   方向角，正北为0，取值范围是[0, 360)
 */
@property(nonatomic,assign) CGFloat heading;

/** @property   viewport
 *
 *  @brief  当前屏幕的相对位置偏移
 *  @note   屏幕的相对位置，相当于百分比 将中心移动至世界中心 - (ratioBelowCenter * 屏幕高度 / 2)像素的位置<br>范围：[-1.0, 1.0]
 */
@property(nonatomic,assign) CGFloat viewShift;

/**
 * 中心点偏移
 */
@property(nonatomic,assign) MBPoint centerOffset;


@property(nonatomic,assign) MBRect viewport;

/** @property   worldRect
 *
 *  @brief  标注集合
 *  @note
 */
@property(nonatomic,readonly) MBRect worldRect;

/** @property   nightMode
 *
 *  @brief  判断当前是否开启夜间模式
 *  @note   如果为true表示开启夜间模式，否则表示开启白天模式
 */
@property(nonatomic,assign) BOOL nightMode;

/** @property   annotations
 *
 *  @brief  标注集合
 *  @note
 */
@property(nonatomic,readonly) NSArray *annotations;

/** @property   overlays
 *
 *  @brief  覆盖层集合
 *  @note
 */
@property(nonatomic,readonly) NSArray *overlays;

/** @property   suspendDisplay
 *
 *  @brief  当前是否延迟显示状态
 *  @note
 */
@property(nonatomic,assign) BOOL suspendDisplay;

/** @property   delegate
 *
 *  @brief  代理
 *  @note
 */
@property(nonatomic,assign) id<MBMapViewDelegate> delegate;
/**
 *  设置地图样式：客户端将默认 map3_style_sheet.json 文件放在APP的res目录下，系统自动读取，客户端也可以根据需要更改其中配置。如：[self setStyleClass:@"night_navigation"];[self setStyleClass:@"route.weaker"];等
 */
@property(nonatomic,assign) NSString* styleClass;

/**
 *  强制绘制地图，类似UIView的setNeedsDisplay函数。
 */
- (void)drawView;

/**
 *  @brief  支持的最小比例尺
 */
+ (CGFloat)minScale;

/**
 *  @brief  支持的最大比例尺
 */
+ (CGFloat)maxScale;

/**
 *
 *  @brief  刷新数据。使用新下载的离线地图数据，而无需重新启动程序。
 *  @return 空
 *  @note
 */
- (void)reloadMapData;

/**
 *
 *  @brief  设置地图的显示方式（自动，在线，离线）。
 *  @return 空
 *  @note
 */
- (void) setMapDataMode:(MBMapDataMode)mode;

/**
 *
 *  @brief  将世界坐标转换为对应的屏幕坐标
 *  @param  position    世界坐标
 *  @return 屏幕坐标
 *  @note
 */
- (MBPoint)world2Screen:(MBPoint)pt;

/**
 *
 *  @brief  将屏幕坐标转换为对应的世界坐标
 *  @param  position    屏幕坐标
 *  @return  世界坐标
 *  @note
 */
- (MBPoint)screen2World:(MBPoint)pt;
/**
 *
 *  @brief  将世界坐标矩形转换为对应的屏幕坐标矩形
 *  @param  rc    世界坐标矩形
 *  @return 屏幕坐标矩形
 *  @note
 */
- (MBRect)worldRect2Screen:(MBRect)rc;
/**
 *
 *  @brief  将屏幕坐标矩形转换为对应的世界坐标矩形
 *  @param  rc    屏幕坐标矩形
 *  @return 世界坐标矩形
 *  @note
 */
- (MBRect)screenRect2World:(MBRect)rc;

/**
 *
 *  @brief  判断指定的点是否在地图的可见范围内
 *  @param point    判断的点
 *  @return 可见则返回YES，否则返回NO
 */
- (BOOL)isPointVisible:(MBPoint)pos;

/**
 *
 *  @brief  判断指定的矩形是否在地图的可见范围内
 *  @param  rect    欲判断的矩形
 *  @return 可见则返回YES，否则返回NO
 */
- (BOOL)isRectVisible:(MBRect)rect;

/**
 *
 *  @brief  将地图的中心和比例尺设置为合适的大小 以便能完整的现实区域的内容
 *  @param  area    需要显示的区域
 *  @return 空
 */
- (void)fitWorldArea:(MBRect)area;

/**
 *
 *  @brief  将地图的中心和比例尺设置为合适的大小 以便能完整的现实区域的内容
 *  @param  area    需要显示的区域
 *  @param  rect    指定的屏幕矩形
 *  @return 空
 */
- (void)fitWorldArea:(MBRect)area rect:(CGRect)rect;

/**
 *
 *  @brief  计算实际距离映射到屏幕中的大小
 *  @param  lenInMeter  实际的距离，单位：米
 *  @return 映射到屏幕的尺寸大小，此结果跟屏幕比例尺和DPI设置有关
 */
- (float)meter2Pixel:(CGFloat)meter;

/**
 *
 *  @brief  添加Annotation到MapRenderer对象
 *  @param  annotation  标注
 *  @return 空
 */
- (void)addAnnotation:(MBAnnotation *)annotation;

/**
 *
 *  @brief  移除Annotation
 *  @param  annotation  标注
 *  @return 空
 */
- (void)removeAnnotation:(MBAnnotation *)annotation;

/**
 *
 *  @brief  移除Annotations
 *  @param  annotations  标注集合
 *  @return 空
 */
- (void)removeAnnotations:(NSArray *)annotations;

/**
 *
 *  @brief  设置选中地图中指定的Annotation
 *  @param  annotation  待选中的Annotation标注
 *  @return 空
 */
- (void)selectAnnotation:(MBAnnotation *)annotation;

/**
 *
 *  @brief  添加Overlay到MapRenderer对象<br><font color="red">注意：调用addOverlay之后，会将Native的资源托管给{@link MapRenderer}<br>此时如果要删除相应的{@link Overlay}对象，那么应该调用{@link MapRenderer#removeOverlay(Overlay)}来清理删除对象<br>删除后的对象将不再可用，客户端需手动将对应的Java对象置空。</font>
 *  @param  overlay     层
 *  @return 空
 */
- (void)addOverlay:(MBOverlay *)overlay;

/**
 *
 *  @brief  在指定层次插入Overlay，不同层次会出现压盖关系
 *  @param  overlay     待插入的Overlay
 *  @param  index       插入位置
 *  @return 空
 */
- (void)insertOverlayAtIndex:(MBOverlay *)overlay index:(NSInteger)index;

/**
 *
 *  @brief  移除MapRenderer中的Overlay对象，释放Overlay对应的Native资源<br><font color="red">注意：此方法将释放Overlay对应的Native资源，此时Overlay已经失效，不可用，任何对其操作都将引起崩溃。</font>
 *  @param  overlay     待插入的Overlay
 *  @return 空
 */
- (void)removeOverlay:(MBOverlay *)overlay;

/**
 *
 *  @brief  移除MapRenderer中的Overlay对象，释放Overlay对应的Native资源<br><font color="red">注意：此方法将释放Overlay对应的Native资源，此时Overlay已经失效，不可用，任何对其操作都将引起崩溃。</font>
 *  @param  overlays     删除的Overlay集合
 *  @return 空
 */
- (void)removeOverlays:(NSArray *)overlays;

/**
 *
 *  @brief  将指定的Overlay提到所有Overlay最顶端
 *  @param  overlay     待操作Overlay
 *  @return 空
 */
- (void)bringOverlayToTop:(MBOverlay *)overlay;

/**
 *
 *  @brief  将指定的Overlay放入所有Overlay最下方
 *  @param  overlay     待操作Overlay
 *  @return 空
 */
- (void)sendOverlayToBack:(MBOverlay *)overlay;

/**
 *
 *  @brief  交换两个Overlay的层次顺序
 *  @param  overlayL
 *  @param  overlayR
 *  @return 空
 */
- (void)exchangeOverylayIndices:(MBOverlay *)l r:(MBOverlay *)r;
/**
 *
 * @brief 句柄
 */
@property(nonatomic,readonly) id native;

/**
 *
 *  @brief  设置地图缩放级别
 *  @param  zoomLevel   缩放级别，取值范围[1.0, 14.0]
 *  @param  animated    是否使用动画效果
 *  @return 空
 */
- (void)setZoomLevel:(CGFloat)zoomLevel animated:(BOOL)animated;

/**
 *
 *  @brief  设置地图比例
 *  @param  scale   缩放比例
 *  @param  animated    是否使用动画效果
 *  @return 空
 */
- (void)setScale:(CGFloat)scale animated:(BOOL)animated;

/**
 *
 *  @brief  设置地图的朝向
 *  @param  heading     方向角，正北为0，取值范围是[0, 360)
 *  @param  animated    是否使用动画效果
 *  @return 空
 */
- (void)setHeading:(CGFloat)heading animated:(BOOL)animated;
/**
 *  开始动画
 */
- (void)beginAnimations;
/**
 *  取消动画
 */
-(void)cancelAnimations;
/**
 *  提交动画
 *
 *  @param duration 秒数
 *  @param type     动画类型
 */
-(void)commitAnimations:(int)duration type:(MBAnimationType)type;
/**
 *  连续动画
 *
 *  @param toZoomIn YES，连续ZoomIn
 */
-(void)startZoom:(BOOL)toZoomIn;
/**
 *  结束连续动画
 */
-(void)endZoom;
/**
 *  是否在动画中
 *
 *  @return YES正在动画，NO不在动画。
 */
-(BOOL)isInAnimation;
/**
 *
 *  @brief  设置地图中心点位置
 *  @param  center      欲设置的中心点
 *  @param  animated    是否使用动画效果
 *  @return 空
 */
- (void)setWorldCenter:(MBPoint)worldCenter animated:(BOOL)animated;
/**
 *
 *  @brief  设置X和Y方向偏移比例,默认为0
 */
- (void)setViewShiftX:(CGFloat)rx y:(CGFloat)ry;

/**
 * 清除绘制对象
 */
+ (void)cleanup;
/**
 *  建议在程序切到后台或者接收到操作系统内存紧缺的信号 时使用此函数精简内存使用
 */
-(void)compactCache;
/**
 *  建议当系统内存资源紧缺时使用此函数清理释放内存
 */
-(void)clearCache;
/**
 *  设置地图渲染时是否清屏，默认：清屏
 */
@property (nonatomic,assign) BOOL enableBackground;
/**
 *  开启/关闭地图底图
 */
@property (nonatomic,assign) BOOL enableBasicMap;
/** @property   enableBuilding
 *
 *  @brief  是否显示建筑，默认true值
 *  @note
 */
@property(nonatomic,assign) BOOL enableBuilding;
/**
 *  是否切换到全景图模式。 默认是：false
 */
@property (nonatomic,assign) BOOL enablePanoramaMode;
/** @property   enableTmc
 *
 *  @brief  是否显示TMC，默认不显示
 *  @note   如果为YES表示打开TMC，否则为关闭TMC
 */
@property(nonatomic,assign) BOOL enableTmc;
/** @property   SatelliteMap
 *
 *  @brief  是否打开卫星图，默认false
 *  @note   如果为true表示打开卫星图，否则为关闭卫星图
 */
@property(nonatomic,assign) BOOL satelliteMap;
/**
 *  获取屏幕DPI大小
 */
@property(nonatomic,assign) float dpiFactor;
/**
 *  获取当前渲染地图的质量
 */
@property(nonatomic,assign) MBRenderQuality renderQuality;
/**
 *  获取当前地图状态，包括摄像机状态，用于动态恢复地图状态
 */
@property(nonatomic,retain) MBMapState* mapState;
/**
 *  获取缩放等级范围
 */
@property(nonatomic,readonly) NSRange zoomLevelRange;
/**
 *  当前实时交通(TMC)数据刷新时间, 单位: ms。也就是如果要设置为10秒钟刷新，那么应该是10 * 1000。同理两分钟刷新就是2 * 60 * 1000
 */
@property(nonatomic,assign) int tmcRefreshInterval;
/**
 *  缩放全景图
 *
 *  @param byTimes 如果此值大于1，表示放大
 */
-(void)zoomInPanorama:(float)byTimes;
/**
 *  旋转全景图。画图时将先绕屏幕y轴旋转、然后绕屏幕旋转。旋转角度的符号与旋转轴的方向符合右手法则。
 *
 *  @param x x轴
 *  @param y y轴
 */
-(void)rotatePanoramaByAngleAroundX:(int)x Y:(int)y;
/**
 *  设置当前全景图地点
 *
 *  @param cityCode     城市ID
 *  @param siteId       请求URL中的图片Id，类似"000289-0-201110200100280028"
 *  @param face1Heading 第一个面的位于观察者的哪个方向，正北是0，正西是90，正南是180，正东是270。
 */
-(void)setPanoramaSite:(NSString*)cityCode siteId:(NSString*)siteId face1Heading:(int) face1Heading;
/**
 *  设置数据URL前缀，主要用于请求在线数据
 *
 *  @param type url类型
 *  @param url  url
 */
-(void)setDataUrlPrefix:(MBUrlType)type urlPrefix:(NSString*)url;
/**
 *  屏幕截图功能
 *
 *  @return UIImage对象。
 */
-(UIImage*)screenshot;

@end


/** @protocol MBMapViewDelegate
 *
 *  @brief 地图代理类
 *
 */
@protocol MBMapViewDelegate <NSObject>

@optional

/**
 *
 *  @brief  被选中时触发的回调
 *  @param  mapView  当前地图
 *  @param  annot    当前被选中的标注
 *  @return 空
 */
-(void)mbMapView:(MBMapView *)mapView onAnnotationSelected:(MBAnnotation *)annot;

/**
 *
 *  @brief  取消被选中时触发的回调
 *  @param  mapView  当前地图
 *  @param  annot    当前取消选中状态的标注
 *  @return 空
 */
-(void)mbMapView:(MBMapView *)mapView onAnnotationDeselected:(MBAnnotation *)annot;

/**
 *
 *  @brief  点击{@link Annotation}时触发的回调
 *  @param  mapView  当前地图
 *  @param  annot    被点击的{@link Annotation}
 *  @param  area     被点击的区域{@link Annotation.Area}
 *  @return 空
 */
-(void)mbMapView:(MBMapView *)mapView onAnnotationClicked:(MBAnnotation *)annot area:(MBAnnotationArea)area;

/**
 *
 *  @brief  选中POI时触发的回调
 *  @param  mapView     当前地图
 *  @param  name        POI名称
 *  @param  pos         POI所在位置坐标
 *  @return 空
 */
-(void)mbMapView:(MBMapView *)mapView onPoiSelected:(NSString *)name pos:(MBPoint)pos;

/**
 *
 *  @brief  反选POI时触发的回调
 *  @param  mapView     当前地图
 *  @param  name        POI名称
 *  @param  pos         POI所在位置坐标
 *  @return 空
 */
-(void)mbMapView:(MBMapView *)mapView onPoiDeselected:(NSString *)name pos:(MBPoint)pos;

/**
 *
 *  @brief  相机状态发生改变时触发的回调
 *  @param  mapView     当前地图
 *  @param  changeType  相机参数改变类型{@link CameraSetting}
 *  @return 空
 */
- (void)mbMapView:(MBMapView *)mapView didChanged:(MBCameraSetting)cameraSetting;

/**
 *
 *  @brief  绘制地图完成
 *  @param  mapView 当前地图
 *  @return 空
 */
- (void)mbMapViewDrawFinished:(MBMapView *)mapView;

/**
 *
 *  @brief  点击
 *  @param  mapView     当前地图
 *  @param  tapCount    点击的次数
 *  @param  pos         当前地图
 *  @return 空
 */
- (void)mbMapView:(MBMapView *)mapView onTapped:(NSInteger)tapCount pos:(MBPoint)pos;

/**
 *
 *  @brief  长按
 *  @param  mapView 当前地图
 *  @param  pos     长按地图上的坐标
 *  @return 空
 */
- (void)mbMapViewOnLongPress:(MBMapView *)mapView pos:(MBPoint)pos;

/**
 *
 *  @brief  开启手势
 *  @param  mapView 当前地图
 *  @param  point   当前手势操作的坐标
 *  @return 空
 */
- (BOOL)mbMapViewEnableGesture:(MBMapView *)mapView point:(CGPoint)point;
/**
 *
 *  @brief  接触地图是触发
 *  @param  mapView 当前地图
 *  @return 空  
 
 这个是谁加的？？？？？？？？？？？？？？？？？
 */
- (void)mbMapViewDidTouched:(MBMapView *)mapView;

/**
 *  @brief  使用手势旋转地图时触发
 *  @param  mapView 当前地图
 *  @return 空
 */
- (void)mbMapViewOnRotate:(MBMapView *)mapView;

@end
