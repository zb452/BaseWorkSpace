//
//  RTArray.m
//  Anjuke
//
//  Created by Wang Qiansheng on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RTArray.h"


@implementation NSArray (RTArray)

- (NSInteger)integerAtIndex:(NSInteger)index
{
    NSNumber *number = [self objectAt:index];
    return [number intValue];
}

+ (NSArray *)arrayNamed:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

- (id)objectAt:(NSUInteger)index {
    if (self && [self isKindOfClass:[NSArray class]] && self.count > index) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (NSArray *)mergeSameString {
    NSMutableArray *tmp = [self mutableCopy];
    int i = 0;
    NSString *stringTmp = nil;
    while (i < [tmp count]) {
        stringTmp = [tmp objectAtIndex:i];
        for (int j = i + 1; j < [tmp count]; ) {
            if ([stringTmp isEqualToString:[tmp objectAtIndex:j]]) {
                [tmp removeObjectAtIndex:j];
            } else {
                j++;
            }
        }
        i++;
    }
    return [NSArray arrayWithArray:tmp];
}

@end
