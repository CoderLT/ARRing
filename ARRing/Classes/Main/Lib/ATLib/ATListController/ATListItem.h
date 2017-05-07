//
//  ATListItem.h
//  AT
//
//  Created by Apple on 15/3/28.
//  Copyright (c) 2015年 Summer. All rights reserved.
//  普通样式cell的基本模型(左侧图标+文字或者单文字,右侧箭头或者label或者其它)

#import <Foundation/Foundation.h>

@class ATListItem;
@protocol ATListCellProtocol <NSObject>

@required
/**
 *  cell的模型
 */
@property (nonatomic, strong) ATListItem *item;

+ (instancetype)cellForTableView:(UITableView *)tableView;

@end


typedef void(^ATListItemOption)(id item, id<ATListCellProtocol> cell);

@interface ATListItem : NSObject

/**
 *  高度
 */
@property (nonatomic, assign) CGFloat height;
/**
 *  图标名字
 */
@property (nonatomic, copy) NSString *icon;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSAttributedString *attrTitle;

/**
 *  点击cell的时候要做的事情
 */
@property (nonatomic, copy) ATListItemOption option;

/**
 *  更新cell前要做的事
 */
@property (nonatomic, copy) ATListItemOption updateOption;

/**
 *  自定义cell样式
 */
@property (nonatomic, copy) ATListItemOption config;

+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;

- (void)setRequired;
@end