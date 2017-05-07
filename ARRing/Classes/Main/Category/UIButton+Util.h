//
//  UIButton+Util.h
//  AT
//
//  Created by Apple on 14-8-4.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Util)

/**
 *  快速创建普通的UIButton
 *
 *  @param frame            位置信息
 *  @param normalImage      默认状态下的图片
 *  @param highLightedImage 高亮状态下的图片
 *  @param target           目标
 *  @param action           执行方法
 *
 *  @return 创建的button
 */
+ (id)buttonWithFrame:(CGRect)frame
          normalImage:(UIImage *)normalImage
     highlightedImage:(UIImage *)highLightedImage
               target:(id)target
            andAction:(SEL)action;

+ (instancetype)accessoryButton:(UIImage *)image target:(id)target action:(SEL)action;

@end
