//
//  ATTextFieldCell.m
//  AT
//
//  Created by CoderLT on 15/10/7.
//  Copyright © 2015年 AT. All rights reserved.
//

#import "ATTextFieldCell.h"

@implementation ATTextFieldCell
+ (instancetype)cellForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    return [self cellForTableView:tableView
                       identifier:[NSString stringWithFormat:@"%@-%d-%d", NSStringFromClass(self), (int)indexPath.section, (int)indexPath.row]
                           config:nil];
}
+ (instancetype)newForTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    ATTextFieldCell *cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    ATTextField *textFiled = [[ATTextField alloc] init];
    [cell.contentView addSubview:textFiled];
    [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(textFiled.superview).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    cell.textField = textFiled;
    return cell;
}
+ (instancetype)cellForTableView:(UITableView *)tableView identifier:(NSString *)identifier config:(void (^)(id))config {
    return [super cellForTableView:tableView identifier:identifier config:^(ATTextFieldCell *cell) {
        cell.separatorInset = CellSeparatorInsetsDefault;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.textField.textColor     = ATTitleColor;
        cell.textField.font          = ATTitleFont;
        if (config) {
            config(cell);
        }
    }];
}
@end
