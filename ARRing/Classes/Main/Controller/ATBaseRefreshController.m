//
//  ATBaseRefreshController.m
//  CengFanQu
//
//  Created by CoderLT on 16/2/25.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATBaseRefreshController.h"

@interface ATBaseRefreshController ()
@end

@implementation ATBaseRefreshController
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self customRefreshOption]) {
        [self setupRefresh:self.tableView option:[self customRefreshOption]];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

#pragma mark - 集成刷新控件
- (ATRefreshOption)customRefreshOption {
    return ATRefreshDefault;
}
- (void)headerRefreshing {
    [super headerRefreshing];
    self.currentPage = ATAPI_STARTPAGE;
    [self refreshData:self.currentPage];
}
- (void)footerRefreshing {
    [super footerRefreshing];
    self.currentPage++;
    [self refreshData:self.currentPage];
}
- (void)refreshData:(NSUInteger)page {
    
}

#pragma mark - getter
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
