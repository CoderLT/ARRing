//
//  ATListLabelArrowItem.m
//  AT
//
//  Created by Apple on 15/3/28.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "ATListLabelArrowItem.h"

@implementation ATListLabelArrowItem

+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    return [self itemWithIcon:nil title:title subTitle:subTitle destVcClass:nil];
}
+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle destVcClass:(Class)destVcClass {
    return [self itemWithIcon:nil title:title subTitle:subTitle destVcClass:destVcClass];
}
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle {
    return [self itemWithIcon:icon title:title subTitle:subTitle destVcClass:nil];
}
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle destVcClass:(Class)destVcClass {
    ATListLabelArrowItem *item = [self itemWithIcon:icon title:title destVcClass:destVcClass];
    item.subTitle = subTitle;
    return item;
}
@end
