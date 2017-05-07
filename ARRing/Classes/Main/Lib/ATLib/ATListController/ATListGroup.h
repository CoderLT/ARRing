//
//  ATListGroup.h
//  AT
//
//  Created by Apple on 15/3/28.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATListItem.h"

@interface ATListGroup : NSObject

/**
 *  头部
 */
@property (nonatomic, copy) NSString *header;
/**
 *  尾部
 */
@property (nonatomic, copy) NSString *footer;
/**
 *  头部高度
 */
@property (nonatomic, assign) CGFloat headerHeight;
/**
 *  底部高度
 */
@property (nonatomic, assign) CGFloat footerHeight;
/**
 *  模型数组(存放的都是ATListItem(或其子类)对象)
 */
@property (nonatomic, copy) NSArray<ATListItem *> *items;

+ (instancetype)groupWithItems:(NSArray<ATListItem *> *)items;
@end
