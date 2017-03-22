//
//  CryptoFuncation.m
//  EPNetWork
//
//  Created by 张斌 on 2016/10/15.
//  Copyright © 2016年 陕西医管家医院管理咨询服务有限公司. All rights reserved.
//

#import "CryptoFuncation.h"
#import<CommonCrypto/CommonDigest.h>

@implementation CryptoFuncation

//MD5加密
+ (NSString *) md5:(NSString *) input
{
    if (input.length == 0)
    {
        return nil;
    }
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
