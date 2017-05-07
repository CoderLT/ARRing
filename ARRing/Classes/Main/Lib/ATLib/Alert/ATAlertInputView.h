//
//  ATAlertInputView.h
//  CengFanQu
//
//  Created by CoderLT on 16/2/24.
//  Copyright © 2016年 AT. All rights reserved.
//

#import <MMPopupView/MMPopupView.h>

typedef BOOL(^ATAlertInputViewConfig)(NSUInteger index, UITextField *textField);
typedef BOOL(^ATAlertInputViewHandler)(NSUInteger index, NSArray<NSString *> *texts);
typedef BOOL(^ATAlertInputViewTextShouldChange)(NSUInteger index, NSString *oldText, NSString *newText, UIButton *confirmButton);

@interface ATAlertInputView : MMPopupView

/**
 *  显示一个带输入框的弹窗
 *
 *  @param title                 标题
 *  @param inputConfig           输入框样式设置(UIKeyboardType\placeholder等), 输入框的个数返回BOOL参数决定, YES则继续配置下一个输入框
 *  @param textShouldChangeValue 输入框值改变时回调函数(BOOL: 返回是否允许修改, index: 输入框编号, oldText: 输入框原始文本, newText: 输入框改变后的文本, confirm: 确定按钮)
 *  @param inputHandler          按钮点击回调(BOOL: 是否允许消失, index: 被点击的按钮编号 texts: 输入框文本数组)
 *
 *  @return 弹窗实例
 */
+ (instancetype)showWithTitle:(NSString *)title
                  inputConfig:(ATAlertInputViewConfig)inputConfig
        textShouldChangeValue:(ATAlertInputViewTextShouldChange)textShouldChangeValue
                      handler:(ATAlertInputViewHandler)inputHandler;
@end
