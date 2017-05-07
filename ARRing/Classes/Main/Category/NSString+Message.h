//
//  NSString+Message.h
//  AT
//
//  Created by xiao6 on 14-10-22.
//  Copyright (c) 2014年 Summer. All rights reserved.
//


@interface NSString (Message)

- (NSString *)stringByTrimingWhitespace;

- (NSUInteger)numberOfLines;

- (NSRange)lineIndexWithCharIndex:(NSUInteger)charIndex;

- (BOOL)isEmoji;
- (NSString *)stringEncodeEmoji;
- (NSString *)stringDecodeEmoji;

/**
 *  输入框输入字符串过长截断
 *
 *  @param maxLength 限制的最大长度
 *
 *  @return 截断后的字符串
 */
- (NSString *)stringByTriming:(NSUInteger)maxLength;
@end
