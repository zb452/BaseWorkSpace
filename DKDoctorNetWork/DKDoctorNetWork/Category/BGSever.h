//
//  BGSever.h
//  BGSever
//
//  Created by Samuel on 14-6-11.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "urls.h"
#import "NetEngine.h"
#import "HttpBase.h"

#define errorString @"服务期打盹~~~~"
#define ISNotNULL(obj) (obj&&![obj isEqual:[NSNull null]])?YES:NO

typedef  void(^SuccessId)(id result);
typedef  void (^Failure) (NSError *error);
typedef  void (^FailureStr) (NSString *errorStr);
typedef  void (^Success) (NSDictionary* getDic);
typedef  void (^Process) (NSProgress *process);



@interface NSMutableDictionary (Post)

-(void)setNoNullObject:(id)anObject forKey:(id<NSCopying>)aKey;
-(void)setObject:(id)anObject forKey:(id<NSCopying>)aKey withDefault:(id)defaultValue;

@end

@interface NSArray (Get)

-(id)objectAt:(NSInteger)index;
@end

@interface BGSever : NSObject
{
    NetEngine *baseSever;
}

@end
