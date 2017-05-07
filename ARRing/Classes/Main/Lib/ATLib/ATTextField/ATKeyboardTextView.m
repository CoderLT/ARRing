//
//  ATKeyboardTextView.m
//  AT
//
//  Created by xiao6 on 14-10-23.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "ATKeyboardTextView.h"
#import "UIColor+Util.h"
#import "UIButton+Util.h"
#import "UIView+Common.h"
#import "UIViewController+Util.h"
#import "NSString+Message.h"

#define kXpos 15
#define kYpos 7
#define KEYBOARD_TEXTVIEW_HEIGHT (35.5+kYpos*2+1)

@interface ATKeyboardTextView () <ATTextViewDelegate>
{
    ATTextBaseView *inputTextView;
    UIButton *emojiButton;
}
@end

@implementation ATKeyboardTextView

+ (ATKeyboardTextView *)inputViewHidden:(BOOL)defaultHidden textWillSend:(void (^)(id, NSString *))block
{
    ATKeyboardTextView *keyboardTextView = [[ATKeyboardTextView alloc] initWithFrame:CGRectZero];
    keyboardTextView.defaultHidden = defaultHidden;
    keyboardTextView.textWillSendBlock = block;
    keyboardTextView.hidden = keyboardTextView.defaultHidden;
    return keyboardTextView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (inputTextView) {
        inputTextView.frame = CGRectMake(kXpos,
                                         kYpos,
                                         self.width - kXpos - (emojiButton ? emojiButton.width : kXpos),
                                         self.height - 2*kYpos - 1);
    }
}

- (void)showWithPlaceholder:(NSString *)placeholder params:(id)params
{
    self.params = params;
    inputTextView.placeholder = placeholder;
    [inputTextView becomeFirstResponder];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc
{
    _textWillSendBlock = nil;
}

- (void)adjustCurrentFocusScrollViewFrame:(BOOL)keyboardHidden
{
    UIViewController *vc = [self getViewController];
    
    if (keyboardHidden) {
        if (vc == nil || vc.currentTextFiledChangeView == nil || CGRectEqualToRect(vc.currentTextFiledChangeView.frame, vc.currentTextFailedChangeViewOldFrame)) {
            return;
        }
        vc.currentTextFiledChangeView.frame = vc.currentTextFailedChangeViewOldFrame;
        vc.currentTextFiledChangeView = nil;
        vc.currentFocus = nil;
        return;
    }
    
    if (vc == nil || vc.currentFocus == nil) {
        return;
    }
    UIScrollView *mutableSuperView = [vc.currentFocus getSuperScrollView];
    if (mutableSuperView == nil) {
        return;
    }
    CGRect newScrollViewFrame = mutableSuperView.frame;
    newScrollViewFrame.size.height = self.frame.origin.y - newScrollViewFrame.origin.y;
    if (vc.currentTextFiledChangeView == mutableSuperView
        && vc.currentTextFiledChangeView.frame.size.height == newScrollViewFrame.size.height) {
        return;
    }
    vc.currentTextFiledChangeView = mutableSuperView;
    vc.currentTextFiledChangeView.frame = newScrollViewFrame;
    
    // 滚动到当前输入框
    if (CGRectIsEmpty(vc.currentFocusRect) || !CGRectContainsRect(vc.currentFocus.bounds, vc.currentFocusRect)) {
        vc.currentFocusRect = vc.currentFocus.bounds;
    }
    CGRect rect = [vc.currentFocus convertRect:vc.currentFocusRect toView:vc.currentTextFiledChangeView];
    ((UIScrollView *)vc.currentTextFiledChangeView).contentOffset = CGPointMake(0,
                                                                                MAX(-NAVI_HIGHT,
                                                                                    CGRectGetMaxY(rect) - self.frame.origin.y));
}

- (void)keyboardChangeFrame:(NSNotification *)notification
{
    UIViewController *vc = [self getViewController];
    
    // 1. 如果当前第一响应者不是自己 则不需要动作
    if (vc == nil || vc.currentInput != inputTextView) {
        return;
    }
    
    // 2. 根据键盘高度 计算inputTextView的位置
    CGRect keyboardRect = [vc.view convertRect:[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                                      fromView:nil];
    if (keyboardRect.origin.y == SCREEN_HEIGHT) {
        return;
    }
    CGRect newTextViewFrame = self.frame;
    newTextViewFrame.origin.y = keyboardRect.origin.y - self.height;
    
    // 2. 显示inputTextView
    self.hidden = NO;
    
    // 3. 获取键盘动画参数，启动动画.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    
    self.frame = newTextViewFrame;
    [self adjustCurrentFocusScrollViewFrame:NO];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // 1. 已经是默认状态
    if (self.frame.origin.y == SCREEN_HEIGHT - self.height && self.hidden == self.defaultHidden) {
        return;
    }
    
    // 2. 获取键盘动画参数，启动动画.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    
    self.frame = CGRectMake(0, SCREEN_HEIGHT - self.height, self.width, self.height);
    self.hidden = self.defaultHidden;
    [self adjustCurrentFocusScrollViewFrame:YES];
    
    [UIView commitAnimations];
}

- (void)setup
{
    inputTextView = [[ATTextBaseView alloc] initWithFrame:CGRectZero];
    inputTextView.returnKeyType = UIReturnKeySend;
    inputTextView.enablesReturnKeyAutomatically = YES;
    inputTextView.placeholder = ATLocalizedString(@"Send new comments", @"发送新评论");
    inputTextView.layer.borderColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    inputTextView.layer.borderWidth = 0.65f;
    inputTextView.layer.cornerRadius = 6.0f;
    inputTextView.ATDelegate = self;
    [self addSubview:inputTextView];
    
//    emojiButton = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH - 55, kYpos, 55, 44)
//                                normalImage:[UIImage imageNamed:@"message_emoji"]
//                           highlightedImage:[UIImage imageNamed:@"message_emoji_selected"]
//                                     target:self
//                                  andAction:@selector(clickEmoji:)];
    [self addSubview:emojiButton];
    
    // 顶部分割线
    UIView *spLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    spLine.backgroundColor = [UIColor colorWithHexString:@"#bfbfbf"];
    [self addSubview:spLine];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    self.frame = CGRectMake(0, SCREEN_HEIGHT - KEYBOARD_TEXTVIEW_HEIGHT, SCREEN_WIDTH, KEYBOARD_TEXTVIEW_HEIGHT);
}

- (void)clickEmoji:(UIButton *)button
{
    ATLog(@"clickEmoji");
}

#pragma mark - ATTextViewDelegate
- (void)textViewDidChange:(ATTextBaseView *)textView
{
    float maxHeight = 73.5f;
    float changeHeight = MIN(maxHeight, [textView sizeThatFits:CGSizeMake(textView.width, MAXFLOAT)].height) - textView.height;
    CGRect newFrame = self.frame;
    newFrame.size.height = MAX(newFrame.size.height + changeHeight, KEYBOARD_TEXTVIEW_HEIGHT);
    if (newFrame.size.height != self.height) {
        newFrame.origin.y -= newFrame.size.height - self.height;
        [UIView animateWithDuration:0.01f
                         animations:^{
                             self.frame = newFrame;
                         }
                         completion:^(BOOL finished) {
                             [textView scrollRangeToVisible:[textView selectedRange]];
                         }];
    }
}

- (BOOL)textViewShouldReturn:(ATTextBaseView *)textView
{
    if (_textWillSendBlock) {
        _textWillSendBlock(self.params, textView.text);
    }
    textView.text = nil;
    [self textViewDidChange:textView];
    return YES;
}
@end
