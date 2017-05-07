//
//  JJKNetworking.m
//  JJK
//
//  Created by JJK on 15/8/18.
//  Copyright (c) 2015年 JJK. All rights reserved.
//
#import "ATHttpTool.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#include <arpa/inet.h>

#ifdef DEBUG
#    define ATLog(...) NSLog(__VA_ARGS__)
#else
#    define ATLog(...) /* */
#endif

@implementation ATHttpTool
+ (void)initialize {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
+ (BOOL)reachable {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}
+ (BOOL)reachableWWAN {
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN];
}
+ (BOOL)reachableWifi {
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
}

+ (void)GET:(NSString *)URLString params:(id)params success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    [self Method:@"GET" URLString:URLString params:params bodyBlock:nil progress:nil success:success failure:failure];
}
+ (void)PUT:(NSString *)URLString params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSString *errorMsg))failure {
    [self Method:@"PUT" URLString:URLString params:params bodyBlock:nil progress:nil success:success failure:failure];
}
+ (void)DELETE:(NSString *)URLString params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSString *errorMsg))failure {
    [self Method:@"DELETE" URLString:URLString params:params bodyBlock:nil progress:nil success:success failure:failure];
}
+ (void)POST:(NSString *)URLString params:(id)params success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    [self POST:URLString params:params bodyBlock:nil success:success failure:failure];
}
+ (void)POST:(NSString *)URLString params:(id)params bodyBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    [self POST:URLString params:params bodyBlock:block progress:nil success:success failure:failure];
}
+ (void)POST:(NSString *)URLString params:(id)params bodyBlock:(void (^)(id<AFMultipartFormData>))block progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    [self Method:@"POST" URLString:URLString params:params bodyBlock:block progress:progress success:success failure:failure];
}
+ (void)Method:(NSString *)method URLString:(NSString *)URLString params:(id)params bodyBlock:(void (^)(id<AFMultipartFormData>))block progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    [self Method:method URLString:URLString params:params verifyToken:YES bodyBlock:block progress:progress success:success failure:failure];
}

+ (void)Method:(NSString *)method URLString:(NSString *)URLString params:(id)params verifyToken:(BOOL)verifyToken bodyBlock:(void (^)(id<AFMultipartFormData>))block progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSString *))failure
{
    params = [self preHandleParams:params];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    AFHTTPSessionManager *manager = [self sectionManager];
    manager.requestSerializer.timeoutInterval = manager.requestSerializer.timeoutInterval ?: ATHttpToolTimeoutInterval;
    void (^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        ATLog(@"%@ ==> %@ %@ \r\n%@", method, task.originalRequest.URL, params, responseObject);
        [self responseHandle:responseObject task:task method:method URLString:URLString params:params verifyToken:verifyToken bodyBlock:block progress:progress success:success failure:failure];
    };
    void (^failureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        ATLog(@"网络请求超时:%@ %@[params:%@] %@", task.originalRequest.URL, method, params, error);
        if (error.code == NSURLErrorCannotFindHost) {
            NSURL *url = [NSURL URLWithString:URLString relativeToURL:[[self sectionManager] baseURL]];
            NSString *iphost = [self ipHost:url];
            if (iphost && ![iphost isEqualToString:url.host]) {
                [self Method:method URLString:[url.absoluteString stringByReplacingOccurrencesOfString:url.host withString:iphost] params:params verifyToken:verifyToken bodyBlock:block progress:progress success:success failure:failure];
                return;
            }
        }
        if (failure) {
            failure(ATLocalizedString(@"Network request timeout", @"网络请求超时"));
        }
    };
    
    if ([method isEqualToString:@"GET"]) {
        [manager GET:URLString parameters:params progress:progress success:successBlock failure:failureBlock];
    }
    else if ([method isEqualToString:@"PUT"]) {
        [manager PUT:URLString parameters:params success:successBlock failure:failureBlock];
    }
    else if ([method isEqualToString:@"DELETE"]) {
        [manager DELETE:URLString parameters:params success:successBlock failure:failureBlock];
    }
    else if ([method isEqualToString:@"POST"] && !block) {
        [manager POST:URLString parameters:params progress:progress success:successBlock failure:failureBlock];
    }
    else if ([method isEqualToString:@"POST"] && block) {
        [manager POST:URLString parameters:params constructingBodyWithBlock:block progress:progress success:successBlock failure:failureBlock];
    }
}

+ (void)responseHandle:(id)responseObject task:(NSURLSessionDataTask *)task method:(NSString *)method URLString:(NSString *)URLString params:(id)params verifyToken:(BOOL)verifyToken bodyBlock:(void (^)(id<AFMultipartFormData>))block progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    if (success) {
        success(responseObject);
    }
}
+ (id)preHandleParams:(id)params {
    return params;
}
+ (AFHTTPSessionManager *)sectionManager {
    return [[AFHTTPSessionManager alloc] init];
}

+ (NSString *)ipHost:(NSURL *)url {
    static NSMutableDictionary *dict;
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    
    if (url.host.length == 0) {
        return nil;
    }
    
    NSString *ipStr = dict[url.host];
    if (ipStr.length) {
        return ipStr;
    }
    
    char ipChar[16];
    Boolean result = FALSE,bResolved;
    CFHostRef hostRef = NULL;
    CFArrayRef addresses = NULL;
    
    CFStringRef hostNameRef = CFStringCreateWithCString(kCFAllocatorDefault, [url.host cStringUsingEncoding:NSASCIIStringEncoding], kCFStringEncodingASCII);
    
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, hostNameRef);
    if (hostRef) {
        result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
        if (result == TRUE) {
            addresses = CFHostGetAddressing(hostRef, &result);
        }
    }
    bResolved = result == TRUE ? true : false;
    
    if(bResolved)
    {
        struct sockaddr_in* remoteAddr;
        for(int i = 0; i < CFArrayGetCount(addresses); i++)
        {
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            
            if(remoteAddr != NULL)
            {
                //获取IP地址
                strcpy(ipChar, inet_ntoa(remoteAddr->sin_addr));
                ipStr = [NSString stringWithCString:ipChar encoding:[NSString defaultCStringEncoding]];
                [dict setObject:ipStr forKey:url.host];
            }
        }
    }
    CFRelease(hostNameRef);
    CFRelease(hostRef);
    
    return ipStr;
}
@end
