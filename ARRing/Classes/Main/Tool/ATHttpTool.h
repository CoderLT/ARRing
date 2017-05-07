//
//  ATHttpTool.h
//  AT
//
//  Created by AT on 15/8/18.
//  Copyright (c) 2015年 AT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"

#define ATHttpToolTimeoutInterval 30.0f
@protocol AFMultipartFormData;
@interface ATHttpTool : NSObject
+ (BOOL)reachable;
+ (BOOL)reachableWifi;
+ (BOOL)reachableWWAN;

+ (void)GET:(NSString *)URLString
     params:(id)params
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSString *errorMsg))failure;

+ (void)POST:(NSString *)URLString
      params:(id)params
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSString *errorMsg))failure;

+ (void)POST:(NSString *)URLString
      params:(id)params
   bodyBlock:(void (^)(id <AFMultipartFormData> formData))block
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSString *errorMsg))failure;

+ (void)POST:(NSString *)URLString
      params:(id)params
   bodyBlock:(void (^)(id <AFMultipartFormData> formData))block
    progress:(void (^)(NSProgress *progress))progress
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSString *errorMsg))failure;

+ (void)PUT:(NSString *)URLString
     params:(id)params
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSString *errorMsg))failure;

+ (void)DELETE:(NSString *)URLString
        params:(id)params
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSString *errorMsg))failure;

+ (void)Method:(NSString *)method
     URLString:(NSString *)URLString
        params:(id)params
     bodyBlock:(void (^)(id<AFMultipartFormData>))block
      progress:(void (^)(NSProgress *progress))progress
       success:(void (^)(id))success
       failure:(void (^)(NSString *))failure;

+ (void)Method:(NSString *)method
     URLString:(NSString *)URLString
        params:(id)params
   verifyToken:(BOOL)verifyToken
     bodyBlock:(void (^)(id<AFMultipartFormData>))block
      progress:(void (^)(NSProgress *progress))progress
       success:(void (^)(id))success
       failure:(void (^)(NSString *))failure;

/****************************************************************************
 *  以下由子类重载
 */

/**
 *  网络请求结果处理
 *
 *  @param responseObject 请求接口
 *  @param task           请求任务
 *  @param method         请求方法
 *  @param URLString      请求URL
 *  @param params         请求的参数
 *  @param verifyToken    请求是否需要校验Token
 *  @param block          请求body构造函数
 *  @param progress       请求进度回调
 *  @param success        请求成功回调
 *  @param failure        请求失败回调
 */
+ (void)responseHandle:(id)responseObject task:(NSURLSessionDataTask *)task method:(NSString *)method URLString:(NSString *)URLString params:(id)params verifyToken:(BOOL)verifyToken bodyBlock:(void (^)(id<AFMultipartFormData>))block progress:(void (^)(NSProgress *progress))progress success:(void (^)(id))success failure:(void (^)(NSString *))failure;
/**
 *  参数预处理,如添加特定签名sign等
 */
+ (id)preHandleParams:(id)params;
/**
 *  自定义 AFHTTPSessionManager
 */
+ (id)sectionManager;
@end
