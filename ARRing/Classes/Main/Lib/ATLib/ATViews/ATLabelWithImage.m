//
//  ATLabelViewImage.m
//  AT
//
//  Created by Apple on 14-8-10.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "ATLabelWithImage.h"

@interface ATLabelWithImage()
{
    UILabel *label;
    UIImageView *imageView;
}

@end

@implementation ATLabelWithImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                         0,
                                                         frame.size.width,
                                                         frame.size.height)];
        [self addSubview:label];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    label.text = text;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    label.font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    label.textColor = textColor;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    if (!imageView) {
//        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        imageView = [[UIImageView alloc]initWithImage:image];
        [self addSubview:imageView];
    }
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.center = CGPointMake(imageView.center.x, self.bounds.size.height/2);
    
    label.frame = CGRectMake(imageView.frame.size.width,
                             0,
                             self.bounds.size.width - imageView.frame.size.width,
                             self.bounds.size.height);
}

- (void)setSpace:(CGFloat)space
{
    _space = space;
    CGFloat labelXpos = 0;
    if (imageView) {
        labelXpos = imageView.frame.size.width + _space;
    }
    else{
        labelXpos = _space;
    }
    label.frame = CGRectMake(labelXpos,
                             0,
                             self.bounds.size.width - imageView.frame.size.width,
                             self.bounds.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
