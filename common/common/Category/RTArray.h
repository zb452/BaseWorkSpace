//
//  RTArray.h
//  Anjuke
//
//  Created by Wang Qiansheng on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (RTArray)

- (NSInteger)integerAtIndex:(NSInteger)index;
+ (NSArray *)arrayNamed:(NSString *)name;
- (id)objectAt:(NSUInteger)index;
- (NSArray *)mergeSameString;

@end
