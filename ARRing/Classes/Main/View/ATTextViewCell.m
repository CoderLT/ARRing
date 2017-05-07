//
//  ATTextViewCell.m
//  AT
//
//  Created by CoderLT on 15/10/7.
//  Copyright © 2015年 AT. All rights reserved.
//

#import "ATTextViewCell.h"

@implementation ATTextViewCell

+ (CGFloat)cellHeight {
    return 140;
}

+ (instancetype)cellForTableView:(UITableView *)tableView identifier:(NSString *)identifier config:(void (^)(id))config {
    return [super cellForTableView:tableView identifier:identifier config:^(ATTextViewCell *cell) {
        cell.separatorInset = CellSeparatorInsetsDefault;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.font = ATTitleFont;
        cell.textView.textColor = ATTitleColor;
        if (config) {
            config(cell);
        }
    }];
}

@end
