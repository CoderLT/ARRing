//
//  ATBaseXIBCollectionCell.h
//  AT
//
//  Created by CoderLT on 15/10/23.
//  Copyright © 2015年 nopi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NIB_NAME NSStringFromClass([self class])

@interface ATBaseXIBCollectionCell : UICollectionViewCell

- (void)setup;
+ (CGSize)cellSize;
+ (CGSize)cellSizeWithWidth:(CGFloat)width;
+ (void)registerToCollectionView:(UICollectionView *)collectionView;
+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@end
