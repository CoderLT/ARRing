//
//  ATImageTopButton.m
//  VRBOX
//
//  Created by CoderLT on 16/3/8.
//  Copyright © 2016年 VR. All rights reserved.
//

#import "ATImageTopButton.h"

@implementation ATHighlightButton
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event; {
    [super touchesBegan:touches withEvent:event];
    self.alpha = self.enabled ? 0.5f : 0.5f;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.alpha = self.enabled ? 1.0f : 0.5f;
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.alpha = self.enabled ? 1.0f : 0.5f;
}
- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.alpha = self.enabled ? 1.0f : 0.5f;
}
@end

@implementation ATImageTopButton
#define ATImageTopButtonMarging 8
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat marging = ATImageTopButtonMarging;
    CGSize textSize = AT_TEXTSIZE(self.currentTitle, self.titleLabel.font, CGSizeMake(contentRect.size.width, contentRect.size.height));
    CGSize imgSize = self.currentImage.size;
    if (contentRect.size.width > 0 && imgSize.width > contentRect.size.width) {
        imgSize.height *= contentRect.size.width / imgSize.width;
        imgSize.width = contentRect.size.width;
    }
    CGFloat maxH = (contentRect.size.height - textSize.height);
    if (maxH > 0 && imgSize.height > maxH) {
        imgSize.width *= maxH / imgSize.height;
        imgSize.height = maxH;
        marging = 2;
    }
    return CGRectMake((contentRect.size.width - imgSize.width)/2,
                      (contentRect.size.height - imgSize.height - textSize.height - marging)/2,
                      imgSize.width,
                      imgSize.height);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat marging = ATImageTopButtonMarging;
    CGSize textSize = AT_TEXTSIZE(self.currentTitle, (self.subviews.count ? self.titleLabel.font : [UIFont systemFontOfSize:14.0f]), CGSizeMake(contentRect.size.width, contentRect.size.height));
    CGSize imgSize = self.currentImage.size;
    if (contentRect.size.width > 0 && imgSize.width > contentRect.size.width) {
        imgSize.height *= contentRect.size.width / imgSize.width;
        imgSize.width = contentRect.size.width;
    }
    CGFloat maxH = (contentRect.size.height - textSize.height);
    if (maxH > 0 && imgSize.height > maxH) {
        imgSize.width *= maxH / imgSize.height;
        imgSize.height = maxH;
        marging = 2;
    }
    return CGRectMake((contentRect.size.width - textSize.width)/2,
                      (contentRect.size.height - textSize.height + imgSize.height + marging)/2,
                      textSize.width,
                      textSize.height);
}

@end


@implementation ATImageRightButton
#define ATImageTopButtonMarging 8
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGSize imgSize = self.currentImage.size;
    CGSize textSize = AT_TEXTSIZE(self.currentTitle, self.titleLabel.font, CGSizeMake(self.width, self.height));
    return CGRectMake((contentRect.size.width - imgSize.width + textSize.width + ATImageTopButtonMarging)/2,
                      (contentRect.size.height - imgSize.height)/2,
                      imgSize.width,
                      imgSize.height);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGSize imgSize = self.currentImage.size;
    CGSize textSize = AT_TEXTSIZE(self.currentTitle, (self.subviews.count ? self.titleLabel.font : [UIFont systemFontOfSize:14.0f]), CGSizeMake(self.width, self.height));
    return CGRectMake((contentRect.size.width - imgSize.width - textSize.width - ATImageTopButtonMarging)/2,
                      (contentRect.size.height - textSize.height)/2,
                      textSize.width,
                      textSize.height);
}

@end
