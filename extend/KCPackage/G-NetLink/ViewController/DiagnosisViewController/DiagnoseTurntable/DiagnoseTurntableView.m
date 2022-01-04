//
//  DiagnoseTurntableView.m
//  TurntableTest
//
//  Created by 95190 on 14-2-14.
//  Copyright (c) 2014年 sunhao. All rights reserved.
//

#import "DiagnoseTurntableView.h"
#import "SectorOfTurntableLayer.h"
#import "PointOfTurntableLayer.h"
#import "PointerOfTurntableLayer.h"
#import "ResDefine.h"

#define SectorCount 6
#define PointCount 60
#define PointerOfTurntableLayerTransformAngleInit -120

@interface DiagnoseTurntableView()
{
    NSTimer *timer;
    NSMutableArray *sectors;
    PointerOfTurntableLayer *pointerOfTurntableLayer;
    double pointerOfTurntableLayerTransformAngle;
    UIImageView *turntableImageView;
    BOOL onceTransformFlag;
}
//-(void)createSectorOfTurntableLayers;
//-(void)createPoint;
-(void)initPointerOfTurntableLayerAtAnimationStart;
-(void)onTimer:(id)sender;
-(void)animationing;
-(void)pointerOfTurntableLayerAnimationing;
@end

@implementation DiagnoseTurntableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithPoint:(CGPoint)point
{
    turntableImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"diagnose_turntable_background",Res_Image,@"")]];
    
    CGRect frame = CGRectMake(point.x-turntableImageView.bounds.size.width/2, point.y-turntableImageView.bounds.size.height/3, turntableImageView.bounds.size.width, turntableImageView.bounds.size.height);
    self = [self initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    sectors = [[NSMutableArray alloc] init];
    
    CGRect turntableImageViewFrame = turntableImageView.frame;
    turntableImageViewFrame.origin.x = self.bounds.size.width/2-turntableImageViewFrame.size.width/2;
    turntableImageViewFrame.origin.y = self.bounds.size.height/2-turntableImageViewFrame.size.height/2;
    turntableImageView.frame = turntableImageViewFrame;
    [self addSubview:turntableImageView];
    
    //[self createSectorOfTurntableLayers];
    //[self createPoint];
    [self initPointerOfTurntableLayerAtAnimationStart];
    _isDoneShow = NO;
    
//    UIImageView *scaleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kd"]];
//    CGRect scaleImageViewFrame = scaleImageView.frame;
//    scaleImageViewFrame.origin.x = self.bounds.size.width/2-scaleImageViewFrame.size.width/2;
//    scaleImageViewFrame.origin.y = self.bounds.size.height/2-scaleImageViewFrame.size.height/2;
//    scaleImageView.frame = scaleImageViewFrame;
//    [self addSubview:scaleImageView];
    
    
    return self;
}
//-(void)createSectorOfTurntableLayers
//{
//    int intervalAngleOfPosition = 360/SectorCount;
//    int transformAngle = 59;
//    double angleOfPosition = 179;
//    double radius = 75;
//    for(int n=0;n<4;n++)
//    {
//        int x0=self.bounds.size.width/2,y0=self.bounds.size.height/2;
//        
//        double x =  x0+radius*cos(angleOfPosition*M_PI/180);
//        double y =  y0+radius*sin(angleOfPosition*M_PI/180);
//        
//        SectorOfTurntableLayer *sectorOfTurntableLayer = [SectorOfTurntableLayer layer];
//        sectorOfTurntableLayer.backgroundImage = [UIImage imageNamed:@"sector"];
//        sectorOfTurntableLayer.transform = CATransform3DMakeRotation((-90+n*transformAngle)*M_PI / 180.0, 0.0f, 0.0f, 1.0f);
//        sectorOfTurntableLayer.position = CGPointMake(x, y);
//        [self.layer addSublayer:sectorOfTurntableLayer];
//        [sectors addObject:sectorOfTurntableLayer];
//        
//        angleOfPosition+=intervalAngleOfPosition;
//    }
//}
//-(void)createPoint
//{
//    int intervalAngleOfPosition = 360/PointCount;
//    double angleOfPosition = 154.8;
//    double radius = 88;
//    
//    for(int n=0;n<40;n++)
//    {
//        int x0=self.bounds.size.width/2,y0=self.bounds.size.height/2;
//        
//        double x =  x0+radius*cos(angleOfPosition*M_PI/180);
//        double y =  y0+radius*sin(angleOfPosition*M_PI/180);
//        
//        if((n+1)%5 != 0)
//        {
//            PointOfTurntableLayer *pointOfTurntableLayer = [PointOfTurntableLayer layer];
//            pointOfTurntableLayer.backgroundImage = [UIImage imageNamed:@"poi"];
//            pointOfTurntableLayer.position = CGPointMake(x, y);
//            [self.layer addSublayer:pointOfTurntableLayer];
//        }
//        
//        angleOfPosition+=intervalAngleOfPosition;
//    }
//}
-(void)initPointerOfTurntableLayerAtAnimationStart
{
    onceTransformFlag = NO;
    pointerOfTurntableLayerTransformAngle = PointerOfTurntableLayerTransformAngleInit;
    int x0=self.bounds.size.width/2,y0=self.bounds.size.height/2;

    if(pointerOfTurntableLayer == nil)
    {
        pointerOfTurntableLayer = [PointerOfTurntableLayer layer];
        [self.layer addSublayer:pointerOfTurntableLayer];
        
        UIImage *image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnose_turntable_pointer_head",Res_Image,@"")];
        
        CALayer *pointerHeadOfTurntableLayer = [CALayer layer];
        pointerHeadOfTurntableLayer.contents = (id)image.CGImage;
        CGRect pointerHeadOfTurntableLayerFrame = pointerHeadOfTurntableLayer.frame;
        pointerHeadOfTurntableLayerFrame.size.width = image.size.width;
        pointerHeadOfTurntableLayerFrame.size.height = image.size.height;
        pointerHeadOfTurntableLayer.frame = pointerHeadOfTurntableLayerFrame;
        pointerHeadOfTurntableLayer.position = CGPointMake(x0, y0);
        [self.layer addSublayer:pointerHeadOfTurntableLayer];
    }
    pointerOfTurntableLayer.transform = CATransform3DMakeRotation(pointerOfTurntableLayerTransformAngle*M_PI / 180.0, 0.0f, 0.0f, 1.0f);
    pointerOfTurntableLayer.anchorPoint = CGPointMake(0.5, 1);
    pointerOfTurntableLayer.position = CGPointMake(x0, y0);
    
}
-(void)setIsDoneShow:(BOOL)isDoneShow
{
    _isDoneShow = isDoneShow;

    if(_isDoneShow)
    {
        turntableImageView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnose_turntable_background",Res_Image,@"")];
        pointerOfTurntableLayer.transform = CATransform3DMakeRotation(0*M_PI / 180.0, 0.0f, 0.0f, 1.0f);
    }
    else
    {
        turntableImageView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnose_turntable_background",Res_Image,@"")];
        pointerOfTurntableLayer.transform = CATransform3DMakeRotation(pointerOfTurntableLayerTransformAngle*M_PI / 180.0, 0.0f, 0.0f, 1.0f);
    }
}
-(void)startAnimation
{
    [self initPointerOfTurntableLayerAtAnimationStart];
    turntableImageView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnose_turntable_background",Res_Image,@"")];
    
    if(timer == nil)
        timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}
-(void)stopAnimation
{
    if(timer!=nil)
    {
        [timer invalidate];
        timer = nil;
    }
    if(self.delegate != nil)
        [self.delegate diagnoseTurntableViewAnimationDidStop];
}
-(void)onTimer:(id)sender
{
    [self animationing];
}
-(void)animationing
{
    [self pointerOfTurntableLayerAnimationing];
}
-(void)pointerOfTurntableLayerAnimationing
{
    if(!onceTransformFlag)
    {
        if(pointerOfTurntableLayerTransformAngle<fabs(PointerOfTurntableLayerTransformAngleInit))
        {
            pointerOfTurntableLayerTransformAngle++;
            if(pointerOfTurntableLayerTransformAngle == abs(PointerOfTurntableLayerTransformAngleInit))
            {
                if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(diagnoseTurntableViewAnimationToRight)])
                    [self.delegate diagnoseTurntableViewAnimationToRight];
            }
        }
        else
            onceTransformFlag = YES;
    }
    else
    {
        turntableImageView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"diagnose_turntable_background",Res_Image,@"")];
        pointerOfTurntableLayerTransformAngle--;
        if(pointerOfTurntableLayerTransformAngle == 0)
        {
            [self stopAnimation];
            onceTransformFlag = NO;
            return;
        }
    }
    pointerOfTurntableLayer.transform = CATransform3DMakeRotation(pointerOfTurntableLayerTransformAngle*M_PI / 180.0, 0.0f, 0.0f, 1.0f);
    pointerOfTurntableLayer.anchorPoint = CGPointMake(0.5, 1);
}
-(void)dealloc
{
    [self stopAnimation];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
