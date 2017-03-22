//
//  LearningRecordDataController.h
//  LLProject
//
//  Created by yintengxiang on 16/4/4.
//  Copyright © 2016年 LLProject. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^Callback) (NSError *error);

@interface BaseDataController : NSObject

- (void)requestDataWithCallback:(Callback)callback;

@end
