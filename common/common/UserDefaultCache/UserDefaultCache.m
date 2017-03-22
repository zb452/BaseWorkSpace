//
//  UserDefaultCache.m
//  common
//
//  Created by 张斌 on 2017/2/10.
//  Copyright © 2017年 陕西医管家医院管理咨询服务有限公司. All rights reserved.
//

#import "UserDefaultCache.h"

@implementation UserDefaultCache

+ (void)setCache:(id)data forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)loadCache:(NSString *)key {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:key]];
}

+(void)removeCache:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

@end
