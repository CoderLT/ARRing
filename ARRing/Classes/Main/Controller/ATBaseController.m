//
//  ATBaseController.m
//  AT
//
//  Created by Apple on 14-8-3.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "ATBaseController.h"
#import "ATNoDataView.h"
//#import <REFrostedViewController/REFrostedViewController.h>

@interface ATBaseController ()
{
    UIImageView *networkImageView;
    BOOL _noMoreData;
    BOOL _showMenuItem;
}
@end

@implementation ATBaseController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self updateMenuUnreadMessageCount];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_COLOR_BG;
}
- (void)showNavTitle:(NSString *)title andBackItem:(BOOL)isShow {
    [ATBaseController showVC:self navTitle:title andBackItem:isShow];
}
+ (void)showVC:(UIViewController *)vc navTitle:(NSString *)title andBackItem:(BOOL)isShow {
    vc.navigationController.navigationBarHidden = NO;
    [vc setNavTitle:title];
    if (isShow && vc.navigationController.viewControllers.count == 1 && vc.presentingViewController) {
        vc.navigationItem.leftBarButtonItem = [vc navItemWithImage:[UIImage imageNamed:@"nav_close"] action:@selector(goBack)];
    }
    else if (isShow && (vc.navigationController.viewControllers.count > 1 || (!vc.navigationController && !vc.parentViewController))) {
        vc.navigationItem.leftBarButtonItem = [vc navItemWithImage:[UIImage imageNamed:@"nav_back"] action:@selector(goBack)];
    }
    else {
        vc.navigationItem.leftBarButtonItem = nil;
        vc.navigationItem.hidesBackButton = YES;
    }
}

//- (void)showNavMenu {
//    _showMenuItem = YES;
//    self.navigationItem.leftBarButtonItem = [self navItemWithImage:[UIImage imageNamed:@"nav_menu"] action:@selector(didClickMenu)];
//}
//- (void)didClickMenu {
//    [self.sideMenuViewController presentLeftMenuViewController];
//}
////- (void)updateMenuUnreadMessageCount {
////    if (_showMenuItem) {
////        [self.navigationItem.leftBarButtonItem.customView showBadge:[ATRCIMTool unreadMessageCount] withOffset:CGPointMake(6, -4)];
////    }
////}
//- (void)hideMenu {
//    [self.sideMenuViewController hideMenuViewController];
//}
#pragma mark - 集成刷新控件
/**
 *  集成刷新控件
 */
- (void)setupRefresh:(UIScrollView *)tableView option:(ATRefreshOption)option
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    if (option & ATHeaderRefresh) {
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
        tableView.mj_header.automaticallyChangeAlpha = YES;
        ((MJRefreshNormalHeader *)tableView.mj_header).lastUpdatedTimeLabel.hidden = YES;
        [((MJRefreshNormalHeader *)tableView.mj_header) setTitle:ATLocalizedString(@"Drop-down to refresh", @"下拉可以刷新") forState:MJRefreshStateIdle];
        [((MJRefreshNormalHeader *)tableView.mj_header) setTitle:ATLocalizedString(@"Undo immediate refresh", @"松开立即刷新") forState:MJRefreshStatePulling];
        [((MJRefreshNormalHeader *)tableView.mj_header) setTitle:ATLocalizedString(@"Refreshing data...", @"正在刷新数据中...") forState:MJRefreshStateRefreshing];
        //自动刷新(一进入程序就下拉刷新)
        if (option & ATHeaderAutoRefresh) {
            [self headerRefreshing];
        }
        else if (option & ATHeaderAutoRefreshVisible) {
            [tableView.mj_header beginRefreshing];
        }
    }
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    if (option & ATFooterRefresh) {
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
        [((MJRefreshAutoNormalFooter *)tableView.mj_footer) setTitle:ATLocalizedString(@"Click or pull up to load more", @"点击或上拉加载更多") forState:MJRefreshStateIdle];
        [((MJRefreshAutoNormalFooter *)tableView.mj_footer) setTitle:ATLocalizedString(@"Loading more data...", @"正在加载更多的数据...") forState:MJRefreshStateRefreshing];
        [((MJRefreshAutoNormalFooter *)tableView.mj_footer) setTitle:ATLocalizedString(@"Have all loaded", @"已经全部加载完毕") forState:MJRefreshStateNoMoreData];
        
        if (option & ATFooterAutoRefresh) {
            [self footerRefreshing];
        }
        else if (option & ATFooterAutoRefreshVisible) {
            [tableView.mj_footer beginRefreshing];
        }
        else if (option & ATFooterDefaultHidden) {
            tableView.mj_footer.hidden = YES;
        }
    }
}

- (void)headerRefreshing
{
    ATLog(@"下拉刷新,开始刷新数据");
}

- (void)footerRefreshing
{
    ATLog(@"上拉加载,开始加载数据");
}
- (void)setupRefresh:(UIScrollView *)scrollView defaultImage:(UIImage *)image message:(NSString *)message hiddenFooter:(BOOL)hidden {
    [self setupRefresh:scrollView defaultImage:image message:message hiddenFooter:hidden noMoreData:_noMoreData];
}
- (void)setupRefresh:(UIScrollView *)scrollView defaultImage:(UIImage *)image message:(NSString *)message hiddenFooter:(BOOL)hidden noMoreData:(BOOL)noMore
{
    _noMoreData = noMore;
    if (hidden) {
        scrollView.mj_footer.hidden = NO;
        scrollView.mj_footer.state = MJRefreshStateIdle;
        if (noMore) {
            if (scrollView.contentSize.height > scrollView.height) {
                scrollView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            else {
                scrollView.mj_footer.hidden = YES;
            }
        }
    }
    [self notifyTableView:(UITableView *)scrollView defaultImage:image message:message hidden:hidden];
    
    if (scrollView.mj_header.isRefreshing) {
        [scrollView.mj_header endRefreshing];
    }
    if (scrollView.mj_footer.isRefreshing) {
        [scrollView.mj_footer endRefreshing];
    }
}
- (void)notifyTableView:(UITableView *)tableView defaultImage:(UIImage *)image message:(NSString *)message hidden:(BOOL)hidden {
#define notifyTableViewTag 23197214
    if ([tableView isKindOfClass:[UITableView class]]) {
        tableView.tableFooterView = [UIView new];
    }
    else {
        [[tableView viewWithTag:notifyTableViewTag] removeFromSuperview];
    }
    if (hidden) {
        return;
    }
    
    if (![ATHttpTool reachable]) {
        UIImage *noNetwork = [UIImage imageNamed:@"defaultNoNetwork"];
        image = noNetwork ?: image;
        message = noNetwork ? ATLocalizedString(@"Currently no network connection", @"当前无网络") : message;
    }
    ATNoDataView * noData = [[ATNoDataView alloc] init];
    noData.tag = notifyTableViewTag;
    noData.frame = CGRectMake(0, 0, tableView.width,
                              (tableView.height - ([tableView isKindOfClass:[UITableView class]] ? tableView.tableHeaderView.height : 0) - tableView.contentInset.top) * 0.8);
    noData.imageView.image = image;
    noData.descLabel.text = message;
    if ([tableView isKindOfClass:[UITableView class]]) {
        tableView.tableFooterView = noData;
    }
    else {
        [tableView addSubview:noData];
    }
}
- (void)notifyNetWorkInView:(UIView *)view
{
    if (networkImageView) {
        [networkImageView removeFromSuperview];
        networkImageView = nil;
    }
    if (![ATHttpTool reachable]) {
        if (!networkImageView) {
            networkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noNetwork"]];
            networkImageView.clipsToBounds = YES;
            networkImageView.contentMode = UIViewContentModeCenter;
        }
        networkImageView.frame = self.view.bounds;
        [view addSubview:networkImageView];
        [view sendSubviewToBack:networkImageView];
    }
}

//+ (UINavigationController *)rootNavController {
//    return ((RESideMenu *)[[[UIApplication sharedApplication] delegate] window].rootViewController).contentViewController.topPresentedVC;
//}

#pragma mark - 屏幕旋转实现

ATAutoRotateImplementation
+ (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
+ (BOOL)prefersStatusBarHidden {
    return NO;
}
+ (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}
+ (BOOL)shouldAutorotate {
    return YES;
}
+ (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
+ (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
@end
