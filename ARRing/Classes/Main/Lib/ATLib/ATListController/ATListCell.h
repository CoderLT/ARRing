//
//  ATListCell.h
//  AT
//
//  Created by Apple on 15/3/28.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATListArrowItem.h"
#import "ATListLabelArrowItem.h"
#import "ATListSwitchItem.h"
#import "ATListImageArrowtem.h"

@interface ATListCell : UITableViewCell <ATListCellProtocol>

/**
 *  cell的模型
 */
@property (nonatomic, strong) ATListItem *item;

+ (instancetype)cellForTableView:(UITableView *)tableView;

@end
