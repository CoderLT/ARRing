//
//  ATBaseXIBCell.h
//  AT
//
//  Created by xiao6 on 15/9/23.
//  Copyright © 2015年 AT. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  cell隐藏分割线
 */
UIKIT_EXTERN const UIEdgeInsets CellSeparatorInsetsNone;
UIKIT_EXTERN const UIEdgeInsets CellSeparatorInsetsDefault;

@interface ATBaseXIBCell : UITableViewCell
+ (instancetype)newForTableView:(UITableView *)tableView identifier:(NSString *)identifier;
/**
 *  实例方法用于动态的获取cell的高度，先设置cell数据然后再得到cell高度
 */
- (CGFloat)cellHeight;
+ (CGFloat)cellHeight;

+ (NSString *)nibName;
+ (void)registerToTableview:(UITableView *)tableView;
/**
 *  用于获取cell，cell重用机制封装在方法内部，config代码块用于 cell的初始化设置
 */
+ (instancetype)cellForTableView:(UITableView *)tableView;
+ (instancetype)cellForTableView:(UITableView *)tableView config:(void(^)(id cell))config;
+ (instancetype)cellForTableView:(UITableView *)tableView identifier:(NSString *)identifier config:(void(^)(id cell))config;
@end
