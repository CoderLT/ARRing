//
//  ATBaseRefreshCollectionController.h
//  VRBOX
//
//  Created by CoderLT on 16/3/24.
//  Copyright © 2016年 VR. All rights reserved.
//

#import "ATBaseCollectionController.h"

@interface ATBaseRefreshCollectionController : ATBaseCollectionController

/**
 *  业务数据
 */
@property (nonatomic, strong) NSMutableArray *dataList;

/**
 *  刷新控件配置, 由子类重载, 默认 ATRefreshDefault
 */
- (ATRefreshOption)customRefreshOption;
/**
 *  刷新数据, page从 ATAPI_STARTPAGE 开始
 */
- (void)refreshData:(NSUInteger)page;
@end
