//
//  NSString+ContentSize.m
//  UIComponents
//
//  Created by liu lh on 13-11-21.
//  Copyright (c) 2013年 anjuke inc. All rights reserved.
//

#import "NSString+RTSizeWithFont.h"

@implementation NSString (RTSizeWithFont)

- (CGSize)rtSizeWithFont:(UIFont *)font{

    if ([self SystemVersion]) {
        return [self sizeWithAttributes:@{NSFontAttributeName:font}];
    } else {
        return [self sizeWithFont:font];
    }
}
-(BOOL)SystemVersion{
    NSString *strVersion=[[UIDevice currentDevice] systemVersion];
    float fltVersion=[strVersion floatValue];
    if (fltVersion>=7.0) {
        return YES;
    }
    return NO;
}
- (CGSize)rtSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    if ([self SystemVersion]) {
        return [self boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:font}
                                  context:nil].size;
    } else {
        return [self sizeWithFont:font constrainedToSize:size];
    }
}

- (CGSize)rtSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode{
    if ([self SystemVersion]) {
        return [self boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:font}
                                  context:nil].size;
    } else {
        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    }
}
@end
