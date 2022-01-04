//
//  UserWelcomeView.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-5-5.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserWelcomeView.h"
@implementation UserWelcomeView
{
    NSMutableArray * _array;
    int _currentPageIndex;
//    UIScrollView * scrollView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    _customTitleBar.hidden=YES;
    _array=[[NSMutableArray alloc]init];
    _currentPageIndex = 0;
     _scrollerView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollerView.bounces = NO;
    _scrollerView.pagingEnabled = YES;
    _scrollerView.delegate = self;
      
    _scrollerView.userInteractionEnabled = YES;
    _scrollerView.showsHorizontalScrollIndicator = NO;
        _scrollerView.backgroundColor=[UIColor blackColor];
    [self addSubview:_scrollerView];
    // 初始化 数组 并添加四张图片
    _array = [[NSMutableArray alloc] init];
    [_array addObject:[UIImage imageNamed:NSLocalizedStringFromTable(@"guide1", Res_Image, @"")]];
    [_array addObject:[UIImage imageNamed:NSLocalizedStringFromTable(@"guide2", Res_Image, @"")]];
    [_array addObject:[UIImage imageNamed:NSLocalizedStringFromTable(@"guide3", Res_Image, @"")]];
    [_array addObject:[UIImage imageNamed:NSLocalizedStringFromTable(@"guide4", Res_Image, @"")]];

    // 创建四个图片 imageview
        UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[_array objectAtIndex:0]];
        imageView1.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [imageView1 addSubview:[self getSelectedImagePage:0]];
        [_scrollerView addSubview:imageView1];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[_array objectAtIndex:1]];
        imageView2.frame = CGRectMake(self.frame.size.width * 1.0f, 0, self.frame.size.width, self.frame.size.height);
        [imageView2 addSubview:[self getSelectedImagePage:1]];
        [_scrollerView addSubview:imageView2];
        
        UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[_array objectAtIndex:2]];
        imageView3.frame = CGRectMake(self.frame.size.width * 2.0f, 0, self.frame.size.width, self.frame.size.height);
        [imageView3 addSubview:[self getSelectedImagePage:2]];
        [_scrollerView addSubview:imageView3];
        
        UIImageView *imageView4 = [[UIImageView alloc] initWithImage:[_array objectAtIndex:3]];
        imageView4.frame = CGRectMake(self.frame.size.width * 3.0f, 0, self.frame.size.width, self.frame.size.height);
        UIImageView* img4=[self getSelectedImagePage:3];
        [imageView4 addSubview:img4];
        UIImage * home_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"guide_button", Res_Image, @"")];
        
        UIButton * home=[[UIButton alloc]initWithFrame:CGRectMake((self.frame.size.width-home_img.size.width)/2, img4.frame.origin.y-home_img.size.height*2, home_img.size.width, home_img.size.height)];
        [home setImage:home_img forState:UIControlStateNormal];
        [home addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
        imageView4.userInteractionEnabled=YES;
        [imageView4 addSubview:home];
        _scrollerView.userInteractionEnabled=YES;
        [_scrollerView addSubview:imageView4];
        [_scrollerView setContentSize:CGSizeMake(self.frame.size.width * 4.0f, self.frame.size.height)];
        [_scrollerView setContentOffset:CGPointMake(0, 0)];
        [_scrollerView scrollRectToVisible:CGRectMake(0,0,self.frame.size.width, self.frame.size.height) animated:NO];
}
    return self;
}
-(void)goHome{
    [self.delegate userWelcomeViewDelegateGoHome];
}
-(UIImageView*)getSelectedImagePage:(int)num{
    
    UIImageView * imageView=[self GetAllViews];
 
    switch (num) {
        case 0:
        {
            UIImageView * view=(UIImageView*)[imageView viewWithTag:1001];
            view.image=[UIImage imageNamed:NSLocalizedStringFromTable(@"guide_selected", Res_Image, @"")];
            [imageView addSubview:view];
       }
            break;
        case 1:
        {
            UIImageView * view=(UIImageView*)[imageView viewWithTag:1002];
            view.image=[UIImage imageNamed:NSLocalizedStringFromTable(@"guide_selected", Res_Image, @"")];
            [imageView addSubview:view];
        }
            break;
        case 2:
        {
            UIImageView * view=(UIImageView*)[imageView viewWithTag:1003];
            view.image=[UIImage imageNamed:NSLocalizedStringFromTable(@"guide_selected", Res_Image, @"")];
            [imageView addSubview:view];
        }
            break;
        case 3:
        {
            UIImageView * view=(UIImageView*)[imageView viewWithTag:1004];
            view.image=[UIImage imageNamed:NSLocalizedStringFromTable(@"guide_selected", Res_Image, @"")];
            [imageView addSubview:view];
        }
            break;
            
            
        default:
            break;
    }
    



    return imageView;
}

-(UIImageView*)GetAllViews{
    UIImage* selected_img=[UIImage imageNamed:NSLocalizedStringFromTable(@"guide_not_selected", Res_Image, @"")];
    UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-selected_img.size.height*3, self.frame.size.width, selected_img.size.height)];
UIImageView * img1=[[UIImageView alloc]initWithFrame:CGRectMake((imgView.frame.size.width-200)/5+100, 0, selected_img.size.width, selected_img.size.height)];
img1.image=selected_img;
UIImageView * img2=[[UIImageView alloc]initWithFrame:CGRectMake((imgView.frame.size.width-200)/5*2+100, 0, selected_img.size.width,selected_img.size.height)];
img2.image=selected_img;
UIImageView * img3=[[UIImageView alloc]initWithFrame:CGRectMake((imgView.frame.size.width-200)/5*3+100, 0, selected_img.size.width,selected_img.size.height)];
img3.image=selected_img;
UIImageView * img4=[[UIImageView alloc]initWithFrame:CGRectMake((imgView.frame.size.width-200)/5*4+100, 0, selected_img.size.width,selected_img.size.height)];
img4.image=selected_img;
    img1.tag=1001;
    img2.tag=1002;
    img3.tag=1003;
    img4.tag=1004;
[imgView addSubview:img1];
[imgView addSubview:img2];
[imgView addSubview:img3];
[imgView addSubview:img4];
//    imgView.backgroundColor=[UIColor redColor];
    return imgView;
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
