//
//  YXNetRequestGroup.h
//  YXApp
//
//  Created by ChenChao on 15/1/15.
//  Copyright (c) 2015年 YingXiang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YXNetRequestGroup : NSObject
@property(readonly, nonatomic)NSMutableDictionary* requests;
@property(readonly, nonatomic)NSInteger numberOfRequests;

/**
 *  Get请求
 *
 *  @param URLString  URL
 *  @param parameters 参数集
 *  @param success    success block
 *  @param failure    failure block
 *
 *  @return 请求事务实例
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                    withProcess:(void(^)(NSProgress *loadProcess))pocessBlock
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  POST请求
 *
 *  @param URLString  URL
 *  @param parameters 参数集
 *  @param success    success block
 *  @param failure    failure block
 *
 *  @return 请求事务实例
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                    withProcess:(void(^)(NSProgress *loadProcess))pocessBlock
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  POST请求 带图片上传
 *
 *  @param URLString  URL
 *  @param parameters 参数集
 *  @param bodyDatas  图片集合
 *  @param identifer  文件标识
 *  @param success    success block
 *  @param failure    failure block
 *
 *  @return 请求事务实例
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                    withProcess:(void(^)(NSProgress *loadProcess))pocessBlock
     constructingBodyWithDatas:(NSArray*)bodyDatas
         constructingIdentifer:(NSString*)identifer
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  文件下载
 *
 *  @param URLString URL
 *  @param filePath  目标路径
 *  @param progress  下载进度
 *  @param success   success block
 *  @param failure   failure block
 *
 *  @return 下载请求事务实例
 */
- (NSURLSessionDownloadTask *)download:(NSString *)URLString
                              filePath:(NSString *)filePath
                                withProcess:(void(^)(NSProgress *loadProcess))pocessBlock
                              progress:(NSProgress * __autoreleasing *)progress
                               success:(void (^)(NSURLResponse *response, NSURL *filePath))success
                               failure:(void (^)(NSURLResponse *response, NSError *error))failure;

/**
 *  cancel Request ByPath (post method)
 *
 *  @param urlPath urlPath
 */
- (void)cancelRequestByUrlString:(NSString *)urlPath;

/**
 *  cancel Request byUrl
 *
 *  @param nsUrl URL
 */
- (void)cancelRequestByNSURL:(NSURL *)nsUrl;

/**
 *  cancel Request byOperation
 *
 *  @param operation operation
 */
- (void)cancelRequestByOperation:(id)operation;

/**
 *  cancel All Request
 */
- (void)cancelAllRequest;//只取消本manager当中的request

/**
 *  获取请求事务
 *
 *  @param urlPath urlPath
 *
 *  @return 请求事务实例
 */
- (NSURLSessionTask *)findOperationByUrlPath:(NSString *)urlPath;
@end
