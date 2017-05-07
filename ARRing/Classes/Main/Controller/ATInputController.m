//
//  ATInputController.m
//  LeJi
//
//  Created by CoderLT on 16/4/16.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "ATInputController.h"
#import "ATTextFieldCell.h"
#import "ATTextViewCell.h"
#import "ATColorButton.h"

@interface ATInputController ()
/**
 *  页面标题
 */
@property (nonatomic, copy) NSString *vcTitle;
/**
 *  默认文本
 */
@property (nonatomic, copy) NSString *content;
/**
 *  提示信息
 */
@property (nonatomic, copy) NSString *placeHolder;
/**
 *  键盘设置
 */
@property (nonatomic, assign) UIKeyboardType keyboardType;
/**
 *  输入回调
 */
@property (nonatomic, copy) NSUInteger(^textDidChange)(NSString *text, UIButton *button);
/**
 *  完成按钮
 */
@property (nonatomic, strong) UIButton *button;

@end

@implementation ATInputController
+ (instancetype)vcWithTitle:(NSString *)title content:(NSString *)content placeholder:(NSString *)placeHolder keyboardType:(UIKeyboardType)keyboardType textDidChange:(NSUInteger (^)(NSString *, UIButton *))textDidChange completion:(void (^)(NSString *))completion {
    ATInputController *vc = [[self alloc] init];
    vc.vcTitle = title;
    vc.content = content;
    vc.placeHolder = placeHolder;
    vc.keyboardType = keyboardType;
    vc.textDidChange = textDidChange;
    vc.completion = completion;
    return vc;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    ATTextCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [([self isTextView] ? ((ATTextViewCell *)cell).textView : ((ATTextFieldCell *)cell).textField) becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题和返回按钮
    [self showNavTitle:self.vcTitle andBackItem:YES];
    
    // 设置表格不要分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 初始化底部确认按钮
    [self initFooter];
    
    if (self.textDidChange) {
        self.textDidChange(self.content, self.button);
    }
}

- (void)initFooter {
    self.tableView.tableFooterView = ({
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        [footer addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.insets(UIEdgeInsetsMake(15, 15, 0, 15));
            make.height.equalTo(@(44));
        }];
        footer;
    });
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self isTextView] ? [ATTextViewCell cellHeight] : [ATTextFieldCell cellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    ATTextCell *cell = [self isTextView] ? [ATTextViewCell cellForTableView:tableView config:^(ATTextViewCell *cell) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        cell.textView.placeholder = strongSelf.placeHolder;
        cell.textView.text = strongSelf.content;
        cell.textView.keyboardType = strongSelf.keyboardType;
        cell.textView.font = ATTitleFont;
        cell.textView.backgroundColor = [UIColor whiteColor];
        cell.textView.layer.borderColor = TableViewSeparatorColor.CGColor;
        cell.textView.layer.borderWidth = 1;
        cell.textView.layer.cornerRadius = 2;
        cell.textView.clipsToBounds = YES;
        cell.textView.textContainerInset = UIEdgeInsetsMake(8, 4, 8, 4);
        cell.backgroundColor = [UIColor clearColor];
    }] : [ATTextFieldCell cellForTableView:tableView config:^(ATTextFieldCell *cell) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        cell.textField.placeholder = strongSelf.placeHolder;
        cell.textField.text = strongSelf.content;
        cell.textField.keyboardType = strongSelf.keyboardType;
        cell.textField.layer.borderColor = TableViewSeparatorColor.CGColor;
        cell.textField.layer.borderWidth = 1;
        cell.textField.layer.cornerRadius = 2;
        cell.textField.clipsToBounds = YES;
        cell.textField.inset = UIEdgeInsetsMake(0, 8, 0, 8);
        cell.textField.font = ATTitleFont;
        cell.textField.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
    }];
    // 设置输入改变时回调
    [cell setTextDidChange:^NSUInteger(ATTextCell *cell, NSString *text) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.textDidChange) {
            return strongSelf.textDidChange(text, strongSelf.button);
        }
        return NSUIntegerMax;
    }];
    return cell;
}

#pragma mark - actions
- (BOOL)isTextView {
    return [self isKindOfClass:[ATInputTextViewController class]];
}
- (void)didClickButton:(UIButton *)button {
    [self.view endEditing:YES];
    if (self.completion) {
        ATTextCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.completion([self isTextView] ? ((ATTextViewCell *)cell).textView.text : ((ATTextFieldCell *)cell).textField.text);
        self.completion = nil;
    }
    [self goBack];
}

#pragma mark - getter
- (UIButton *)button {
    if (!_button) {
        _button = [ATAppButton buttonWithFrame:CGRectMake(15, 15, self.view.width - 15, 44) target:self action:@selector(didClickButton:)];
        [_button setTitle:ATLocalizedString(@"Confirm", @"确认") forState:UIControlStateNormal];
    }
    return _button;
}

@end

@implementation ATInputTextViewController

@end
