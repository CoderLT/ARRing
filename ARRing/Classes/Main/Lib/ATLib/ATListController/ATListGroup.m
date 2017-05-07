//
//  ATListGroup.m
//  AT
//
//  Created by Apple on 15/3/28.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "ATListGroup.h"

@implementation ATListGroup


+ (instancetype)groupWithItems:(NSArray<ATListItem *> *)items {
    ATListGroup *group = [[self alloc] init];
    group.items = items;
    return group;
}


@end
