//
//  ATColorButton.h
//  CengFanQu
//
//  Created by CoderLT on 16/2/19.
//  Copyright © 2016年 AT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATColorButton : UIButton

- (void)setup;
+ (instancetype)buttonWithFrame:(CGRect)frame
                         target:(id)target
                         action:(SEL)action;
+ (instancetype)buttonWithFrame:(CGRect)frame
                          image:(UIImage *)image
               highlightedImage:(UIImage *)highlightedImage
                  disabledImage:(UIImage *)disabledImage
                         target:(id)target
                         action:(SEL)action;

@end


@interface ATAppButton : ATColorButton

@end