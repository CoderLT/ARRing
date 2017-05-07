//
//  ATListArrowItem.m
//  AT
//
//  Created by Apple on 15/3/28.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "ATListArrowItem.h"

@implementation ATListArrowItem

+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass {
    return [self itemWithIcon:nil title:title destVcClass:destVcClass];
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass
{
    ATListArrowItem *item = [self itemWithIcon:icon title:title];
    item.destClass = destVcClass;
    return item;
}
@end
