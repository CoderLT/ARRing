//
//  ATBaseListViewController.h
//  AT
//
//  Created by Apple on 15/3/28.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "ATBaseController.h"
#import "ATListGroup.h"
#import "ATListCell.h"
#import "ATListCustomItem.h"

@interface ATBaseListViewController : ATBaseController

/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *dataList;

/**
 *  默认表格
 */
@property (nonatomic, strong) UITableView *tableView;

@end
