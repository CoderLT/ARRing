//
//  ATNoDataView.m
//  VRBOX
//
//  Created by CoderLT on 16/4/8.
//  Copyright © 2016年 VR. All rights reserved.
//

#import "ATNoDataView.h"

@implementation ATNoDataView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
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
- (void)setup {
    
}

#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView  = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imageView.superview);
            make.centerY.equalTo(_imageView.superview).offset(-48);
        }];
    }
    return _imageView;
}
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = ATPlaceholderColor;
        _descLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_descLabel];
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageView);
            make.top.equalTo(self.imageView.mas_bottom).offset(30);
        }];
    }
    return _descLabel;
}
@end
