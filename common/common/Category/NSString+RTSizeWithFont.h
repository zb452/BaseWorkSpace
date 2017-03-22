//
//  NSString+ContentSize.h
//  UIComponents
//
//  Created by liu lh on 13-11-21.
//  Copyright (c) 2013年 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (RTSizeWithFont)

- (CGSize)rtSizeWithFont:(UIFont *)font;
- (CGSize)rtSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)rtSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
