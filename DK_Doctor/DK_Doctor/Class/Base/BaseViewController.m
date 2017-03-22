//
//  BaseViewController.m
//  BanggoPhone
//
//  Created by issuser on 14-6-23.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import "BaseViewController.h"
#import "NSString+RTSizeWithFont.h"
#import "UIColor+BGHexColor.h"

#define QDCOMMONING_NAVI @"bg-top-40x88.png"
#define QDCOMMONING_NAVI_70 @"bg-top-40x128.png"

//字体
#define TABLECELLFONT [UIFont systemFontOfSize:12]//页面主字体
#define TABLECELLSMALLFONT [UIFont systemFontOfSize:10]//页面二级字体
#define NAVHEADFONT  [UIFont boldSystemFontOfSize:17]//标题字体
#define BUTTONBIGFONT  [UIFont boldSystemFontOfSize:15]//按钮大号字体
#define BUTTONSMALLRFONT  [UIFont boldSystemFontOfSize:12]//按钮小号字体

@interface BaseViewController ()

@end
@interface UINavigationBar (UINavigationBarCategory)
- (void)setBackgroundImage:(UIImage*)image;
@end

//CustomNavigationBar.m
@implementation UINavigationBar (UINavigationBarImage)
- (void)drawRect:(CGRect)rect {
    
   // UIImage *image = [self buttonImageFromColor:[UIColor colorWithHexString:@"#fb557b"]];
//    UIImage* img = nil;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        img = [UIImage imageNamed:QDCOMMONING_NAVI_70];
//    }else{
//        img = [UIImage imageNamed:QDCOMMONING_NAVI];
//    }
//    
//	UIImage *image = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
//	assert(image!=nil);
////    UIImage *image = [self buttonImageFromColor:[UIColor colorWithHexString:@"#fb557b"] Rect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
//	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//返回
- (void)buttonAction_goback:(id)sender{
    [self.view endEditing:YES];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    if (self.parentViewController.childViewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    if (self.parentViewController.childViewControllers.count>1) {
//        [self SetLeftButton:nil Image:nil];
        [self setLeftButton:@"" titleImage:@"back" action:@selector(buttonAction_goback:)];
    }
    else{
        if (self.presentingViewController) {
            [self setLeftButton:@"" titleImage:@"" action:@selector(buttonAction_goback:)];
        }
    }
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self initUI];
    [self initData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    //   MBCurrentControl *currentControl= [MBCurrentControl CurrentView];
    //    currentControl.view=self.view;
    [super viewWillAppear:animated];
//    UIImage* image = nil;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        image = [UIImage imageNamed:QDCOMMONING_NAVI_70];
//    }else{
//        image = [UIImage imageNamed:QDCOMMONING_NAVI];
//    }
//    image = [image stretchableImageWithLeftCapWidth:image.size.width/2.0f topCapHeight:0];
    
//    UIImage *image = [self buttonImageFromColor:[UIColor colorWithHexString:@"#fb557b"] Rect:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    UIImage *image = [self buttonImageFromColor:NavitionBarColor Rect:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];

    //判断设备的版本
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        //ios5 新特性
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
//        [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
        
    }
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - back button
/****************************************    zhu      ************************************/
//自定义natigationitem标题
-(void)setTitle:(NSString *)title{
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    customLab.backgroundColor=[UIColor clearColor];
    [customLab setTextColor:[UIColor whiteColor]];
    customLab.textAlignment=NSTextAlignmentCenter;
    customLab.numberOfLines = 2;
    [customLab setText:title];
    customLab.font = NAVHEADFONT;
    customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    
    self.navigationItem.titleView=customLab;
}

#pragma mark - nav buttonitem
- (void)setLeftButton:(NSString*)buttonTitle titleImage:(NSString *)TitleImage action:(SEL)action
{
    CGSize size = [buttonTitle rtSizeWithFont:BUTTONBIGFONT];
	UIImage* image = [UIImage imageNamed:TitleImage];
	UIImage* highlightedImage = [UIImage imageNamed:TitleImage];
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.titleLabel.font = BUTTONBIGFONT;
	[button setFrame:CGRectMake(0, 0, MAX((size.width),30), MAX(30,size.height))];
//	[button setBackgroundImage:[highlightedImage stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
//	[button setBackgroundImage:[image stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
    [button setImage:[image stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
    [button setImage:[highlightedImage stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[button setTitle:buttonTitle forState:UIControlStateNormal];
	[button setTitle:buttonTitle forState:UIControlStateHighlighted];
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] > 7.0) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = 0;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
    }
    else{
        self.navigationItem.leftBarButtonItem=backItem;
    }
}

- (void)setRightButton:(NSString*)buttonTitle titleImage:(NSString *)TitleImage action:(SEL)action withViewSize:(CGSize)viewSize
{
    CGSize size = [buttonTitle rtSizeWithFont:BUTTONBIGFONT];
	UIImage* image = [UIImage imageNamed:TitleImage];
	UIImage* highlightedImage = [UIImage imageNamed:TitleImage];
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.titleLabel.font = BUTTONBIGFONT;
    if(viewSize.width > 0 || viewSize.height > 0) {
        [button setFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    }else {
        [button setFrame:CGRectMake(0, 0, MAX((size.width+30),40), MAX(30,size.height))];
    }
    
    [button setImage:[image stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
    [button setImage:[highlightedImage stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
    
	[button setTitle:buttonTitle forState:UIControlStateNormal];
	[button setTitle:buttonTitle forState:UIControlStateHighlighted];
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] > 7.0) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -5;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, backItem];
    }
    else{
        self.navigationItem.rightBarButtonItem=backItem;
    }
//	[self setRightNavigationItemWithCustomView:button];
}

- (void)setLeftNavigationItemWithCustomView:(UIView*)cusView
{
    UIBarButtonItem *m_buttonItem = [[UIBarButtonItem alloc] initWithCustomView:cusView];
    self.navigationItem.leftBarButtonItem = m_buttonItem;
}

- (void)setRightNavigationItemWithCustomView:(UIView*)cusView
{
    UIBarButtonItem *m_buttonItem = [[UIBarButtonItem alloc] initWithCustomView:cusView];
    self.navigationItem.rightBarButtonItem = m_buttonItem;
}


-(void)presentWithNCV:(UIViewController*)controller{
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    if (self.navigationController) {
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else{
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (UIImage *)buttonImageFromColor:(UIColor *)color Rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

/**
 初始化UI
 */
-(void)initUI
{
    DKLog(@"init UI");
}

/**
 初始化数据
 */
-(void)initData
{
    DKLog(@"init Data");
}
@end
