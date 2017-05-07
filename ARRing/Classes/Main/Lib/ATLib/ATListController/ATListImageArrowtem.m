//
//  ATListImageArrowtem.m
//  CengFanQu
//
//  Created by CoderLT on 16/2/20.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATListImageArrowtem.h"

@implementation ATListImageArrowtem
+ (instancetype)itemWithTitle:(NSString *)title rightIcon:(NSString *)rightIcon {
    return [self itemWithIcon:nil title:title rightIcon:rightIcon destVcClass:nil];
}
+ (instancetype)itemWithTitle:(NSString *)title rightIcon:(NSString *)rightIcon destVcClass:(Class)destVcClass {
    return [self itemWithIcon:nil title:title rightIcon:rightIcon destVcClass:destVcClass];
}
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title rightIcon:(NSString *)rightIcon {
    return [self itemWithIcon:icon title:title rightIcon:rightIcon destVcClass:nil];
}
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title rightIcon:(NSString *)rightIcon destVcClass:(Class)destVcClass {
    ATListImageArrowtem *item = [self itemWithIcon:icon title:title destVcClass:destVcClass];
    item.rightIcon = rightIcon;
    return item;
}
@end
