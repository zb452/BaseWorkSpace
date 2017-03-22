//
//  NetEngine.m
//  LLProjectNetBase
//
//  Created by yintengxiang on 15/6/24.
//  Copyright (c) 2015年 LLProjectNetBase. All rights reserved.
//

#import "NetEngine.h"

@implementation NetEngine
+ (instancetype)sharedEngine
{
    static NetEngine* s_sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_sharedEngine = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:URLDomainName]];
        s_sharedEngine.responseSerializer = [AFJSONResponseSerializer serializer];
        s_sharedEngine.requestSerializer = [AFJSONRequestSerializer serializer];
        s_sharedEngine.requestSerializer.timeoutInterval = 10;
        
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        securityPolicy.validatesDomainName = NO; //不验证证书的域名
//        
//        s_sharedEngine.securityPolicy = securityPolicy;
    });
    return s_sharedEngine;
}

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
 
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];

        _requestGroup = [[YXNetRequestGroup alloc] init];
    }
    
    return self;
}

//NSURL * url = [NSURL URLWithString:@"https://www.google.com"];
//AFHTTPRequestOperationManager * requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
//dispatch_queue_t requestQueue = dispatch_create_serial_queue_for_name("kRequestCompletionQueue");
//requestOperationManager.completionQueue = requestQueue;
//AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
////allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
////如果是需要验证自建证书，需要设置为YES
//securityPolicy.allowInvalidCertificates = YES;
////validatesDomainName 是否需要验证域名，默认为YES；
////假如证书的域名与你请求的域名不一致，需把该项设置为NO
////主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//securityPolicy.validatesDomainName = NO;
////validatesCertificateChain 是否验证整个证书链，默认为YES
////设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
////GeoTrust Global CA
////    Google Internet Authority G2
////        *.google.com
////那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
////如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证；
//securityPolicy.validatesCertificateChain = NO;
//requestOperationManager.securityPolicy = securityPolicy;
@end
