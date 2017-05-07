//
//  ATPopWindowRootController.m
//  VRBOX
//
//  Created by CoderLT on 16/4/13.
//  Copyright © 2016年 VR. All rights reserved.
//

#import "ATPopWindowRootController.h"
#import <MMPopupView/MMPopupWindow.h>
#import <Aspects/Aspects.h>
#import "UIViewController+Util.h"

@interface ATPopWindowRootController ()

@end

@implementation ATPopWindowRootController
+ (void)load {
    [MMPopupWindow aspect_hookSelector:@selector(attachView)
                           withOptions:AspectPositionBefore|AspectOptionAutomaticRemoval
                            usingBlock:^(id<AspectInfo> aspectInfo) {
                                ((MMPopupWindow *)aspectInfo.instance).rootViewController = [ATPopWindowRootController new];
                            } error:nil];
}


#pragma mark - autorotate
- (UIViewController *)preferredVC {
    return [UIViewController rootTopPresentedVC];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self preferredVC] preferredStatusBarStyle];
}
- (BOOL)prefersStatusBarHidden {
    return [[self preferredVC] prefersStatusBarHidden];
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return [[self preferredVC] preferredStatusBarUpdateAnimation];
}
- (BOOL)shouldAutorotate {
    return [[self preferredVC] shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self preferredVC] supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self preferredVC] preferredInterfaceOrientationForPresentation];
}
@end
