//
//  ATNavigationViewController.m
//  CengFanQu
//
//  Created by Apple on 14-8-11.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "ATNavigationViewController.h"
#import "ADNavigationControllerDelegate.h"
#import "ATBaseController.h"

@interface ATNavigationViewController (){
    ADNavigationControllerDelegate * _navigationDelegate;
}
@end

@implementation ATNavigationViewController
#pragma mark 一个类只会调用一次
+ (void)initialize
{
    // 设置导航栏背景颜色\文字颜色
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barStyle = UIBarStyleDefault;
    navBar.tintColor = APP_NavTitleColor;
    navBar.barTintColor = APP_NavTitleColor;
    [navBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : APP_NavTitleColor, NSFontAttributeName : ATHeaderFont}];
    
    // 设置按钮文字颜色
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{ NSForegroundColorAttributeName : APP_NavTitleColor, NSFontAttributeName : ATTitleFont}
                        forState:UIControlStateNormal];
    
    [navBar setBackgroundImage:[UIImage imageWithColor:[APP_NavBgColor colorWithAlphaComponent:0.99]] forBarMetrics:UIBarMetricsDefault];
//    [navBar setShadowImage:UIImage.new];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        _navigationDelegate = [[ADNavigationControllerDelegate alloc] init];
        self.delegate = _navigationDelegate;
    }
    return self;
}

#pragma mark 控制状态栏的样式
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
    [self setTabbarHidden:YES animated:animated withViewController:viewController];
}
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        obj.hidesBottomBarWhenPushed = (idx != 0);
    }];
    [super setViewControllers:viewControllers animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    [self setTabbarHidden:NO animated:animated withViewController:viewController];
    return viewController;
}
- (void)setTabbarHidden:(BOOL)hidden animated:(BOOL)animated withViewController:(UIViewController *)viewController {
//    if (!animated
//        || !(viewController.hidesBottomBarWhenPushed)
//        || ![viewController isKindOfClass:[ATBaseController class]]) {
//        return;
//    }
//    CGFloat duration = ((ATBaseController *)viewController).transition.duration;
//    if (hidden && (duration > 0 && self.tabBarController.tabBar.left == 0)) {
//        [UIView animateWithDuration:duration animations:^{
//            self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(self.tabBarController.tabBar.width, self.tabBarController.tabBar.height);
//        } completion:^(BOOL finished) {
//            self.tabBarController.tabBar.transform = CGAffineTransformIdentity;
//        }];
//    }
//    else if (!hidden && (duration > 0 && self.tabBarController.tabBar.right == 0)) {
//        self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(self.tabBarController.tabBar.width, self.tabBarController.tabBar.height);
//        [UIView animateWithDuration:duration animations:^{
//            self.tabBarController.tabBar.transform = CGAffineTransformIdentity;
//        }];
//    }
}

#pragma mark - autorotate
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self.viewControllers lastObject] preferredStatusBarStyle];
}
- (BOOL)prefersStatusBarHidden {
    return [[self.viewControllers lastObject] prefersStatusBarHidden];
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return [[self.viewControllers lastObject] preferredStatusBarUpdateAnimation];
}
- (BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
@end
