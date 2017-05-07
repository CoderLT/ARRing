//
//  ATCircleImageView.m
//  CengFanQu
//
//  Created by CoderLT on 16/2/26.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATCircleImageView.h"

@implementation ATCircleImageView
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.layer.borderColor = ATNotifyColor.CGColor;
    self.layer.borderWidth = 1.0f;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.frame.size.width/2;
}
@end
