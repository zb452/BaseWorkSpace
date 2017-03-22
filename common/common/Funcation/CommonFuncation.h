//
//  CommonFuncation.h
//  Yiguanjia_Paitent
//
//  Created by 张斌 on 16/8/6.
//  Copyright © 2016年 张斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonFuncation : NSObject
//系统版本
+(BOOL)SystemVersion;
//
+(UIAlertView *)ShowAlert:(NSString *)title Message:(NSString *)message;
+(UIAlertView *)ShowDoubleAlert:(NSString *)title Message:(NSString *)message;
//手机号是否符合规则
+(BOOL)isMobileCheck:(NSString *)str;
//qq号是否符合规则
+ (BOOL)isQQCheck:(NSString *)str;
//邮箱是否符合规则
+ (BOOL) validateEmail:(NSString *)email;

//获取newDate所在周的周一的日期
+ (NSDate *)getWeekBeginAndEndWith:(NSDate *)newDate;
//身份证校验
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;


//重置图片
+(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

#pragma mark //将字典或者数组转化为JSON串
+ (NSData *)toJSONData:(id)theData;


@end
