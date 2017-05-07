//
//  NSString+Message.m
//  AT
//
//  Created by xiao6 on 14-10-22.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "NSString+Message.h"
@implementation NSString (Message)

- (NSString *)stringByTrimingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfLines {
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}

- (NSRange)lineIndexWithCharIndex:(NSUInteger)charIndex
{
    NSRange line = NSMakeRange(0, charIndex);
    NSArray *lineArray = [self componentsSeparatedByString:@"\n"];
    
    for (NSString *str in lineArray) {
        if (charIndex > str.length + 1) {
            charIndex -= str.length + 1;
            line.location++;
        }
        else {
            line.length = charIndex;
            break;
        }
    }
//    ATLog(@"lineIndexWithCharIndex %d %d, ",line.location, line.length);
    
    return line;
}

- (BOOL)isEmoji
{
    BOOL returnValue = NO;
    const unichar hs = [self characterAtIndex:0];
    // surrogate pair
    if (0xd800 <= hs && hs <= 0xdbff) {
        if (self.length > 1) {
            const unichar ls = [self characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f) {
                returnValue = YES;
            }
        }
    } else if (self.length > 1) {
        const unichar ls = [self characterAtIndex:1];
        if (ls == 0x20e3) {
            returnValue = YES;
        }

    } else {
        // non surrogate
        if (0x2100 <= hs && hs <= 0x27ff) {
            returnValue = YES;
        } else if (0x2B05 <= hs && hs <= 0x2b07) {
            returnValue = YES;
        } else if (0x2934 <= hs && hs <= 0x2935) {
            returnValue = YES;
        } else if (0x3297 <= hs && hs <= 0x3299) {
            returnValue = YES;
        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
            returnValue = YES;
        }
    }
    return returnValue;
}

- (NSString *)stringEncodeEmoji {
    NSMutableString *encodeString = [NSMutableString string];
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         if ([substring isEmoji]) {
             [encodeString appendString:[substring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
         }
         else {
             [encodeString appendString:substring];
         }
     }];

    return [encodeString copy];
}

- (NSString *)stringDecodeEmoji {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)stringByTriming:(NSUInteger)maxLength {
    maxLength = maxLength ?: NSUIntegerMax;
    if (maxLength < self.length) {
        NSString *last = [self substringWithRange:NSMakeRange(maxLength - 1, 2)];
        return [self substringToIndex:[self isEmoji:last] ? (maxLength - 1) : maxLength];
    }
    return self;
}
- (BOOL)isEmoji:(NSString *)subString {
    NSString *regex =  @"[\\ud800\\udc00-\\udbff\\udfff\\ud800-\\udfff]" ;
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @" SELF MATCHES %@ " , regex];
    return [predicate evaluateWithObject:subString];
}
@end
