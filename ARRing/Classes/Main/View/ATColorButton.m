//
//  ATColorButton.m
//  CengFanQu
//
//  Created by CoderLT on 16/2/19.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATColorButton.h"

@implementation ATColorButton

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    ATColorButton *button = [super buttonWithType:buttonType];
    if (button) {
        [button setup];
    }
    return button;
}
- (void)setup {
    self.adjustsImageWhenDisabled = NO;
    self.adjustsImageWhenHighlighted = NO;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 2;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
+ (instancetype)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action {
    return [self buttonWithFrame:frame image:nil highlightedImage:nil disabledImage:nil target:target action:action];
}
+ (instancetype)buttonWithFrame:(CGRect)frame image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage disabledImage:(UIImage *)disabledImage target:(id)target action:(SEL)action {
    ATColorButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (highlightedImage) {
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    if (disabledImage) {
        [button setImage:disabledImage forState:UIControlStateDisabled];
    }
    return button;
}

@end

@implementation ATAppButton

- (void)setup {
    [super setup];
    [self setBackgroundImage:[UIImage imageWithColor:APP_TitleButtonColor] forState:UIControlStateNormal];
#ifdef APP_TitleButtonColorHL
    [self setBackgroundImage:[UIImage imageWithColor:APP_TitleButtonColorHL] forState:UIControlStateHighlighted];
#endif
#ifdef APP_TitleButtonColorDis
    [self setBackgroundImage:[UIImage imageWithColor:APP_TitleButtonColorHL] forState:UIControlStateDisabled];
#endif
#ifdef APP_TitleButtonColorSel
    [self setBackgroundImage:[UIImage imageWithColor:APP_TitleButtonColorSel] forState:UIControlStateSelected];
#endif
}
- (void)layoutSubviews {
    [super layoutSubviews];
//    self.layer.cornerRadius = self.height/2;
}
@end
