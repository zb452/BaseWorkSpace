//
//  CustomTabbarViewController.m
//  CustomTabbar
//
//  Created by wtfan on 12-2-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomTabbarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "UIView+YGJFrame.h"

#define KTABBAR_BACKGROUNDTAG  15648794

static IMP s_original_Tabbar_MethodOfdrawRect = nil;

//解决ios5以下背景为黑色问题
@implementation UITabBar (customeDraw)

+(void)replateDrawMethod
{
	if (!s_original_Tabbar_MethodOfdrawRect)
	{
		s_original_Tabbar_MethodOfdrawRect = [UITabBar instanceMethodForSelector:@selector(drawRect:)];
		class_replaceMethod([UITabBar class], @selector(drawRect:), [UITabBar instanceMethodForSelector:@selector(customDrawRect:)],nil);
	}
}

-(void)customDrawRect:(CGRect)rect
{
	
}

-(void)layoutSubviews
{
	[super layoutSubviews];
}

@end

@interface CustomTabbarViewController(hidden)

- (void)clearsysItem;
- (void)reSizeTabBarView;
- (void)didSelectTabbar:(id)sender;
- (void)selectTabbarImageAtIndex:(NSUInteger)selectedTabIndex;
- (void)reLayoutBackground;
-(void)resetItemState;

@end

@implementation CustomTabbarViewController
@synthesize tabHeight = m_f_tabHeight;
@synthesize transOffset = m_f_transOffset;
@synthesize growPosition = m_GrowPosition;
@synthesize itemPosition = m_ItemPosition;
@synthesize m_delegate;


- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		m_f_tabHeight = self.tabBar.frame.size.height;
        self.view.backgroundColor = [UIColor blackColor];
	}
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[UITabBar replateDrawMethod];
    [super viewDidLoad];
	self.tabBar.backgroundColor = [UIColor clearColor];
	[self reloadTabbar];
    
    [self.tabBar addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew |
                                                             NSKeyValueObservingOptionOld) context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    UIImageView* _backview = (UIImageView*)[self.tabBar viewWithTag:KTABBAR_BACKGROUNDTAG];
	[self.tabBar bringSubviewToFront:_backview];
    for (UIButton* b in _tabBarButtonsArray) {
        [self.tabBar bringSubviewToFront:b];
    }
    [self reSizeTabBarView];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[_tabBarButtonsArray release];
	_tabBarButtonsArray = nil;
    [_tabBarBadgeArray release];
    _tabBarBadgeArray = nil;
}

-(void)dealloc
{
    [self.tabBar removeObserver:self
                   forKeyPath:@"frame"];
    
	[_tabBarButtonsArray release];
    [_tabBarBadgeArray release];
    [super dealloc];
}

-(void)setBackgroundImage:(UIImage *)backgroundImage
{
	UIImageView* _backview = (UIImageView*)[self.tabBar viewWithTag:KTABBAR_BACKGROUNDTAG];
	if (!backgroundImage) 
	{
		[_backview removeFromSuperview];
		return;
	}
	
	if (_backview)
	{
		_backview.image = backgroundImage;
	}
	else
	{
		_backview = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        _backview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_backview.tag = KTABBAR_BACKGROUNDTAG;
		[self.tabBar addSubview:_backview];
	}
	[self.tabBar sendSubviewToBack:_backview];
	[self reLayoutBackground];
}

-(void)reLayoutBackground
{
	UIImageView* _backview = (UIImageView*)[self.tabBar viewWithTag:KTABBAR_BACKGROUNDTAG];
	if (_backview)
	{
		_backview.frame = CGRectMake(0, self.tabBar.frame.size.height - _backview.image.size.height, self.tabBar.bounds.size.width, _backview.image.size.height);
	}
}

-(BOOL)isTabBarHidden
{
	if (CGRectGetMinY(self.tabBar.frame) >= CGRectGetMaxY(self.view.bounds))
	{
		return YES;
	}
	return NO;
}

-(void)hideTabBar:(BOOL)animated
{
	if ([self isTabBarHidden])
	{
		return;
	}
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.3];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(didHideTabBarStop)];
	}
	
	for(UIView *view in self.view.subviews)
    {
		CGRect rect = view.frame;
        if([view isKindOfClass:[UITabBar class]])
        {
			rect.origin.y = self.view.frame.size.height;
			view.frame = rect;
        }
        else if(view.tag == 0)
        {
            if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                rect.size.height = self.view.frame.size.width - rect.origin.y;
            }else{
                rect.size.height = self.view.frame.size.height - rect.origin.y;
            }
			view.frame = rect;
        }
    }
	
	if (animated)
	{
		[UIView commitAnimations];
	}
}

-(void)didHideTabBarStop
{
	if ([self isTabBarHidden])
	{
		self.tabBar.hidden = YES;
	}
	else
	{
		self.tabBar.hidden = NO;
	}
}

-(void)showTabBar:(BOOL)animated{
    self.tabBar.hidden = NO;
    
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		[UIView setAnimationBeginsFromCurrentState:YES];
	}
	
	CGRect tabrect = self.tabBar.frame;
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        tabrect.origin.y = self.view.frame.size.width - self.tabBar.frame.size.height;
    }else{
        tabrect.origin.y = self.view.frame.size.height - self.tabBar.frame.size.height;
    }
	self.tabBar.frame = tabrect;
    
	if (animated)
	{
		[UIView commitAnimations];
	}
}
- (void)showBadgeForTabItem:(NSInteger)item
{
    if (_tabBarBadgeArray.count > 0 && item < _tabBarBadgeArray.count) {
        UILabel *label = (UILabel *)[_tabBarBadgeArray objectAtIndex:item];
        label.text = @"";
        label.hidden = NO;
    }
}

- (void)showBadgeForTabItem:(NSInteger)item title:(NSString *)tilte
{
    if (_tabBarBadgeArray.count > 0 && item < _tabBarBadgeArray.count) {
        UILabel *label = (UILabel *)[_tabBarBadgeArray objectAtIndex:item];
        label.text = tilte;
        label.hidden = NO;
    }
}
- (void)hideBadgeForTabItem:(NSInteger)item
{
    if (_tabBarBadgeArray.count > 0 && item < _tabBarBadgeArray.count) {
        UILabel *label = (UILabel *)[_tabBarBadgeArray objectAtIndex:item];
        label.text = @"";
        label.hidden = YES;
    }
}
-(void)setViewControllers:(NSArray *)viewControllers
{
	[super setViewControllers:viewControllers];
	[self reloadTabbar];
}

-(void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
	[super setViewControllers:viewControllers animated:animated];
	[self reloadTabbar];
}

- (void)clearsysItem
{
	NSUInteger _currentIndex = self.selectedIndex;
	if (_currentIndex >= [self numberOfViewCtrls])
	{
		_currentIndex = 0;
		[super setSelectedIndex:_currentIndex];
	}
	
	for (UIView* vi in self.tabBar.subviews)
	{
		if (vi.tag == KTABBAR_BACKGROUNDTAG)
		{
			continue;
		}
		[vi removeFromSuperview];
	}
}

-(void)reloadTabbar
{
	[self clearsysItem];
	
	[self reloadTabbarImages];
	
	[self resetItemState];
}

-(void)resetItemState
{
	//从新设置位置
	NSUInteger _currentIndex = self.selectedIndex;
	if (_currentIndex >= [self numberOfViewCtrls])
	{
		_currentIndex = 0;
	}
    self.selectedIndex = _currentIndex;
}


-(void)reloadTabbarImages
{
	NSInteger tabItemsCount = [self numberOfViewCtrls];
    [_tabBarButtonsArray release];
    [_tabBarBadgeArray release];
    _tabBarButtonsArray = [[NSMutableArray alloc] initWithCapacity:tabItemsCount];
    _tabBarBadgeArray = [[NSMutableArray alloc] initWithCapacity:tabItemsCount];
    

    for (int i=0; i < [self numberOfViewCtrls]; i++)
	{
        UIButton *tabBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tabBarButton.tag = i;
        [tabBarButton addTarget:self action:@selector(didSelectTabbar:) forControlEvents:UIControlEventTouchDown];
		tabBarButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        tabBarButton.frame = CGRectMake(self.tabBar.width/[self numberOfViewCtrls]*i,0, self.tabBar.width/[self numberOfViewCtrls], self.tabBar.height);
        [_tabBarButtonsArray addObject:tabBarButton];
        
         [self.tabBar addSubview:tabBarButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/tabItemsCount-34, 5, 8, 8)];
       // label.backgroundColor = [UIColor color];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 4.0;
        label.text = @"";
        label.hidden = YES;
        [_tabBarBadgeArray addObject:label];
        
       
        [tabBarButton addSubview:label];
        [label release];
    }
}



- (void)didSelectTabbar:(id)sender
{
    UIButton *selectedButton = (UIButton *)sender;

    NSInteger  selectIndex = 0;

    selectIndex = selectedButton.tag;
    
	BOOL canSelect = YES;
	if ([m_delegate respondsToSelector:@selector(shouldSelectAtIndex:)])
	{
		canSelect = [m_delegate shouldSelectAtIndex:selectIndex];
	}
    
	if (canSelect)
	{
		if ([m_delegate respondsToSelector:@selector(didSelectAtIndex:)])
		{
			[m_delegate didSelectAtIndex:selectIndex];
		}
		self.selectedIndex = selectIndex;
	}
    
    button_index = selectIndex;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
	[super setSelectedIndex:selectedIndex];

	[self selectTabbarImageAtIndex:self.selectedIndex];
}

- (void)selectTabbarImageAtIndex:(NSUInteger)selectedTabIndex
{

    for (int i=0; i < [_tabBarButtonsArray count]; i++) 
	{
		UIImage *buttonImage = nil;
        if (selectedTabIndex==i)
		{
			if ([m_delegate respondsToSelector:@selector(selectedImageAtIndex:)])
			{
				buttonImage = [m_delegate selectedImageAtIndex:selectedTabIndex];
			}
            if ([_tabBarBadgeArray count] > selectedTabIndex) {//不越界
                
                UIButton *selectedButton = [_tabBarButtonsArray objectAtIndex:selectedTabIndex];
                [selectedButton setImage:buttonImage forState:UIControlStateNormal];
                [selectedButton setImage:buttonImage forState:UIControlStateSelected];
                [selectedButton setImage:buttonImage forState:UIControlStateHighlighted];
            }

        }
		else
		{
			if ([m_delegate respondsToSelector:@selector(normalImageAtIndex:)])
			{
				buttonImage = [m_delegate normalImageAtIndex:i];
			}
			
			UIButton *button = [_tabBarButtonsArray objectAtIndex:i];
			[button setImage:buttonImage forState:UIControlStateNormal];
			[button setImage:buttonImage forState:UIControlStateSelected];
			[button setImage:buttonImage forState:UIControlStateHighlighted];
		}
    }
}

-(void)setTabHeight:(CGFloat)tabHeight
{
	m_f_tabHeight = tabHeight;
	
	[self reSizeSubView];
}

-(void)setTransOffset:(CGFloat)transOffset
{
	m_f_transOffset = transOffset;
	[self reLayoutBackground];
}

-(void)setItemPosition:(ECustomTabbarVerticalPosition)itemPosition
{
	m_ItemPosition = itemPosition;
	[self reSizeSubView];
}

-(void)reSizeSubView
{
	CGRect _rect = self.tabBar.frame;
	CGFloat maxY = CGRectGetMaxY(self.view.bounds);
	
	_rect.size.height = self.tabHeight;
    _rect.origin.y = maxY - _rect.size.height;
    self.tabBar.frame = _rect;
	
	[self reLayoutBackground];
	[self reSizeTabBarView];
}

-(void)reSizeTabBarView
{
	NSInteger tabItemsCount = [self numberOfViewCtrls];
	
	UIImage *buttonImage = nil;
	if ([m_delegate respondsToSelector:@selector(selectedImageAtIndex:)])
	{
		buttonImage = [m_delegate selectedImageAtIndex:0];
	}
	
	float tabWidth = self.tabBar.frame.size.width/tabItemsCount;
    float tabHeight = self.tabBar.frame.size.height;
    
//	if (buttonImage)
//	{
//		tabHeight = buttonImage.size.height;
//	}
	
    float tabXCenter = tabWidth/2;
    float tabYCenter = tabHeight/2;
	float tabX = 0;
	
	for (int i = 0; i < [_tabBarButtonsArray count]; i++)
	{
		UIButton* tabBarButton = [_tabBarButtonsArray objectAtIndex:i];
		
		switch (self.itemPosition)
		{
			case ECustomTabbarItem_Top:
				tabBarButton.frame = CGRectMake(tabX, 0.0, tabWidth,tabHeight);
				break;
			case ECustomTabbarItem_Middle:
				tabBarButton.frame = CGRectMake(0.0, 0.0, tabWidth,tabHeight);
				tabBarButton.center = CGPointMake(tabXCenter, tabYCenter);
				break;
			case ECustomTabbarItem_Bottom:
			default:
				tabBarButton.frame = CGRectMake(tabX, self.tabHeight - tabHeight, tabWidth,tabHeight);
				break;
		}
		tabXCenter += tabWidth;
        tabX += tabWidth;
	}
}

-(NSInteger)numberOfViewCtrls
{
	return [self.viewControllers count];
}

@end
