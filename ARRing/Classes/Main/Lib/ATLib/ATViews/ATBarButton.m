//
//  ATBarButton.m
//  AT
//
//  Created by xiao6 on 15/10/2.
//  Copyright © 2015年 AT. All rights reserved.
//

#import "ATBarButton.h"

@implementation ATBarButton
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
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    ATBarButton *button = [super buttonWithType:buttonType];
    if (button) {
        [button setup];
    }
    return button;
}
- (void)setup {
    self.adjustsImageWhenHighlighted = NO;
    [self setFrame:CGRectMake(0, 0, 44, 44)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, -4)];
    if ([UIBarButtonItem appearance].tintColor) {
        [self setTintColor:[UIBarButtonItem appearance].tintColor];
    }
    NSDictionary *dic = [[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal];
    if (dic[NSForegroundColorAttributeName]) {
        [self setTitleColor:dic[NSForegroundColorAttributeName] forState:UIControlStateNormal];
    }
    else {
        [self setTitleColor:[UIColor colorWithRed:(0x44/255.0f) green:(0x44/255.0f) blue:(0x44/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    }
    if (dic[NSFontAttributeName]) {
        [self.titleLabel setFont:dic[NSFontAttributeName]];
    }
    else {
        [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
}
+ (instancetype)buttonWithImage:(UIImage *)image title:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action {
    ATBarButton *customItem = [self buttonWithType:UIButtonTypeCustom];
    [customItem addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (image) {
        [customItem setImage:image forState:UIControlStateNormal];
    }
    if (title) {
        [customItem setTitle:title forState:UIControlStateNormal];
    }
    if (color) {
        [customItem setTitleColor:color forState:UIControlStateNormal];
    }
    return customItem;
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self sizeToFit];
}
- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state {
    [super setAttributedTitle:title forState:state];
    [self sizeToFit];
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self sizeToFit];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
{
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
