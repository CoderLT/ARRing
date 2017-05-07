//
//  ATCLoneView.m
//  VRBOX
//
//  Created by CoderLT on 16/3/14.
//  Copyright © 2016年 VR. All rights reserved.
//

#import "ATCLoneView.h"
#import <Aspects/Aspects.h>

@implementation ATCLoneView
+ (instancetype)viewWithSrc:(UIView *)srcView {
    ATCLoneView *cloneView = [[[srcView class] alloc] initWithFrame:srcView.frame];
    NSArray<NSString *> *keyPaths = @[@"clipsToBounds", @"contentMode", @"fps", @"scaleFactor", @"shouldShowHudView"];
    for (NSString *keyPath in keyPaths) {
        [cloneView setValue:[srcView valueForKeyPath:keyPath] forKeyPath:keyPath];
    }
    __weak typeof(cloneView) weakSelf = cloneView;
    [srcView aspect_hookSelector:NSSelectorFromString(@"display:")
                      withOptions:AspectPositionAfter
                       usingBlock:^(id<AspectInfo> aspectInfo) {
                           __strong typeof(weakSelf) strongSelf = weakSelf;
                           NSInvocation *invocation = [aspectInfo originalInvocation];
                           SEL originalSelector = invocation.selector;
                           SEL aliasSelector = NSSelectorFromString(@"display:");
                           invocation.selector = aliasSelector;
                           [invocation invokeWithTarget:strongSelf];
                           invocation.selector = originalSelector;
                       }
                            error:nil];
    return cloneView;
}
@end
