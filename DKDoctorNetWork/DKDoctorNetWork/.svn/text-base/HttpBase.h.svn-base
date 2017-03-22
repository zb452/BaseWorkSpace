//
//  HttpBase.h
//  LLProjectNetBase
//
//  Created by sam on 16/3/8.
//  Copyright © 2016年 LLProjectNetBase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HttpBase : NSObject
{
    
}

@property (nonatomic,strong)MBProgressHUD *hud;


+(HttpBase *)shareHttpBase;

/**
 *  统一发送get请求
 *
 *  @param actionName   接口名
 *  @param parameters   接口参数
 *  @param successBlock
 *  @param failBlock
 */
-(void) getDataFromAction:(NSString*)actionName
            withParameters:(NSDictionary*)parameters
              withProcess:(void(^)(NSProgress *loadProcess))pocessBlock
          withSuccessBlock:(void(^)(id backJson)) successBlock
             withFailBlock:(void(^)(NSError *error))failBlock;
/**
 *  统一发送get请求, 有提示信息
 *
 *  @param actionName   接口名
 *  @param parameters   接口参数
 *  @param successBlock
 *  @param failBlock
 */
-(void) getDataFromAction:(NSString*)actionName
               isShowLoad:(BOOL)isShowLoad
                 loadText:(NSString *)text
                withParameters:(NSDictionary*)parameters
              withProcess:(void(^)(NSProgress *loadProcess))pocessBlock
         withSuccessBlock:(void(^)(id backJson)) successBlock
            withFailBlock:(void(^)(NSError *error))failBlock;

- (void)postDataFromAction:(NSString*)actionName
            withParameters:(NSDictionary*)parameters
            withProcess:(void(^)(NSProgress *loadProcess))pocessBlock
          withSuccessBlock:(void(^)(id backJson)) successBlock
             withFailBlock:(void(^)(NSError *error))failBlock;

//不显示loading图标
- (void)postDataFromAction:(NSString*)actionName
                isShowLoad:(BOOL)isShowLoad
                  loadText:(NSString *)text
            withParameters:(NSDictionary*)parameters
               withProcess:(void(^)(NSProgress *loadProcess))pocessBlock
          withSuccessBlock:(void(^)(id backJson)) successBlock
             withFailBlock:(void(^)(NSError *error))failBlock;

@end
