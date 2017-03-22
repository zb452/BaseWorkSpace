//
//  YekCustomTabbarViewController.h
//  YekCustomTabbar
//
//  Created by wtfan on 12-2-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTabbarViewControllerDelegate <NSObject>

// 以下方法必须在子类实现
-(UIImage*)normalImageAtIndex:(NSInteger)_index;
-(UIImage*)selectedImageAtIndex:(NSInteger)_index;
@optional
-(BOOL)shouldSelectAtIndex:(NSInteger)_index;
-(void)didSelectAtIndex:(NSInteger)_index;

@end

typedef enum
{
	ECustomTabbarItem_Top = -1,
	ECustomTabbarItem_Middle = 0,
	ECustomTabbarItem_Bottom,
	
} ECustomTabbarVerticalPosition;

@interface CustomTabbarViewController : UITabBarController
{
    NSMutableArray *_tabBarButtonsArray;
    NSMutableArray *_tabBarBadgeArray;
	
    CGFloat		m_f_tabHeight;
	CGFloat		m_f_transOffset;
	
	ECustomTabbarVerticalPosition m_GrowPosition;
	ECustomTabbarVerticalPosition m_ItemPosition;
	
	id<CustomTabbarViewControllerDelegate> m_delegate;
    
    NSInteger       button_index;//标记上一次选中的tab
}

@property (nonatomic, assign) CGFloat tabHeight;
@property (nonatomic, assign) CGFloat transOffset;
@property (nonatomic, assign) ECustomTabbarVerticalPosition growPosition;
@property (nonatomic, assign) ECustomTabbarVerticalPosition itemPosition;
@property (nonatomic, assign) id<CustomTabbarViewControllerDelegate> m_delegate;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

-(void)reloadTabbar;
-(void)reloadTabbarImages;
-(void)setBackgroundImage:(UIImage*)backgroundImage;
-(BOOL)isTabBarHidden;
-(void)hideTabBar:(BOOL)animated;
-(void)showTabBar:(BOOL)animated;
-(void)reSizeSubView;

-(NSInteger)numberOfViewCtrls;
- (void)showBadgeForTabItem:(NSInteger)item;
- (void)showBadgeForTabItem:(NSInteger)item title:(NSString *)tilte;
- (void)hideBadgeForTabItem:(NSInteger)item;
@end
