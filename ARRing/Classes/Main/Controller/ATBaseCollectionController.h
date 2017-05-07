//
//  ATBaseCollectionController.h
//  VRBOX
//
//  Created by CoderLT on 16/3/24.
//  Copyright © 2016年 VR. All rights reserved.
//

#import "ATBaseController.h"

@interface ATBaseCollectionController : ATBaseController <UICollectionViewDelegate, UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end
