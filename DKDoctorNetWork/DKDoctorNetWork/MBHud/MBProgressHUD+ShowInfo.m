//
//  MBProgressHUD+ShowInfo.m
//  i1-app
//
//  Created by sam on 15/12/20.
//  Copyright © 2015年 amigosoftware. All rights reserved.
//

#import "MBProgressHUD+ShowInfo.h"


@interface MBProgressHUD (ShowInfo_Private)

@property(assign,nonatomic)CGAffineTransform rotationTransform;


@end

@implementation MBProgressHUD (ShowInfo)


+(MBProgressHUD *)ShowHUD:(UIView *)view
{
    static MBProgressHUD *HUD=nil;
    static dispatch_once_t onceToken;
    if (view) {
        dispatch_once(&onceToken, ^{
            HUD=[[MBProgressHUD alloc] initWithFrame:view.frame];
        });
        
        if (![view isKindOfClass:[UIWindow class]])
        {
            HUD.frame=view.frame;
            [HUD resetTransForm];
            [HUD show:YES];
            HUD.mode=MBProgressHUDModeIndeterminate;
            [view addSubview:HUD];
        }
        BOOL isIOS8 = NO;
        isIOS8 = [[[UIDevice currentDevice]systemVersion] floatValue]>=8.;
        if ([view isKindOfClass:[UIWindow class]]&&!isIOS8)
        {
            //[HUD setTransformForCurrentOrientation:NO];
            
            UIDeviceOrientation tansform = [UIDevice currentDevice].orientation;
            if (tansform == UIDeviceOrientationLandscapeLeft) {
                HUD.transform = CGAffineTransformMakeRotation((M_PI * (90) / 180.0));
            }else if(tansform == UIDeviceOrientationLandscapeRight) {
                HUD.transform = CGAffineTransformMakeRotation((M_PI * (-90) / 180.0));
            }
        }
        else
        {
            HUD.transform = CGAffineTransformMakeRotation(0);
        }
    }
    return HUD;
}

-(void)resetTransForm
{
    self.rotationTransform = CGAffineTransformIdentity;
    [self setTransform:self.rotationTransform];
}

//显示出信息后消失
+(void)showHideMessage:(NSString *)str
{
    if (str)
    {
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *HUD=[MBProgressHUD ShowHUD:window];
        HUD.mode=MBProgressHUDModeText;
        HUD.labelText=str;
        [window addSubview:HUD];
        [HUD show:YES];
        [HUD hide:YES afterDelay:1.0];
        
    }
}

+(void)showHideMessage:(NSString *)str afterDealy:(NSTimeInterval)dealy
{
    if (str)
    {
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *HUD=[MBProgressHUD ShowHUD:window];
        HUD.mode=MBProgressHUDModeText;
        HUD.labelText=str;
        [window addSubview:HUD];
        [HUD show:YES];
        [HUD hide:YES afterDelay:dealy];
    }
}

+(void)showMessage:(NSString *)str
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD=[MBProgressHUD ShowHUD:window];
    HUD.mode=MBProgressHUDModeText;
    HUD.labelText=str;
    [window addSubview:HUD];
    
    [HUD show:YES];
}
+(void)hideMessage:(NSString *)str
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD=[MBProgressHUD ShowHUD:window];
    
    [HUD hide:YES];
}


@end
