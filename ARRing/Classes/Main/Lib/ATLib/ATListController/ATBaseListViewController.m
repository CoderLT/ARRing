//
//  ATBaseListViewController.m
//  AT
//
//  Created by Apple on 15/3/28.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "ATBaseListViewController.h"

@interface ATBaseListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ATBaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
}

- (void)initTableView {
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorColor:[UIColor colorWithHexString:@"E8E8E8"]];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    CGFloat bottomInset = 0;
    if (self.tabBarController.tabBar.hidden == NO && self.hidesBottomBarWhenPushed == NO) {
        bottomInset = CGRectGetHeight(self.tabBarController.tabBar.bounds);
    }
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottomInset, 0);
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ATListGroup *group = self.dataList[section];
    return group.items.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATListGroup *group = self.dataList[indexPath.section];
    ATListItem *item = group.items[indexPath.row];
    return item.height ?: 48;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ATListGroup *group = self.dataList[section];
    return group.headerHeight ?: (section == 0 ? 20.0f : 10.0f);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ATListGroup *group = self.dataList[section];
    return group.footerHeight ?: ((section == self.dataList.count - 1 && !self.tableView.tableFooterView) ? 20.0f : 0.01f);
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ATListGroup *group = self.dataList[section];
    return group.header;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    ATListGroup *group = self.dataList[section];
    return group.footer;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATListGroup *group = self.dataList[indexPath.section];
    ATListItem  *item = group.items[indexPath.row];
    if ([item isKindOfClass:[ATListCustomItem class]]) {
        ATListCustomItem *customItem = (ATListCustomItem *)item;
        UITableViewCell<ATListCellProtocol> *cell = [customItem.cellClass cellForTableView:tableView];
        if (item.updateOption) {
            item.updateOption(item, cell);
        }
        if ([cell respondsToSelector:@selector(setItem:)]) {
            [cell setItem:customItem];
        }
        if (customItem.config) {
            customItem.config(customItem, cell);
        }
        return cell;
    }
    else {
        ATListCell *cell = [ATListCell cellForTableView:tableView];
        if (item.updateOption) {
            item.updateOption(item, cell);
        }
        cell.item = item;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ATListGroup *group = self.dataList[indexPath.section];
    ATListItem  *item = group.items[indexPath.row];
    
    if (item.option) {
        item.option(item, [tableView cellForRowAtIndexPath:indexPath]);
    }
    else if ([item respondsToSelector:@selector(destClass)]) {
        Class destClass = [item performSelector:@selector(destClass)];
        if (destClass) {
            UIViewController *vc = [[destClass alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - getter
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
