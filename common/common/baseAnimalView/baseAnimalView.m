//
//  baseAnimalView.m
//  i1-app
//
//  Created by sam on 15/9/22.
//  Copyright © 2015年 BG. All rights reserved.
//

#import "baseAnimalView.h"
#import "UIView+YGJFrame.h"



@interface baseAnimalView()<UIGestureRecognizerDelegate>

@property(assign,nonatomic)animalType type;

@property(strong,nonatomic)UIView *backView;

@property(strong,nonatomic)UIButton *backGroundBtn;

@end

@implementation baseAnimalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)showView:(BOOL)animal animalType:(animalType)type complete:(Complete)complete
{
    self.type = type;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!self.backView)
    {
        self.backView = [[UIView alloc] initWithFrame:window.bounds];
        
        if (self.type != CenterType)
        {
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            tap.delegate = self;
            
            [self.backView addGestureRecognizer:tap];
        }
    }
    
    if (self.type == CenterType)
    {
        if (animal)
        {
            self.center = self.backView.center;
            
         //   self.bottom = self.bottom-140;
            
            self.backView.hidden = NO;
            
            self.backView.backgroundColor = [UIColor blackColor];
            
            self.backView.backgroundColor = [UIColor clearColor];
            
            [self.backView addSubview:self];
            [window addSubview:self.backView];
            
            self.alpha = 0.0;
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
                self.alpha = 1.0;
            } completion:^(BOOL finished) {
                
                if (complete)
                {
                    complete();
                }
            }];
        }
        else
        {
            self.center = self.backView.center;
            
            self.backView.hidden = NO;
            
            self.backView.backgroundColor = [UIColor blackColor];
            
            self.backView.alpha = 0.7;
            [self.backView addSubview:self];
            [window addSubview:self.backView];
            
            if (complete)
            {
                complete();
            }
        }
    }
    else
    {
        CGPoint startPoint;
        CGPoint endPoint;
        
        //计算初始和结束位置
        CGRect rect = window.bounds;
        switch (self.type)
        {
            case TopType:
                startPoint = CGPointMake(0, 0-self.frame.origin.y);
                endPoint = CGPointMake(0, 0);
                break;
            case BottomType:
                startPoint = CGPointMake(0, self.backView.bounds.size.height);
                endPoint = CGPointMake(0, rect.size.height-self.frame.size.height);
                break;
            case LeftType:
                startPoint = CGPointMake(0-self.frame.size.width,0);
                endPoint = CGPointMake(0,0);
                break;
            case RightType:
                startPoint = CGPointMake(self.backView.frame.size.width,0);
                endPoint = CGPointMake(rect.size.width-self.frame.size.width,0);
                break;
            default:
                startPoint = CGPointMake(0-self.frame.origin.x, 0-self.frame.origin.y);
                endPoint = CGPointMake(0, 0);
                break;
        }
        
        
        
        
        
        if (animal)
        {
            [self setFrame:CGRectMake(startPoint.x, startPoint.y, self.frame.size.width, self.frame.size.height)];
            
            self.backView.hidden = NO;
            
            self.backView.backgroundColor = [UIColor blackColor];
            
            self.backView.backgroundColor = [UIColor clearColor];
            
            [self.backView addSubview:self];
            [window addSubview:self.backView];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
                self.frame = CGRectMake(endPoint.x, endPoint.y, self.frame.size.width, self.frame.size.height);
            } completion:^(BOOL finished) {
                
                if (complete)
                {
                    complete();
                }
                
                
            }];
        }
        else
        {
            [self setFrame:CGRectMake(endPoint.x, endPoint.y, self.frame.size.width, self.frame.size.height)];
            
            self.backView.hidden = NO;
            
            self.backView.backgroundColor = [UIColor blackColor];
            
            self.backView.alpha = 0.7;
            [self.backView addSubview:self];
            [window addSubview:self.backView];
            
            if (complete)
            {
                complete();
            }
        }
    }
}

-(void)dismissView:(BOOL)animal complete:(Complete)complete
{
    if (self.type == CenterType)
    {
        if (animal)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                
                [self.backView removeFromSuperview];
                [self removeFromSuperview];
                
                if (complete)
                {
                    complete();
                }
                
            }];
        }
        else
        {
            self.backView.hidden = YES;
            [self.backView removeFromSuperview];
            [self removeFromSuperview];
            
            if (complete)
            {
                complete();
            }
        }
        
        return;
    }
    
    
    if (animal)
    {
        CGPoint startPoint;
        switch (self.type)
        {
            case TopType:
                startPoint = CGPointMake(0, 0-self.backView.frame.size.height);
                
                break;
            case BottomType:
                startPoint = CGPointMake(0, self.backView.frame.size.height);
                
                break;
            case LeftType:
                startPoint = CGPointMake(0-self.frame.size.width,0);
               
                break;
            case RightType:
                startPoint = CGPointMake(self.backView.frame.size.width,0);
                
                break;
            default:
                startPoint = CGPointMake(0,0-self.backView.frame.size.height);
                break;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
            [self setFrame:CGRectMake(startPoint.x, startPoint.y, self.frame.size.width, self.frame.size.height)];
            
        } completion:^(BOOL finished) {
            
            [self.backView removeFromSuperview];
            [self removeFromSuperview];
            
            if (complete)
            {
                complete();
            }
            
        }];

    }
    else
    {
        self.backView.hidden = YES;
        [self.backView removeFromSuperview];
        [self removeFromSuperview];
        
        if (complete)
        {
            complete();
        }
        
    }
}
-(void)showInView:(UIView *)view animal:(BOOL)animal animalType:(animalType)type complete:(Complete)complete
{
    self.type = type;
    
    UIView *window = view;
    if (!self.backView)
    {
        self.backView = [[UIView alloc] initWithFrame:window.bounds];
        
        self.backGroundBtn = [[UIButton alloc] initWithFrame:self.backView.bounds];
        self.backGroundBtn.backgroundColor = [UIColor clearColor];
        [self.backGroundBtn addTarget:self action:@selector(clickBackGroundButton) forControlEvents:UIControlEventTouchDown];
        
        [self.backView addSubview:self.backGroundBtn];
        
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//        
//        [self.backView addGestureRecognizer:tap];
    }
    
    self.backGroundBtn.hidden = NO;
    
    CGPoint startPoint;
    CGPoint endPoint;
    
    //计算初始和结束位置
    CGRect rect = view.bounds;
    switch (self.type)
    {
        case TopType:
            startPoint = CGPointMake(0, 0-self.frame.origin.y);
            endPoint = CGPointMake(0, 0);
            break;
        case BottomType:
            startPoint = CGPointMake(0, self.backView.bounds.size.height);
            endPoint = CGPointMake(0, rect.size.height-self.frame.size.height);
            break;
        case LeftType:
            startPoint = CGPointMake(0-self.frame.size.width,0);
            endPoint = CGPointMake(0,0);
            break;
        case RightType:
            startPoint = CGPointMake(self.backView.frame.size.width,0);
            endPoint = CGPointMake(rect.size.width-self.frame.size.width,0);
            break;
        default:
            startPoint = CGPointMake(0-self.frame.origin.x, 0-self.frame.origin.y);
            endPoint = CGPointMake(0, 0);
            break;
    }
    
    
    if (animal)
    {
        [self setFrame:CGRectMake(startPoint.x, startPoint.y, self.frame.size.width, self.frame.size.height)];
        
        self.backView.hidden = NO;
        
        
        
        self.backView.backgroundColor = [UIColor clearColor];
        
        [self.backView addSubview:self];
        [window addSubview:self.backView];
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            self.frame = CGRectMake(endPoint.x, endPoint.y, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            
            if (complete)
            {
                 complete();
            }
           
        }];
    }
    else
    {
        [self setFrame:CGRectMake(endPoint.x, endPoint.y, self.frame.size.width, self.frame.size.height)];
        
        self.backView.hidden = NO;
        
        self.backView.backgroundColor = [UIColor blackColor];
        
        self.backView.alpha = 0.7;
        [self.backView addSubview:self];
        [window addSubview:self.backView];
        
        if (complete)
        {
            complete();
        }
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        if (![touch.view isEqual:self.backView])
        {
            return NO;
        }
    }
    
    return YES;
}
-(void)tap:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point  = [tapGesture locationInView:self.backView];
    
    if (!CGRectContainsPoint(self.frame, point))
    {
        [self dismissView:YES complete:nil];
    }
}
-(void)clickBackGroundButton
{
    [self dismissView:YES complete:^{
        if (self.backGroundBtn)
        {
            self.backGroundBtn.hidden = YES;
        }
    }];
}

@end
