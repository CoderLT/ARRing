//
//  ATTextCell.m
//  AT
//
//  Created by CoderLT on 15/10/25.
//  Copyright © 2015年 nopi.com. All rights reserved.
//

#import "ATTextCell.h"
#import <KVOController/KVOController.h>
#import "NSString+Message.h"

@interface ATTextCell ()

@end

@implementation ATTextCell
+ (instancetype)cellForTableView:(UITableView *)tableView identifier:(NSString *)identifier config:(void (^)(id))config {
    return [super cellForTableView:tableView identifier:identifier config:^(ATTextCell *cell){
        if (!cell.textField && !cell.textView) {
            [NSException raise:NSStringFromClass([self class]) format:@"继承自NPTextCell必须有textFiled 或者 textView 属性"];
        }
        else {
            if ([cell textField]) {
                [[NSNotificationCenter defaultCenter] addObserver:cell
                                                         selector:@selector(textFieldDidChange:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:[cell textField]];
            }
            if ([cell textView]) {
                [[NSNotificationCenter defaultCenter] addObserver:cell
                                                         selector:@selector(textViewDidChange:)
                                                             name:UITextViewTextDidChangeNotification
                                                           object:[cell textView]];
            }
        }
        if (config) {
            config(cell);
        }
    }];
}
- (void)textFieldDidChange:(NSNotification *)notification {
    if (self.textDidChange) {
        if (!self.textField.markedTextRange) {
            NSUInteger maxLength = self.textDidChange(self, self.textField.text);
            self.textField.text = [self.textField.text stringByTriming:maxLength];
        }
    }
}
- (void)textViewDidChange:(NSNotification *)notification {
    if (self.textDidChange) {
        if (!self.textView.markedTextRange) {
            NSUInteger maxLength = self.textDidChange(self, self.textView.text);
            self.textView.text = [self.textView.text stringByTriming:maxLength];
        }
    }
}

#pragma mark - getter
- (ATTextField *)textField {
    return nil;
}
- (ATTextView *)textView {
    return nil;
}
@end
