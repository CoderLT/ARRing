//
//  PPLabel.m
//  PPLabel
//
//  Created by Petr Pavlik on 12/26/12.
//  Copyright (c) 2012 Petr Pavlik. All rights reserved.
//

#import "PPLabel.h"
#import <CoreText/CoreText.h>
#import "NSString+Message.h"

@interface PPLabel ()

@property(nonatomic, strong) NSSet* lastTouches;

@end

@implementation PPLabel

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point containCRLF:(BOOL)containCRLF lineRect:(CGRect *)lineRect{
    
    ////////
    
    NSMutableAttributedString* optimizedAttributedText = [self.attributedText mutableCopy];
    
    // use label's font and lineBreakMode properties in case the attributedText does not contain such attributes
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, [self.attributedText length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if (!attrs[(NSString*)kCTFontAttributeName]) {
            
            [optimizedAttributedText addAttribute:(NSString*)kCTFontAttributeName value:self.font range:NSMakeRange(0, [self.attributedText length])];
        }
        
        if (!attrs[(NSString*)kCTParagraphStyleAttributeName]) {
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:self.lineBreakMode];
            
            [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        }
    }];
    
    // modify kCTLineBreakByTruncatingTail lineBreakMode to kCTLineBreakByWordWrapping
    [optimizedAttributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
        
        if ([paragraphStyle lineBreakMode] == kCTLineBreakByTruncatingTail) {
            [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        }
        
        [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
        [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
    }];
    
    ////////
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = [self textRect];
    
    // 允许点击换行符
    if (containCRLF) {
        textRect.size.width = self.bounds.size.width;
    }
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    //////
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CFRange stringRange = CFRangeMake(0, self.attributedText.length);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, stringRange, path, NULL);
    
    CFRelease(framesetter);
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    //ATLog(@"num lines: %d", numberOfLines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
            // 允许点击换行符
            else if (containCRLF) {
                CFRange lineRange = CTLineGetStringRange(line);
                idx = lineRange.location + lineRange.length - 1;
                break;
            }
        }
    }
    
    // 计算所在段的 Rect
    if (idx != NSNotFound && lineRect) {
        NSRange end = [self.text rangeOfString:@"\n" options:0 range:NSMakeRange(idx, self.text.length - idx)];
        NSRange front = [self.text rangeOfString:@"\n" options:NSBackwardsSearch range:NSMakeRange(0, idx)];
        if (front.location == NSNotFound) {
            front.location = 0; //first word was selected
            front.length = 0;
        }
        if (end.location == NSNotFound) {
            end.location = self.text.length - 1; //last word was selected
            end.length = 1;
        }
        NSRange lineRange = NSMakeRange(front.location, end.location + end.length - front.location);
        if (front.location!=0) { //fix trimming
            lineRange.location += 1;
            lineRange.length -= 1;
        }
        lineRect->origin.x = self.bounds.origin.x;
        lineRect->size.width = self.bounds.size.width;
        lineRect->origin.y = 0;
        lineRect->size.height = 0;
        for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
            CFRange range = CTLineGetStringRange(CFArrayGetValueAtIndex(lines, lineIndex));
            // 1.lineIndex 行末字符  在点击行之前
            if (range.location + range.length - 1 < lineRange.location) {
                lineRect->origin.y += self.bounds.size.height / numberOfLines;;
            }
            // 2.lineIndex 在点击行内
            else if (range.location + range.length <= lineRange.location + lineRange.length) {
                lineRect->size.height += self.bounds.size.height / numberOfLines;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}

#pragma mark --

- (CGRect)textRect {
    
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height)/2;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width)/2;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }
    
    return textRect;
}


#pragma mark --

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.lastTouches = touches;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(label:didBeginTouch:onCharacterAtIndex:lineRect:)]) {
        UITouch *touch = [touches anyObject];
        CFIndex index = [self characterIndexAtPoint:[touch locationInView:self] containCRLF:YES lineRect:nil];
        
        if ([self.delegate label:self didBeginTouch:touch onCharacterAtIndex:index lineRect:CGRectZero]) {
            return;
        }
    }
    else if(self.delegate && [self.delegate respondsToSelector:@selector(label:didBeginTouch:)]){
        if ([self.delegate label:self didBeginTouch:[touches anyObject]]) {
            return;
        }
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.lastTouches = touches;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(label:didMoveTouch:onCharacterAtIndex:lineRect:)]) {
        UITouch *touch = [touches anyObject];
        CFIndex index = [self characterIndexAtPoint:[touch locationInView:self] containCRLF:YES lineRect:nil];
        if ([self.delegate label:self didMoveTouch:touch onCharacterAtIndex:index lineRect:CGRectZero]) {
            return;
        }
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!self.lastTouches) {
        return;
    }
    
    self.lastTouches = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(label:didEndTouch:onCharacterAtIndex:lineRect:)]) {
        
        UITouch *touch = [touches anyObject];
        CGRect lineRect = CGRectZero;
        CFIndex index = [self characterIndexAtPoint:[touch locationInView:self] containCRLF:YES lineRect:&lineRect];
        
        if ([self.delegate label:self didEndTouch:touch onCharacterAtIndex:index lineRect:lineRect]) {
            return;
        }
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!self.lastTouches) {
        return;
    }
    
    self.lastTouches = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(label:didCancelTouch:)]) {
        if ([self.delegate label:self didCancelTouch:[touches anyObject]]) {
            return;
        }
    }
    [super touchesCancelled:touches withEvent:event];
}

- (void)cancelCurrentTouch {
    if (self.lastTouches) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(label:didCancelTouch:)]) {
            [self.delegate label:self didCancelTouch:[self.lastTouches anyObject]];
        }
        self.lastTouches = nil;
    }
}

@end
