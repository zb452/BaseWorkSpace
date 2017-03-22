//
//  BaseViewModel.m
//  DK_Doctor
//
//  Created by 张斌 on 2017/2/10.
//  Copyright © 2017年 陕西医管家医院管理咨询服务有限公司. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNetWorkBad = NO;
        self.isWaitData = NO;
    }
    return self;
}

@end
