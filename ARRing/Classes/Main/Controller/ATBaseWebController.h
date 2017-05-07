//
//  ATBaseWebController.h
//  AiJiaFang
//
//  Created by CoderLT on 15/4/24.
//  Copyright (c) 2015年 AT. All rights reserved.
//

#import "ATBaseController.h"
#import <WebKit/WebKit.h>

@interface ATBaseWebController__ : ATBaseController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *baseURLString;
@property (nonatomic, copy)   NSString *urlString;
@property (nonatomic, copy)   NSString *webNavTitle;

+ (instancetype)vcWithURLString:(NSString *)urlString;
+ (instancetype)vcWithURLString:(NSString *)urlString title:(NSString *)title;

- (void)webViewRequestDidStart;
- (void)webViewRequestDidUpdateProgress:(CGFloat)progress;
- (void)webViewRequestingDidEnd;
@end

@interface ATBaseWebController : ATBaseWebController__

+ (instancetype)webViewWithURLAbsoluteString:(NSString *)urlString;
+ (instancetype)webViewWithBaseUrl:(NSString *)baseUrlString urlString:(NSString *)urlString;

- (void)reloadWebView;
- (void)webViewCustomLoadingDidStart;
- (void)webViewCustomLoadingDidEnd;
@end