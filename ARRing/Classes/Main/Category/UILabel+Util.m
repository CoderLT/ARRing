//
//  UILabel+Util.m
//  AT
//
//  Created by Apple on 14-8-4.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "UILabel+Util.h"
#import "UIColor+Util.h"

@implementation UILabel (Util)

+ (id)labelWithFrame:(CGRect)frame
            fontSize:(CGFloat)fontSize
           textColor:(NSString *)hexString
              isBold:(BOOL)isBold;
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    if (isBold) {
        label.font = [UIFont boldSystemFontOfSize:fontSize];
    }
    else{
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    label.textColor = [UIColor colorWithHexString:hexString];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (float)heightForText:(NSString *)content width:(float)width fontSize:(CGFloat)fontSize
{
    CGSize sizeToFit = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]}
                                             context:nil].size;
//    [content sizeWithFont:[UIFont systemFontOfSize:fontSize]
//                           constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
//                               lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat height = sizeToFit.height;
    return height;
}

@end
