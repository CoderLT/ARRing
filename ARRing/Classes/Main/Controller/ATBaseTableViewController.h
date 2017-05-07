//
//  ATBaseTableViewController.h
//  CengFanQu
//
//  Created by CoderLT on 16/2/22.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATBaseController.h"

@interface ATBaseTableViewController : ATBaseController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}
@property (nonatomic, strong) UITableView *tableView;
@end
