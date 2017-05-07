//
//  ATBaseRefreshCollectionController.m
//  VRBOX
//
//  Created by CoderLT on 16/3/24.
//  Copyright © 2016年 VR. All rights reserved.
//

#import "ATBaseRefreshCollectionController.h"

@interface ATBaseRefreshCollectionController ()
/**
 *  当前请求页数
 */
@property (nonatomic, assign) NSUInteger currentPage;
@end

@implementation ATBaseRefreshCollectionController
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self customRefreshOption]) {
        [self setupRefresh:self.collectionView option:[self customRefreshOption]];
    }
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
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
