//
//  CommonFuncation.m
//  Yiguanjia_Paitent
//
//  Created by 张斌 on 16/8/6.
//  Copyright © 2016年 张斌. All rights reserved.
//

#import "CommonFuncation.h"

@implementation CommonFuncation

#pragma mark- AlertView
+(BOOL)SystemVersion{
    //    NSString *strVersion=[[UIDevice currentDevice] systemVersion];
    //    float fltVersion=[strVersion floatValue];
    //    if (fltVersion>=7.0) {
    //        return YES;
    //    }
    return ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)?YES:NO;
}

+(UIAlertView *)ShowAlert:(NSString *)title Message:(NSString *)message{
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
    return alertview;
}
+(UIAlertView *)ShowDoubleAlert:(NSString *)title Message:(NSString *)message{
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alertview show];
    return alertview;
}


#pragma mark- 字符规则检查
// 手机号
+(BOOL)isMobileCheck:(NSString *)str{
    NSString *regex = @"^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    //NSString *Regex = @"^(13[0-9]|14[0-9]|15[0-9]|18[0-9])\\d{8}$";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [Test evaluateWithObject:str];
}

//QQ
+ (BOOL)isQQCheck:(NSString *)str {
    
    NSString *regex = @"^[1-9][0-9]{4,}";
    //NSString *Regex = @"^(13[0-9]|14[0-9]|15[0-9]|18[0-9])\\d{8}$";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [Test evaluateWithObject:str];
    
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//身份证
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}


#pragma mark- 日期功能
//获取newDate所在周的周一的日期
+ (NSDate *)getWeekBeginAndEndWith:(NSDate *)newDate
{
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&beginDate interval:&interval forDate:newDate];
    
    return beginDate;
}

//重置图片
+(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    
    UIImage *newimage;
    
    if (nil == image) {
        newimage = nil;
    }
    
    else{
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y =0;
            
        }
        
        else{
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x =0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context =UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0,0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
}

#pragma mark //将字典或者数组转化为JSON串
+ (NSData *)toJSONData:(id)theData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil)
    {
        return jsonData;
    }
    else
    {
        return nil;
    }
}




@end
