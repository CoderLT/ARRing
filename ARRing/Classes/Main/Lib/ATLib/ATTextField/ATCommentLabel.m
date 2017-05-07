//
//  ATCommentLabel.m
//  AT
//
//  Created by xiao6 on 14-10-21.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "ATCommentLabel.h"
#import "UIColor+Util.h"
#import "UIView+Common.h"
#import "PPLabel.h"
#import "NSString+Message.h"
#import "UIViewController+Util.h"

@interface ATCommentLabel () <PPLabelDelegate>
{
    NSRange highlightedRange;
    NSTimer *highlightedTimer;
    UITouch *lastTouch;
}
@end

@implementation ATCommentLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
    self.textAlignment = NSTextAlignmentLeft;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    highlightedRange = NSMakeRange(NSNotFound, 0);

    // 添加键盘监听，当键盘弹起时才取消高亮状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

+ (ATCommentLabel *)lableWithAttrString:(NSAttributedString *)attrbuteString clickBlock:(ATCommentLabelClickBlockType)block
{
    ATCommentLabel *commentLable = [[ATCommentLabel alloc] initWithFrame:CGRectZero];
    commentLable.clickBlock = block;
    return commentLable;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    highlightedRange = NSMakeRange(NSNotFound, 0);
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    [self removeHighlight];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (highlightedTimer) {
        [highlightedTimer invalidate];
        lastTouch = nil;
        highlightedTimer = nil;
    }
}

#pragma mark -- PPLableDelegate

- (BOOL)label:(PPLabel *)label didBeginTouch:(UITouch *)touch
{
    lastTouch = touch;
    if (highlightedTimer) {
        [highlightedTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.3f]];
    }
    else {
        highlightedTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    }
    return YES;
}

- (BOOL)label:(PPLabel *)label didEndTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex lineRect:(CGRect)lineRect
{
    if (charIndex != NSNotFound) {
        NSRange line = [self.text lineIndexWithCharIndex:charIndex];
        if (_clickBlock) {
            UIViewController *vc = [self getViewController];
            if (vc) {
                vc.currentFocus = self;
                vc.currentFocusRect = lineRect;
            }
            [self highlightWordContainingCharacterAtIndex:charIndex];
            _clickBlock(line);
            return YES;
        }
    }
    [self removeHighlight];
    return YES;
}

- (BOOL)label:(PPLabel *)label didCancelTouch:(UITouch *)touch
{
    [self removeHighlight];
    return YES;
}

- (void)timerFired
{
    ATLog(@"timerFierd (%f, %f)", [lastTouch locationInView:self].x, [lastTouch locationInView:self].y);
    [self highlightWordContainingCharacterAtIndex:[self characterIndexAtPoint:[lastTouch locationInView:self]
                                                                 containCRLF:YES
                                                                    lineRect:nil]];
}

#pragma mark --
- (void)highlightWordContainingCharacterAtIndex:(CFIndex)charIndex {
    
    if (highlightedTimer) {
        [highlightedTimer invalidate];
        lastTouch = nil;
        highlightedTimer = nil;
    }
    
    if (charIndex==NSNotFound) {
        //user did nat click on any word
        [self removeHighlight];
        return;
    }
    
    NSString* string = self.text;
    
    //compute the positions of space characters next to the charIndex
    NSRange end = [string rangeOfString:@"\n" options:0 range:NSMakeRange(charIndex, string.length - charIndex)];
    NSRange front = [string rangeOfString:@"\n" options:NSBackwardsSearch range:NSMakeRange(0, charIndex)];
    
    if (front.location == NSNotFound) {
        front.location = 0; //first word was selected
        front.length = 0;
    }
    
    if (end.location == NSNotFound) {
        end.location = string.length - 1; //last word was selected
        end.length = 1;
    }
    
    NSRange wordRange = NSMakeRange(front.location, end.location + end.length - front.location);
    
    if (front.location!=0) { //fix trimming
        wordRange.location += 1;
        wordRange.length -= 1;
    }
    
    if (wordRange.location == highlightedRange.location && wordRange.length == highlightedRange.length) {
        return; //this word is already highlighted
    }
    else {
        [self removeHighlight]; //remove highlight on previously selected word
    }
    
    //highlight selected word
    NSMutableAttributedString* attributedString = [self.attributedText mutableCopy];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithHexString:@"#e0e0e0"] range:wordRange];
    self.attributedText = attributedString;
    
    highlightedRange = wordRange;
}

- (void)removeHighlight {
    if (highlightedTimer) {
        [highlightedTimer invalidate];
        lastTouch = nil;
        highlightedTimer = nil;
    }
    if (highlightedRange.location != NSNotFound && self.text.length) {
        
        if (self.text.length < highlightedRange.location + highlightedRange.length) {
            highlightedRange = NSMakeRange(0, self.text.length);
        }
        //remove highlight from previously selected word
        NSMutableAttributedString* attributedString = [self.attributedText mutableCopy];
        [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:highlightedRange];
        self.attributedText = attributedString;
    }
    highlightedRange = NSMakeRange(NSNotFound, 0);
}



@end
