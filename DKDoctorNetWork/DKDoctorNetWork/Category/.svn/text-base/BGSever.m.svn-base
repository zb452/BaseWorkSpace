//
//  BGSever.m
//  BGSever
//
//  Created by Samuel on 14-6-11.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import "BGSever.h"
@implementation NSMutableDictionary (Post)

-(void)setNoNullObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
}

-(void)setObject:(id)anObject forKey:(id<NSCopying>)aKey withDefault:(id)defaultValue
{
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }else if(defaultValue)
    {
        [self setObject:defaultValue forKey:aKey];
    }else
    {
        [self setObject:@"" forKey:aKey];
    }
}

@end

@implementation NSArray (Avoid)

-(id)objectAt:(NSInteger)index
{
    if (index>=self.count)
    {
        return nil;
    }
    
    return [self objectAtIndex:index];
}
@end

@implementation BGSever
static NSString* _s_userId = nil;

-(id)init{
    self = [super init];
    if (self) {
        baseSever = [NetEngine sharedEngine];
    }
    return self;
}

@end
