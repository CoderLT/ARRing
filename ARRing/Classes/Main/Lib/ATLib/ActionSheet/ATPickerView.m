//
//  ATPickerView.m
//  CengFanQu
//
//  Created by CoderLT on 16/2/24.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATPickerView.h"

@interface ATPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
/**
 *  选择器
 */
@property (nonatomic, strong) UIPickerView *picker;

/**
 *  元素数组
 */
@property (nonatomic, strong) NSArray<NSString *> *dataList;

@end

@implementation ATPickerView
+ (instancetype)showWithTitle:(NSString *)title dataList:(NSArray<NSString *> *)dataList selectedIndex:(NSUInteger)selectedIndex completion:(ATPickerViewCompletion)completion {
    ATPickerView *pickerView = [[self alloc] initWithTitle:title];
    pickerView.dataList = dataList;
    __weak typeof(pickerView) weakSelf = pickerView;
    [pickerView setDismissCompletion:^(ATSheetView *sheet, BOOL confirm) {
        if (completion) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSUInteger selectedIndex = [strongSelf.picker selectedRowInComponent:0];
            completion(confirm, selectedIndex, (selectedIndex < strongSelf.dataList.count) ? strongSelf.dataList[selectedIndex] : nil);
        }
    }];
    [pickerView show];
    [pickerView.picker reloadAllComponents];
    [pickerView.picker selectRow:selectedIndex inComponent:0 animated:NO];
    return pickerView;
}

#pragma mark - delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataList.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.width;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataList[row];
}

#pragma mark - getter
- (UIPickerView *)picker {
    if (!_picker) {
        _picker = [[UIPickerView alloc] init];
        _picker.delegate = self;
        _picker.dataSource = self;
        [self.contentView addSubview:_picker];
        [_picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_picker.superview);
            make.height.equalTo(@(217));
        }];
    }
    return _picker;
}
@end
