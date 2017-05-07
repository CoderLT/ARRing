//
//  SATextFieldCell.m
//  SmartAquarium
//
//  Created by CoderLT on 16/5/2.
//  Copyright © 2016年 SA. All rights reserved.
//

#import "ATLoginTextFieldCell.h"

@implementation ATLoginTextFieldCell
+ (instancetype)cellForTableView:(UITableView *)tableView identifier:(NSString *)identifier config:(void (^)(id))config {
    return [super cellForTableView:tableView identifier:identifier config:^(ATTextFieldCell *cell) {
        cell.textField.layer.borderColor = TableViewSeparatorColor.CGColor;
        cell.textField.layer.borderWidth = 1;
        cell.textField.layer.cornerRadius = 2;
        cell.textField.clipsToBounds = YES;
        cell.textField.inset = UIEdgeInsetsMake(0, 8, 0, 8);
        cell.textField.font = ATTitleFont;
        cell.textField.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        if (config) {
            config(cell);
        }
    }];
}
@end


@implementation ATPhoneCell

+ (instancetype)cellForTableView:(UITableView *)tableView identifier:(NSString *)identifier config:(void (^)(id))config {
    return [super cellForTableView:tableView identifier:identifier config:^(ATTextFieldCell *cell) {
//        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_phone_gray"]];
//        iconView.contentMode = UIViewContentModeScaleAspectFit;
//        iconView.frame = CGRectMake(0, 0, 40, 20);
//        cell.textField.leftView = iconView;
//        cell.textField.leftViewMode = UITextFieldViewModeAlways;
//        cell.textField.inset = UIEdgeInsetsMake(0, 0, 0, 8);
        cell.textField.placeholder = ATLocalizedString(@"Login_Phone", @"手机号");
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.secureTextEntry = NO;
        
        [cell setTextDidChange:^NSUInteger(ATTextCell *cell, NSString *text) {
            return 11;
        }];
        if (config) {
            config(cell);
        }
    }];
}

@end


@implementation ATPasswordCell

+ (instancetype)cellForTableView:(UITableView *)tableView identifier:(NSString *)identifier config:(void (^)(id))config {
    return [super cellForTableView:tableView identifier:identifier config:^(ATTextFieldCell *cell) {
//        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password_gray"]];
//        iconView.contentMode = UIViewContentModeScaleAspectFit;
//        iconView.frame = CGRectMake(0, 0, 40, 20);
//        cell.textField.leftView = iconView;
//        cell.textField.leftViewMode = UITextFieldViewModeAlways;
//        cell.textField.inset = UIEdgeInsetsMake(0, 0, 0, 8);
        
        UIButton *eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        eyeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [eyeButton setImage:[UIImage imageNamed:@"login_eye"] forState:UIControlStateNormal];
        [eyeButton setImage:[UIImage imageNamed:@"login_eye_selected"] forState:UIControlStateSelected];
        [eyeButton addTarget:cell action:@selector(didClickRightButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:eyeButton];
        [eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(eyeButton.superview);
            make.right.equalTo(cell.textField).offset(-4);
            make.width.equalTo(@(40));
            make.height.equalTo(@(15));
        }];
        
        cell.textField.placeholder = ATLocalizedString(@"Login_Password", @"密码");
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.secureTextEntry = YES;
        cell.textField.inset = UIEdgeInsetsMake(0, cell.textField.inset.left, 0, 40 + 14);
        
        [cell setTextDidChange:^NSUInteger(ATTextCell *cell, NSString *text) {
            return 20;
        }];
        if (config) {
            config(cell);
        }
    }];
}
- (void)didClickRightButton:(UIButton *)eyeButton {
    eyeButton.selected = !eyeButton.selected;
    self.textField.secureTextEntry = !eyeButton.selected;
}
@end


@interface ATSmsCodeCell () {
    int timeCount;
}
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation ATSmsCodeCell

+ (instancetype)cellForTableView:(UITableView *)tableView identifier:(NSString *)identifier config:(void (^)(id))config {
    return [super cellForTableView:tableView identifier:identifier config:^(ATSmsCodeCell *cell) {
//        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_smscode_gray"]];
//        iconView.contentMode = UIViewContentModeScaleAspectFit;
//        iconView.frame = CGRectMake(0, 0, 40, 20);
//        cell.textField.leftView = iconView;
//        cell.textField.leftViewMode = UITextFieldViewModeAlways;
//        cell.textField.inset = UIEdgeInsetsMake(0, 0, 0, 8);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font    = [UIFont systemFontOfSize:16];
        [button setTitle:ATLocalizedString(@"Login_CAPTCHA", @"获取验证码") forState:UIControlStateNormal];
        [button setTitleColor:APP_TitleButtonColor forState:UIControlStateNormal];
        [button setTitleColor:APP_TitleButtonColorHL forState:UIControlStateHighlighted];
        button.backgroundColor = [UIColor whiteColor];
//        button.layer.borderColor = TableViewSeparatorColor.CGColor;
//        button.layer.borderWidth = 1;
//        button.layer.cornerRadius = 2;
//        button.clipsToBounds = YES;
        [button addTarget:cell action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(button.superview);
            make.right.equalTo(cell.textField).offset(-4);
            make.width.equalTo(@(120));
            make.height.equalTo(@(38));
        }];
        cell.button = button;
        
        cell.textField.placeholder = ATLocalizedString(@"Please enter the CAPTCHA", @"验证码");
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.inset = UIEdgeInsetsMake(0, cell.textField.inset.left, 0, 120 + 4);
        
        [cell setTextDidChange:^NSUInteger(ATTextCell *cell, NSString *text) {
            return 6;
        }];
        if (config) {
            config(cell);
        }
    }];
}

- (void)didClickButton:(id)sender {
    if (self.didClickButton) {
        self.didClickButton(self);
    }
}

- (void)setGetSMSCodeDelay {
    [self setGetSMSCodeDelay:30];
}
- (void)setGetSMSCodeDelay:(NSUInteger)delay {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(updateTime)
                                                userInfo:nil
                                                 repeats:YES];
    timeCount = (int)delay;
    [self updateTime];
}

- (void)updateTime
{
    if (--timeCount > 0) {
        self.button.enabled = NO;
        [self.button setTitle:[NSString stringWithFormat:@"%ds", timeCount] forState:UIControlStateNormal];
    }
    else {
        [self.timer invalidate];
        [self.button setTitle:ATLocalizedString(@"Login_CAPTCHA", @"获取验证码") forState:UIControlStateNormal];
        self.button.enabled = YES;
    }
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self.timer invalidate];
}
- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end