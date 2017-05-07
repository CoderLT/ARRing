//
//  ATListCell.m
//  AT
//
//  Created by Apple on 15/3/28.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "ATListCell.h"

@interface ATListCell()
@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation ATListCell
+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *ID = @"ATListCell";
    ATListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ATListCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        //        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        cell.textLabel.font = ATTitleFont;
        cell.textLabel.textColor = ATTitleColor;
        cell.detailTextLabel.textColor = ATDescColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.contentMode = UIViewContentModeCenter;
    }
    return cell;
}

#pragma mark - setters
- (void)setItem:(ATListItem *)item {
    _item = item;
    
    // 1. 设置图标
    self.imageView.image = self.item.icon ? [UIImage imageNamed:self.item.icon] : nil;
    
    // 2. 设置标题
    self.textLabel.text = self.item.title;
    if (self.item.attrTitle) {
        self.textLabel.attributedText = self.item.attrTitle;
    }
    
    // 3. 设置cell右侧样式
    self.accessoryView = nil;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.attributedText = nil;
    self.accessoryType = UITableViewCellAccessoryNone;
    _imgView.hidden = YES;
    // 文本
    if ([self.item isKindOfClass:[ATListLabelArrowItem class]]){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        ATListLabelArrowItem *item = ((ATListLabelArrowItem *)self.item);
        self.detailTextLabel.text = item.subTitle;
        if (item.attrSubTitle) {
            self.detailTextLabel.attributedText = item.attrSubTitle;
        }
    }
    // 图片
    else if ([self.item isKindOfClass:[ATListImageArrowtem class]]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.imgView sd_setImageWithURL:[NSURL URLWithEncodeString:((ATListImageArrowtem *)self.item).rightIcon] placeholderImage:[UIImage imageNamed:@"defaultF3f3f3"]];
        self.imgView.hidden = NO;
    }
    // 开关
    else if ([self.item isKindOfClass:[ATListSwitchItem class]]) {
        self.accessoryView = self.switchButton;
        self.switchButton.on = ((ATListSwitchItem *)self.item).on;
    }
    // 箭头
    else if ([self.item isKindOfClass:[ATListArrowItem class]]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // 4. 添加自定义样式
    if (self.item.config) {
        self.item.config(self.item, self);
    }
}

- (void)didSwitchValueChange:(UISwitch *)switchButton {
    if ([self.item isKindOfClass:[ATListSwitchItem class]]) {
        ATListSwitchItem *item = ((ATListSwitchItem *)self.item);
        if (item.valueChangeBlock) {
            item.valueChangeBlock(item, switchButton);
        }
    }
}

#pragma mark - getter
- (UISwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
#ifdef APP_COLOR
        _switchButton.onTintColor = APP_COLOR;
#endif
        [_switchButton addTarget:self action:@selector(didSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchButton;
}
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_imgView.superview);
            make.top.equalTo(_imgView.superview.mas_top).offset(5);
            make.width.equalTo(_imgView.mas_height);
            make.right.equalTo(self.contentView.mas_right).offset(-2);
        }];
    }
    return _imgView;
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imgView.layer.cornerRadius = (self.contentView.height - 10)/2;
    self.imageView.frame = CGRectMake(15, (self.height-20)/2, 20, 20);
    if (self.imageView.image) {
        self.textLabel.left = 46.0f;
    }
}
@end
