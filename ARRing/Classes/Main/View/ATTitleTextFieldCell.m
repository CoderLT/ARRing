//
//  ATTitleTextFieldCell.m
//  AT
//
//  Created by xiao6 on 15/10/24.
//  Copyright © 2015年 AT. All rights reserved.
//

#import "ATTitleTextFieldCell.h"

@implementation ATTitleTextFieldCell

+ (CGFloat)cellHeight {
    return 53;
}

+ (instancetype)cellForTableView:(UITableView *)tableView identifier:(NSString *)identifier config:(void (^)(id))config {
    return [super cellForTableView:tableView identifier:identifier config:^(ATTitleTextFieldCell *cell) {
        cell.separatorInset = CellSeparatorInsetsDefault;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.textField.font = ATTitleFont;
        cell.textField.textColor = ATTitleColor;
        if (config) {
            config(cell);
        }
    }];
}

@end
