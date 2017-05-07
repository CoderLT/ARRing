//
//  ATBaseController.h
//  AT
//
//  Created by Apple on 14-8-3.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADTransitionController.h"
#import "ATTextView.h"
#import "MBProgressHUD+Add.h"
#import "MJRefresh.h"
#import "NSDate+Util.h"
#import "NSString+Message.h"
#import "UIButton+Util.h"
#import "UIColor+Util.h"
#import "UILabel+Util.h"
#import "UIView+Common.h"
#import "UIViewController+Util.h"
#import "ATBaseXIBCell.h"
#import "ATHttpTool.h"

@interface ATBaseController : ADTransitioningViewController

/**
 *  集成刷新控件
 */
typedef NS_ENUM(NSUInteger, ATRefreshOption) {
    ATRefreshNone = 0,
    ATHeaderRefresh = 1 << 0,
    ATFooterRefresh = 1 << 1,
    ATHeaderAutoRefresh = 1 << 2,
    ATFooterAutoRefresh = 1 << 3,
    ATFooterDefaultHidden = 1 << 4,
    ATHeaderAutoRefreshVisible = 1 << 5,
    ATFooterAutoRefreshVisible = 1 << 6,
    ATRefreshDefault = (ATHeaderRefresh | ATHeaderAutoRefresh | ATFooterRefresh | ATFooterDefaultHidden),
};
- (void)setupRefresh:(UIScrollView *)tableView option:(ATRefreshOption)option;
- (void)headerRefreshing;
- (void)footerRefreshing;
- (void)setupRefresh:(UIScrollView *)tableView defaultImage:(UIImage *)image message:(NSString *)message hiddenFooter:(BOOL)hidden;
- (void)setupRefresh:(UIScrollView *)tableView defaultImage:(UIImage *)image message:(NSString *)message hiddenFooter:(BOOL)hidden noMoreData:(BOOL)noMore;
- (void)notifyTableView:(UITableView *)tableView defaultImage:(UIImage *)image message:(NSString *)message hidden:(BOOL)hidden;

/**
 *  显示网络状态
 */
- (void)notifyNetWorkInView:(UIView *)view;

/**
 *  显示标题和返回按钮
 */
- (void)showNavTitle:(NSString *)title andBackItem:(BOOL)isShow;
+ (void)showVC:(UIViewController *)vc navTitle:(NSString *)title andBackItem:(BOOL)isShow;

/**
 *  获取根控制器
 */
+ (UINavigationController *)rootNavController;

- (void)showNavMenu;
- (void)hideMenu;
#pragma mark - 屏幕旋转实现
+ (UIStatusBarStyle)preferredStatusBarStyle;
+ (BOOL)prefersStatusBarHidden;
+ (UIStatusBarAnimation)preferredStatusBarUpdateAnimation;
+ (BOOL)shouldAutorotate;
+ (UIInterfaceOrientationMask)supportedInterfaceOrientations;
+ (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;

#define ATAutoRotateImplementation \
- (UIStatusBarStyle)preferredStatusBarStyle { \
    return [ATBaseController preferredStatusBarStyle];\
}\
- (BOOL)prefersStatusBarHidden {\
    return [ATBaseController prefersStatusBarHidden];\
}\
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {\
    return [ATBaseController preferredStatusBarUpdateAnimation];\
}\
- (BOOL)shouldAutorotate {\
    return [ATBaseController shouldAutorotate];\
}\
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {\
    return [ATBaseController supportedInterfaceOrientations];\
}\
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {\
    return [ATBaseController preferredInterfaceOrientationForPresentation];\
}

@end
