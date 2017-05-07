//
//  ATBaseRefreshController.h
//  CengFanQu
//
//  Created by CoderLT on 16/2/25.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATBaseTableViewController.h"

@interface ATBaseRefreshController : ATBaseTableViewController
/**
 *  业务数据
 */
@property (nonatomic, strong) NSMutableArray *dataList;
/**
 *  当前请求页数
 */
@property (nonatomic, assign) NSUInteger currentPage;

/**
 *  刷新控件配置, 由子类重载, 默认 ATRefreshDefault
 */
- (ATRefreshOption)customRefreshOption;
/**
 *  刷新数据, page从0开始
 */
- (void)refreshData:(NSUInteger)page;
@end
