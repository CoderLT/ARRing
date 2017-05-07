//
//  UIButton+Util.m
//  AT
//
//  Created by Apple on 14-8-4.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "UIButton+Util.h"

@implementation UIButton (Util)

+ (id)buttonWithFrame:(CGRect)frame
          normalImage:(UIImage *)normalImage
     highlightedImage:(UIImage *)highLightedImage
               target:(id)target
            andAction:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highLightedImage forState:UIControlStateHighlighted];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (instancetype)accessoryButton:(UIImage *)image target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    button.adjustsImageWhenHighlighted = NO;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
