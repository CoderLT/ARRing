//
//  ATBaseXIBCell.m
//  AT
//
//  Created by xiao6 on 15/9/23.
//  Copyright © 2015年 AT. All rights reserved.
//

#import "ATBaseXIBCell.h"

#define NIB_NAME NSStringFromClass([self class])
const UIEdgeInsets CellSeparatorInsetsNone = {0, -4000, 0, 4000};
const UIEdgeInsets CellSeparatorInsetsDefault = {0, 15, 0, 0};
@implementation ATBaseXIBCell
- (CGFloat)cellHeight {
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
}
+ (CGFloat)cellHeight {
    return 48;
}
+ (instancetype)newForTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    ATBaseXIBCell *cell = [[NSBundle mainBundle] loadNibNamed:NIB_NAME owner:nil options:nil][0];
    // 利用KVC来设置cell复用标示符, 这样就可以不用在每个 *.xib 单独设置了。
    [cell setValue:identifier forKey:@"reuseIdentifier"];
    return cell;
}
+ (instancetype)cellForTableView:(UITableView *)tableView {
    return [self cellForTableView:tableView identifier:nil config:nil];
}
+ (instancetype)cellForTableView:(UITableView *)tableView config:(void (^)(id))config {
    return [self cellForTableView:tableView identifier:nil config:config];
}
+ (instancetype)cellForTableView:(UITableView *)tableView identifier:(NSString *)identifier config:(void(^)(id cell))config {
    if (identifier == nil) {
        identifier = NIB_NAME;
    }
    ATBaseXIBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self newForTableView:tableView identifier:identifier];
        cell.width = tableView.width;
        if (!IS_IOS7) {
            [cell layoutIfNeeded];
        }
        
        if (config) {
            config(cell);
        }
    }
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = CellSeparatorInsetsDefault;
    if ([self respondsToSelector:@selector(layoutMargins)]) {
        self.layoutMargins = UIEdgeInsetsZero;
    }
}
+ (NSString *)nibName{
    return NIB_NAME;
}
+ (void)registerToTableview:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:self.nibName bundle:nil] forCellReuseIdentifier:self.nibName];
}
@end
