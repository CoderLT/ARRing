//
//  ATSheetView.m
//  AT
//
//  Created by CoderLT on 15/11/17.
//  Copyright © 2015年 AT. All rights reserved.
//

#import "ATSheetView.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"

@interface ATSheetView()
{
    BOOL _comfirm;
}
@end

@implementation ATSheetView
- (instancetype)init {
    return [self initWithTitle:nil];
}
- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.type = MMPopupTypeSheet;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        _btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionCancel)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.top.equalTo(self);
        }];
        [self.btnCancel setTitle:ATLocalizedString(@"Cancel", @"取消") forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:APP_COLOR forState:UIControlStateNormal];
        
        _btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(actionConfirm)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.top.equalTo(self);
        }];
        [self.btnConfirm setTitle:ATLocalizedString(@"Confirm", @"确定") forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:APP_COLOR forState:UIControlStateNormal];
        
        if (title.length > 0) {
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.font = [UIFont systemFontOfSize:14.0f];
            _titleLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0f];
            _titleLabel.numberOfLines = 0;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.text = title;
            [self addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.btnCancel.mas_right).offset(12);
                make.right.equalTo(self.btnConfirm.mas_left).offset(-12);
                make.top.greaterThanOrEqualTo(self.titleLabel.superview).offset(12);
                make.centerY.equalTo(self.btnCancel.mas_centerY).priorityLow();
            }];
        }
        
        _contentView= [[UIView alloc] init];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView.superview);
            make.top.equalTo(self.btnCancel.mas_bottom).priorityMedium();
            if (self.titleLabel) {
                make.top.greaterThanOrEqualTo(self.titleLabel.mas_bottom).offset(4);
            }
        }];
    }
    return self;
}

- (void)actionCancel {
    [self hide];
}

- (void)actionConfirm {
    _comfirm = YES;
    [self hide];
}

- (void)setDismissCompletion:(void (^)(ATSheetView *, BOOL))completion {
    __weak typeof(self) weakSelf = self;
    [self setHideCompletionBlock:^(MMPopupView *view, BOOL finish) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (completion) {
            completion(strongSelf, strongSelf->_comfirm);
        }
    }];
}
@end
