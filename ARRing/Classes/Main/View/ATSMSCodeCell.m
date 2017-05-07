//
//  ATSMSCodeCell.m
//  CengFanQu
//
//  Created by CoderLT on 16/2/20.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATSMSCodeCell.h"

@interface ATSMSCodeCell () {
    int timeCount;
}

@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation ATSMSCodeCell

+ (CGFloat)cellHeight {
    return 49;
}

+ (instancetype)cellForTableView:(UITableView *)tableView identifier:(NSString *)identifier config:(void (^)(id))config {
    return [super cellForTableView:tableView identifier:identifier config:^(ATSMSCodeCell *cell) {
        cell.selectionStyle            = UITableViewCellSelectionStyleNone;
        cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.textField.textColor       = ATTitleColor;
        cell.textField.font            = ATTitleFont;
        cell.textField.placeholder     = ATLocalizedString(@"Please enter the CAPTCHA", @"请输入验证码");
        cell.textField.keyboardType    = UIKeyboardTypePhonePad;
        cell.textField.layer.borderColor = TableViewSeparatorColor.CGColor;
        cell.textField.layer.borderWidth = 1;
        cell.textField.layer.cornerRadius = 2;
        cell.textField.clipsToBounds = YES;
        cell.textField.inset = UIEdgeInsetsMake(0, 8, 0, 8);
        cell.textField.font = ATTitleFont;
        cell.textField.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.button.titleLabel.font    = [UIFont systemFontOfSize:16];
        [cell.button setTitle:ATLocalizedString(@"CAPTCHA", @"获取验证码") forState:UIControlStateNormal];
        [cell.button setTitleColor:APP_TitleButtonColor forState:UIControlStateNormal];
        [cell.button setTitleColor:APP_TitleButtonColorHL forState:UIControlStateHighlighted];
        cell.button.backgroundColor = [UIColor whiteColor];
        cell.button.layer.borderColor = TableViewSeparatorColor.CGColor;
        cell.button.layer.borderWidth = 1;
        cell.button.layer.cornerRadius = 2;
        cell.button.clipsToBounds = YES;

        if (config) {
            config(cell);
        }
    }];
}
- (IBAction)didClickButton:(id)sender {
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
        [self.button setTitle:ATLocalizedString(@"CAPTCHA", @"验证码") forState:UIControlStateNormal];
        self.button.enabled = YES;
    }
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [_timer invalidate];
    _timer = nil;
}
- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}
@end
