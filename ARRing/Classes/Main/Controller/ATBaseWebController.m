//
//  ATBaseWebController.m
//  AiJiaFang
//
//  Created by CoderLT on 15/4/24.
//  Copyright (c) 2015年 AT. All rights reserved.
//

#import "ATBaseWebController.h"
#import "UIViewController+Util.h"
#import "MBProgressHUD+Add.h"
#import "WKWebViewJavascriptBridge.h"

#ifndef ATLog
#if DEBUG
#define ATLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define ATLog(format, ...)
#endif
#endif

@interface NJKWebViewProgressView : UIView
@property (nonatomic) float progress;

@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic) NSTimeInterval fadeOutDelay; // default 0.1

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
@implementation NJKWebViewProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureViews];
}

-(void)configureViews
{
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.bounds.size.height)];
    _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIColor *tintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0]; // iOS7 Safari bar color
    if ([UIApplication.sharedApplication.delegate.window respondsToSelector:@selector(setTintColor:)] && UIApplication.sharedApplication.delegate.window.tintColor) {
        tintColor = UIApplication.sharedApplication.delegate.window.tintColor;
    }
    _progressBarView.backgroundColor = tintColor;
    [self addSubview:_progressBarView];
    
    _barAnimationDuration = 0.27f;
    _fadeAnimationDuration = 0.27f;
    _fadeOutDelay = 0.1f;
}

-(void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _progressBarView.frame;
        frame.size.width = progress * self.bounds.size.width;
        _progressBarView.frame = frame;
    } completion:nil];
    
    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:_fadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = _progressBarView.frame;
            frame.size.width = 0;
            _progressBarView.frame = frame;
        }];
    }
    else {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 1.0;
        } completion:nil];
    }
}

@end



@interface ATBaseWebController__ () <WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@end

@implementation ATBaseWebController__

+ (instancetype)vcWithURLString:(NSString *)urlString {
    return [self vcWithURLString:urlString title:nil];
}

+ (instancetype)vcWithURLString:(NSString *)urlString title:(NSString *)title {
    ATBaseWebController__ *webView = [[self alloc] init];
    webView.urlString = urlString;
    webView.webNavTitle = title;
    return webView;
}

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.backgroundColor = [UIColor colorWithWhite:0xFA/255.0 alpha:1.0f];
    [self showNavTitle:self.webNavTitle backItem:YES];
    [self.view addSubview:self.webView];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"scrollView.contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)dealloc {
    @try {
        [self.webView removeObserver:self forKeyPath:@"title"];
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.webView removeObserver:self forKeyPath:@"scrollView.contentOffset"];
    } @catch (NSException *exception) {
        
    }
}

#pragma mark - 加载页面
- (void)setUrlString:(NSString *)urlString {
    _urlString = [urlString copy];
    
    if (urlString.length > 0) {
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString relativeToURL:[NSURL URLWithString:self.baseURLString]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        NSLog(@"准备加载：%@", request.URL.absoluteString);
    }
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    ATLog(@"开始加载：%@", webView.URL.absoluteString);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _reloadButton.hidden = YES;
    [self webViewRequestDidStart];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    ATLog(@"开始接收：%@", webView.URL.absoluteString);
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    ATLog(@"加载完成: %@",webView.URL.absoluteString);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self setNavTitle:self.webNavTitle];
    _reloadButton.hidden = YES;
    [self webViewRequestingDidEnd];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    ATLog(@"加载失败: %@",webView.URL.absoluteString);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.reloadButton.hidden = NO;
    [self webViewRequestingDidEnd];
}
// 处理拨打电话
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *scheme= navigationAction.request.URL.scheme;
    if ([scheme isEqualToString:@"sms"] || [scheme isEqualToString:@"smsto"] || [scheme isEqualToString:@"mms"] || [scheme isEqualToString:@"mmsto"] || [scheme isEqualToString:@"tel"] || [scheme isEqualToString:@"mailto"]) {
        NSURL *url = navigationAction.request.URL;
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - actions

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        [self setNavTitle:self.webNavTitle];
    }
    else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self webViewRequestDidUpdateProgress:self.webView.estimatedProgress];
    }
    else if ([keyPath isEqualToString:@"scrollView.contentOffset"]) {
        if ([change[@"new"] CGPointValue].y == 0 && [change[@"old"] CGPointValue].y != 0 && [change[@"old"] CGPointValue].y == -self.webView.scrollView.contentInset.top) {
            self.webView.scrollView.contentOffset = CGPointMake(self.webView.scrollView.contentOffset.x, -self.webView.scrollView.contentInset.top);
        }
    }
}

- (void)goBack:(BOOL)animated {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        if (self.navigationController.viewControllers.count == 1 && self.presentingViewController) {
            self.navigationItem.leftBarButtonItem = [self navItemWithImage:[UIImage imageNamed:@"nav_close"] action:@selector(goBack)];
        }
        else if (self.navigationController.viewControllers.count > 1) {
            UIBarButtonItem *fixItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixItem.width = 20;
            self.navigationItem.leftBarButtonItems = @[[self navItemWithImage:[UIImage imageNamed:@"nav_back"] action:@selector(goBack)],
                                                       fixItem,
                                                       [self navItemWithImage:[UIImage imageNamed:@"nav_close"] action:@selector(close)],
                                                       ];
        }
        else {
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.hidesBackButton = YES;
        }
        return;
    }
    
    [super goBack:animated];
}

- (void)close {
    [super goBack:YES];
}

- (void)webViewRequestDidStart {
}
- (void)webViewRequestingDidEnd {
}
- (void)webViewRequestDidUpdateProgress:(CGFloat)progress {
    self.progressView.hidden = NO;
    [self.progressView setProgress:progress animated:YES];
    ATLog(@"progressView  %.4f", progress);
}

#pragma mark - getter
- (NSString *)baseURLString {
    if (_baseURLString) {
        return _baseURLString;
    }
#ifdef ATBaseURL
    return ATBaseURL;
#endif
    return nil;
}

- (NSString *)webNavTitle {
    if (_webNavTitle) {
        return _webNavTitle;
    }
    return self.webView.title;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _webView;
}

- (UIButton *)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame = self.webView.bounds;
        [_reloadButton setTitle:@"加载失败, 点击重新加载" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_reloadButton addTarget:self.webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
        _reloadButton.hidden = YES;
        [self.view addSubview:_reloadButton];
    }
    return _reloadButton;
}

- (NJKWebViewProgressView *)progressView {
    if (!_progressView) {
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView.hidden = YES;
    }
    return _progressView;
}
@end

@interface ATBaseWebController ()<UIWebViewDelegate, UIScrollViewDelegate> {
    WKWebViewJavascriptBridge *_bridge;
};
@end

@implementation ATBaseWebController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    self.baseURLString = ATBaseURL;
    [self setUpBrige];
}

#pragma mark - jsBrige
- (void)setUpBrige {
#ifdef DEBUG // 测试环境开启打印
    [WKWebViewJavascriptBridge enableLogging];
#endif
//    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
//    [_bridge setWebViewDelegate:self];
//    [_bridge callHandler:@"bridgeInit"
//                    data:@{@"appVersion" : APP_VERSION,
//                           @"deviceId" : SafeDicObj([ATDevTool IDFAString]),
//                           @"userInfo" : SafeDicObj([[ATUserTool user] mj_keyValues]),}
//        responseCallback:^(id responseData) {
//            ATLog(@"appVersion response : %@", responseData);
//        }];
}

- (void)reloadWebView {
    [self.webView reload];
}

#pragma - mark 类方法
+ (instancetype)webViewWithURLAbsoluteString:(NSString *)urlString {
    return [self vcWithURLString:urlString];
}
+ (instancetype)webViewWithBaseUrl:(NSString *)baseUrlString urlString:(NSString *)urlString {
    ATBaseWebController *webView = [[self alloc] init];
    webView.baseURLString = baseUrlString;
    webView.urlString = urlString;
    return webView;
}
- (void)webViewRequestDidStart {
    [self webViewCustomLoadingDidStart];
}
- (void)webViewRequestingDidEnd {
    [self webViewCustomLoadingDidEnd];
}
- (void)webViewCustomLoadingDidStart {
    
}
- (void)webViewCustomLoadingDidEnd {
    
}
@end
