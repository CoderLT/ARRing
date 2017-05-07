//
//  ATPickerView.h
//  CengFanQu
//
//  Created by CoderLT on 16/2/24.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATSheetView.h"

typedef void(^ATPickerViewCompletion)(BOOL comfirm, NSUInteger selectedIndex, NSString *selectedData);
@interface ATPickerView : ATSheetView

/**
 *  显示一个挑选器
 *
 *  @param title            标题
 *  @param dataList         元素数组
 *  @param selectedIndex    选中的编号(从0开始)
 *  @param completion       完成时回调(comfirm: 是否点击了确定, selectedIndex: 选中的编号(从0开始), selectedTitle: 选中的标题)
 *
 *  @return                 挑选器实例
 */
+ (instancetype)showWithTitle:(NSString *)title
                     dataList:(NSArray<NSString *> *)dataList
                selectedIndex:(NSUInteger)selectedIndex
                    completion:(ATPickerViewCompletion)completion;
@end