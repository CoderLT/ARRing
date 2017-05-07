//
//  ATBaseXIBView.m
//  AT
//
//  Created by xiao6 on 15/10/27.
//  Copyright © 2015年 AT. All rights reserved.
//

#import "ATBaseXIBView.h"

@implementation ATBaseXIBView
+ (instancetype)instanceView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}
- (void)setUp {
    
}
- (CGFloat)viewHeight {
    return [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}
+ (CGFloat)viewHeight {
    return 0.0f;
}
@end
