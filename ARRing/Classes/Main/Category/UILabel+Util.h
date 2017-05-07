//
//  UILabel+Util.h
//  AT
//
//  Created by Apple on 14-8-4.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Util)

/**
 *  快速创建普通的Label
 *
 *  @param frame     位置信息
 *  @param fontSize  字体大小
 *  @param hexString 字体颜色,十六进制形式,以#开头
 *  @param isBold    是否使用粗体
 *
 *  @return UILabel
 */
+ (id)labelWithFrame:(CGRect)frame
            fontSize:(CGFloat)fontSize
           textColor:(NSString *)hexString
              isBold:(BOOL)isBold;
/**
 *  自适应label高度
 *
 *  @param content  label的text,需要自适应的内容
 *  @param width    label的宽度
 *  @param fontSize 字体大小
 *
 *  @return 调整后的label的高度
 */
+ (float)heightForText:(NSString *)content
                 width:(float)width
              fontSize:(CGFloat)fontSize;

@end
