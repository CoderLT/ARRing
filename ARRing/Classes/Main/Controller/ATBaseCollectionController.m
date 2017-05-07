//
//  ATBaseCollectionController.m
//  VRBOX
//
//  Created by CoderLT on 16/3/24.
//  Copyright © 2016年 VR. All rights reserved.
//

#import "ATBaseCollectionController.h"

@interface ATBaseCollectionController ()

@end

@implementation ATBaseCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.collectionView.superview);
    }];
}


#pragma mark - Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [UICollectionViewCell new];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 8;
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        CGFloat w = (self.view.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing) / 2;
        layout.itemSize = CGSizeMake(w, w * 3 / 4);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

@end
