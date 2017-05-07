//
//  ATListSwitchItem.m
//  NoPi
//
//  Created by CoderLT on 15/10/10.
//  Copyright © 2015年 nopi.com. All rights reserved.
//

#import "ATListSwitchItem.h"

@implementation ATListSwitchItem

+ (instancetype)itemWithTitle:(NSString *)title on:(BOOL)on {
    return [self itemWithIcon:nil title:title on:on];
}
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title on:(BOOL)on {
    ATListSwitchItem *item = [self itemWithIcon:icon title:title];
    item.on = on;
    return item;
}
@end
