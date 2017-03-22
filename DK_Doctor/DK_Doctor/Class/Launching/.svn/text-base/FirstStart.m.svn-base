//
//  FirstStart.m
//  donghua
//
//  Created by Samuel on 14-8-7.
//  Copyright (c) 2014年 metersbonwe. All rights reserved.
//

#import "FirstStart.h"
#import "UIColor+BGHexColor.h"
#import "UIView+YGJFrame.h"
#import "MyPageControl.h"


#define SCREEN_HIGTH [[UIScreen mainScreen]bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define PAGE_NUM 2 //引导页的页数
@implementation FirstStart
{
    MyPageControl *tapes;
    BOOL isRemoveing;
}
+ (FirstStart*)shareFirstStart
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    FirstStart *lsAnimation = [[FirstStart alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGTH)];
    return lsAnimation;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIScrollView *scrolles = [[UIScrollView alloc]initWithFrame:frame];
        scrolles.contentSize=CGSizeMake(SCREEN_WIDTH * PAGE_NUM, SCREEN_HIGTH);
        scrolles.pagingEnabled=YES;
        scrolles.showsHorizontalScrollIndicator = NO;
        scrolles.delegate = self;
        scrolles.bounces = NO;
        for (int i=0; i < PAGE_NUM; i++)
        {
            
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HIGTH)];
            
            UIButton *but = [UIButton buttonWithType:0];
            but.frame = CGRectMake(SCREEN_WIDTH*i+(SCREEN_WIDTH/2-58), SCREEN_HIGTH - 95, 128, 78);
            [but addTarget:self action:@selector(disimissSelfes) forControlEvents:UIControlEventTouchDown];
            [but setImage:[UIImage imageNamed:@"guide_enter"] forState:UIControlStateNormal];
            
            if (!tapes)
            {
               // tapes = [[MyPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HIGTH-30, SCREEN_WIDTH, 30)];
                tapes = [[MyPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HIGTH-30, SCREEN_WIDTH, 30) withPointSize:CGSizeMake(24, 24) PointCornerRadius:12 Spacing:10];
                
                tapes.pageIndicatorTintColor = [UIColor colorWithHex:0xD8D8D8 alpha:0.3];
                tapes.currentPageIndicatorTintColor = NavitionBarColor;
                tapes.enabled = NO;
                tapes.numberOfPages  = PAGE_NUM;
                tapes.currentPage = 0;
                tapes.backgroundColor = [UIColor clearColor];
            }
           
            
            if (PAGE_NUM == 1) {
                tapes.hidden = YES;
            }
            
            
            
            
            if (SCREEN_HIGTH<=480)
            {
                [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"DT_guide4s_%zd", i + 1]]];
                tapes.top = SCREEN_HIGTH - 24;
                but.top = tapes.top - 14 - but.height;
                
            }
            else if(SCREEN_HIGTH>480 && SCREEN_HIGTH<=568)
            {
                [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"DT_guide5s_%zd", i + 1]]];
                tapes.top = SCREEN_HIGTH - 35;
                but.top = tapes.top - 20 - but.height;
                
            }
            else if(SCREEN_HIGTH>568 && SCREEN_HIGTH<=667)
            {
                [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"DT_guide6_%zd", i + 1]]];
                tapes.top = SCREEN_HIGTH - 40;
                but.top = tapes.top - 30 - but.height;
                
            }
            else
            {
                [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"DT_guide6p_%zd", i + 1]]];
                tapes.top = SCREEN_HIGTH - 80;
                but.top = tapes.top - 50 - but.height;
                
                
                
            }
            
            
            [img setContentMode:UIViewContentModeScaleAspectFill];
            [img setClipsToBounds:YES];
            [scrolles addSubview:img];
            [self addSubview:scrolles];
            
            if (i == PAGE_NUM - 1) {
                
                [scrolles addSubview:but];
            }
            
            [self addSubview:tapes];
        }
    }
    return self;
}


- (void)disimissSelfes
{
    if (isRemoveing) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:.5 animations:^
    {
        self.alpha = 0;
    } completion:^(BOOL finished)
     {
     [weakSelf removeFromSuperview];
     }];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int counts= scrollView.contentOffset.x/SCREEN_WIDTH;
    tapes.currentPage = counts;
    if (tapes.currentPage == PAGE_NUM - 1) {
        scrollView.bounces = YES;
//        tapes.hidden = YES;
    }else {
        scrollView.bounces = NO;
        tapes.hidden = NO;
    }
    
   
    DKLog(@"****************");
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (tapes.currentPage == PAGE_NUM - 1) {
        scrollView.bounces = YES;
        
       
    }else {
        scrollView.bounces = NO;
    }
    DKLog(@"%f",scrollView.contentOffset.x);
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.x > SCREEN_WIDTH * (PAGE_NUM - 1) + 50) {
        [self disimissSelfesLeft];
        //            isRemoveing = YES;
    }
}

- (void)disimissSelfesLeft
{
    if (isRemoveing) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:.5 animations:^
     {
         weakSelf.frame = CGRectMake(0-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HIGTH);
     } completion:^(BOOL finished)
     {
         [weakSelf removeFromSuperview];
     }];
    
}

@end
