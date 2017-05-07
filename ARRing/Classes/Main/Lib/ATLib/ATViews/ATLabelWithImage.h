//
//  ATLabelViewImage.h
//  AT
//
//  Created by Apple on 14-8-10.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

/**
 *  实现带image的label
 *  image显示在label的左侧
 */

#import <UIKit/UIKit.h>

@interface ATLabelWithImage : UIView

@property (nonatomic, strong) UIImage  *image;    // 图片
@property (nonatomic, strong) NSString *text;     // label的文字
@property (nonatomic, strong) UIColor  *textColor;// label文字颜色
@property (nonatomic, strong) UIFont   *font;     // label的字体
@property (nonatomic, assign) CGFloat   space;    // image和label之间的距离

@end
