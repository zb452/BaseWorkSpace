//
//  ViewController.m
//  Yiguanjia_Paitent
//
//  Created by 张斌 on 16/8/5.
//  Copyright © 2016年 张斌. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "MyViewController.h"

@interface ViewController ()<CustomTabbarViewControllerDelegate,UIAlertViewDelegate>


@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initWithRootViewController];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [DefaultNotificationCenter removeObserver:self];
}



- (void)initWithRootViewController
{
    self.m_delegate = self;
    HomeViewController* controller_1 = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    
    MyViewController* controller_4 = [[MyViewController alloc]initWithNibName:@"MyViewController" bundle:nil];

    
    UINavigationController* _nav1 = [[UINavigationController alloc]initWithRootViewController:controller_1];
    UINavigationController* _nav2 = [[UINavigationController alloc]initWithRootViewController:controller_4];


    
    
    self.viewControllers = [NSArray arrayWithObjects:
                            _nav1,
                            _nav2,
                            nil];
    
    self.tabHeight = 49;

    [self setBackgroundImage:[UIImage imageNamed:@"tabbar.png"]];
    self.view.backgroundColor = [UIColor colorWithRed:31/255. green:31/255. blue:31/255. alpha:1];
}
- (UIImage*)normalImageAtIndex:(NSInteger)_index
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_btn%zd_normal.png",_index+1]];
}
- (UIImage*)selectedImageAtIndex:(NSInteger)_index
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_btn%zd_select.png",_index+1]];
}
-(BOOL)shouldSelectAtIndex:(NSInteger)_index
{

    return YES;
}


@end
