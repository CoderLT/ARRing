//
//  ATTextField.m
//  TurnTable
//
//  Created by Summer on 14-3-18.
//  Copyright (c) 2014年 xiao6 Studio. All rights reserved.
//

#import "ATTextField.h"
#import "UIView+Common.h"
#import "UIViewController+Util.h"

@implementation ATTextField
{
    ATTextFieldDelegeteImp *delegateImp;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.returnKeyType = UIReturnKeyDone;
    self.backgroundColor = [UIColor clearColor];
    delegateImp = [[ATTextFieldDelegeteImp alloc]init];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.delegate = delegateImp;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    return CGRectMake(rect.origin.x + self.inset.left,
                      rect.origin.y + self.inset.top,
                      rect.size.width - self.inset.left - self.inset.right,
                      rect.size.height - self.inset.top - self.inset.bottom);
}
- (CGRect)borderRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    return CGRectMake(rect.origin.x + self.inset.left,
                      rect.origin.y + self.inset.top,
                      rect.size.width - self.inset.left - self.inset.right,
                      rect.size.height - self.inset.top - self.inset.bottom);
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    return CGRectMake(rect.origin.x + self.inset.left + 2,
                      rect.origin.y + self.inset.top,
                      rect.size.width - self.inset.left - 2 - self.inset.right,
                      rect.size.height - self.inset.top - self.inset.bottom);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    return CGRectMake(rect.origin.x + self.inset.left,
                      rect.origin.y + self.inset.top,
                      rect.size.width - self.inset.left - self.inset.right,
                      rect.size.height - self.inset.top - self.inset.bottom);
}
- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect rect = [super clearButtonRectForBounds:bounds];
    return CGRectMake(rect.origin.x - self.inset.right,
                      rect.origin.y + self.inset.top - self.inset.bottom,
                      rect.size.width,
                      rect.size.height);
}
- (void)setATDelegate:(id<ATTextFieldDelegate>)textFieldDelegate
{
    // 响应链传递
    _ATDelegate = textFieldDelegate;
    delegateImp.delegate = _ATDelegate;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    UIViewController *vc = [self getViewController];
    
    // 添加手势
    if (vc.tapGestureRecognizer == nil) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:vc
                                                                                               action:@selector(didTapAnywhere:)];
        [vc.view addGestureRecognizer:tapGestureRecognizer];
        vc.tapGestureRecognizer = tapGestureRecognizer;
        vc.tapGestureRecognizer.enabled = NO;
    }
    
    // 添加监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
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

#pragma mark -- 键盘状态 高度改变
- (void)keyboardWillShow:(NSNotification *)notification
{
    UIViewController *vc = [self getViewController];
    if(self != vc.currentInput){
        return;
    }
    UIScrollView * mutableSuperView = [self getSuperScrollView];
    if (!(vc && mutableSuperView)) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];

    keyboardRect = [vc.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = mutableSuperView.frame;
    newTextViewFrame.size.height = keyboardTop - mutableSuperView.frame.origin.y;
    
    if (vc.currentTextFiledChangeView != nil ) {
        if (vc.currentTextFiledChangeView == mutableSuperView
            && vc.currentTextFiledChangeView.frame.size.height == newTextViewFrame.size.height) {
            return;
        }
    }
    
    // Get keyboard's duration of the animation and curve.
    NSTimeInterval animationDuration;
    [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    UIViewAnimationCurve animationCurve;
    [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    vc.currentTextFiledChangeView = mutableSuperView;
    if (newTextViewFrame.size.height != 0 && newTextViewFrame.size.width != 0) {
        vc.currentTextFiledChangeView.frame = newTextViewFrame;
    }
    [UIView commitAnimations];
    
//    ATLog(@"change: %@, %f ==> %f", vc, vc.currentTextFailedChangeViewOldFrame.size.height, newTextViewFrame.size.height);
    
    //滚动到当前输入框
    UIScrollView *scrollView = (UIScrollView *)vc.currentTextFiledChangeView;
    CGRect rect = [vc.currentInput convertRect:vc.currentInput.bounds toView:vc.currentTextFiledChangeView];
    [scrollView scrollRectToVisible:rect animated:YES];
    
    // 使能手势
    if (vc.tapGestureRecognizer != nil) {
        vc.tapGestureRecognizer.enabled = YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIViewController *vc = [self getViewController];
    if (vc == nil || vc.currentTextFiledChangeView == nil) {
        return;
    }
    if (self != vc.currentInput) {
        return;
    }
    // Get keyboard's duration of the animation and curve.
    NSTimeInterval animationDuration;
    [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    UIViewAnimationCurve animationCurve;
    [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    if (vc.currentTextFailedChangeViewOldFrame.size.height != 0 && vc.currentTextFailedChangeViewOldFrame.size.width != 0) {
        vc.currentTextFiledChangeView.frame = vc.currentTextFailedChangeViewOldFrame;
    }
    [UIView commitAnimations];
//    ATLog(@"hide: %@, %f ==> %f", vc, vc.currentTextFailedChangeViewOldFrame.size.height, vc.currentTextFiledChangeView.frame.size.height);
    
    //滚动到当前输入框
    UIScrollView *scrollView = (UIScrollView *)vc.currentTextFiledChangeView;
    CGRect rect = [vc.currentInput
                   convertRect:vc.currentInput.bounds
                   toView:vc.currentTextFiledChangeView];
    [scrollView scrollRectToVisible:rect animated:YES];
    vc.currentTextFiledChangeView = nil;
    
    // 禁用手势
    if (vc.tapGestureRecognizer != nil) {
        vc.tapGestureRecognizer.enabled = NO;
    }
}

@end

#pragma mark -- ATTextFieldDelegeteImp
@implementation ATTextFieldDelegeteImp
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [_delegate textFieldDidBeginEditing:textField];
    }
    UIViewController *vc = [textField getViewController];
    if (vc != nil) {
        vc.currentInput = textField;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIViewController *vc = [textField getViewController];
    if (vc != nil) {
        if (vc.currentInput == textField) {
            [vc currentInputResignFirstResponder];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.delegate textFieldShouldReturn:textField];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_delegate && [_delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [_delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIViewController *vc = [textField getViewController];
    if (vc != nil) {
        if (vc.currentInput == textField) {
            [vc currentInputResignFirstResponder];
        }
    }

    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_delegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [_delegate textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [_delegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [_delegate textFieldShouldEndEditing:textField];
    }
    return YES;
}
@end


