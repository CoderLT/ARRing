//
//  ATRefreshWebController.m
//  Yami
//
//  Created by CoderLT on 16/8/2.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATRefreshWebController.h"

@interface ATRefreshWebController ()
{
    
}

@end

@implementation ATRefreshWebController
+ (instancetype)vcWithURLString:(NSString *)urlString title:(NSString *)title {
    ATRefreshWebController *vc = [[self alloc] init];
    vc.baseURLString = ATBaseURL;
    vc.urlString = urlString;
    vc.navTitle2 = title;
    return vc;
}
- (void)setNavTitle:(NSString *)title {
    [super setNavTitle:self.navTitle2 ?: title];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self reloadWebView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavTitle:self.navTitle2 andBackItem:YES];
    [self setupRefresh:self.webView.scrollView option:ATHeaderRefresh];
}
- (void)headerRefreshing {
    [super headerRefreshing];
    [self.webView.scrollView.mj_header endRefreshing];
    [self reloadWebView];
}
- (void)webViewCustomLoadingDidStart {
    
}
- (void)webViewCustomLoadingDidEnd {
    
}
@end
