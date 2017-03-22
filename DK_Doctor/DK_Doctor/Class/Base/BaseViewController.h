//
//  BaseViewController.h
//  BanggoPhone
//
//  Created by issuser on 14-6-23.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BV_Exception_Format @"在%@的子类中必须override:%@方法"
//#import "MBCurrentControl.h"
@interface BaseViewController : UIViewController
- (void)setLeftButton:(NSString*)buttonTitle titleImage:(NSString *)TitleImage action:(SEL)action;
- (void)setRightButton:(NSString*)buttonTitle titleImage:(NSString *)TitleImage action:(SEL)action withViewSize:(CGSize)viewSize;
- (void)buttonAction_goback:(id)sender;

-(void)presentWithNCV:(UIViewController*)controller;
- (void)setLeftNavigationItemWithCustomView:(UIView*)cusView;

- (void)showAlert:(NSString *)message;

//初始化UI
-(void)initUI;
//初始化数据
-(void)initData;
@end
