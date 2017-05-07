//
//  ATBaseXIBCollectionCell.m
//  AT
//
//  Created by CoderLT on 15/10/23.
//  Copyright © 2015年 nopi.com. All rights reserved.
//

#import "ATBaseXIBCollectionCell.h"

@implementation ATBaseXIBCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}
- (void)setup {
    
}
+ (CGSize)cellSize {
    return [self cellSizeWithWidth:([UIScreen mainScreen].bounds.size.width)];
}
+ (CGSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, width);
}
+ (void)registerToCollectionView:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]]
     forCellWithReuseIdentifier:NSStringFromClass([self class])];
}
+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}
@end
