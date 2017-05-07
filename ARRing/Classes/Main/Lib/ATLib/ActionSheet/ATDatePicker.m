//
//  ATDatePicker
//  AT
//
//  Created by ATDatePicker on 15/11/15.
//  Copyright © 2015年 AT. All rights reserved.
//

#import "ATDatePicker.h"
#import <MMPopupView/MMPopupDefine.h>
#import <MMPopupView/MMPopupCategory.h>
#import <Masonry/Masonry.h>

@interface ATDatePicker()


@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;

@end

@implementation ATDatePicker


- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(216+50);
        }];
        
        self.btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionCancel)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.top.equalTo(self);
        }];
        [self.btnCancel setTitle:ATLocalizedString(@"Cancel", @"取消") forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:APP_COLOR forState:UIControlStateNormal];
        
        
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(actionConfirm)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.top.equalTo(self);
        }];
        [self.btnConfirm setTitle:ATLocalizedString(@"Confirm", @"确定") forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:APP_COLOR forState:UIControlStateNormal];
        
        self.datePicker= [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [self addSubview:self.datePicker];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 0, 0, 0));
        }];
    }
    
    return self;
}

- (void)actionCancel {
    [self hide];
    self.dateDidChange = nil;
}

- (void)actionConfirm {
    [self hide];
    
    if (self.dateDidChange) {
        self.dateDidChange(self.datePicker);
        self.dateDidChange = nil;
    }
}

@end
