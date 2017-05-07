//
//  ATBannerView.m
//  VRBOX
//
//  Created by CoderLT on 16/3/8.
//  Copyright © 2016年 VR. All rights reserved.
//

#import "ATBannerView.h"
#import "ATBaseXIBCollectionCell.h"
#import <Aspects/Aspects.h>

#define kTimeInterval 3.0
#define kTotalRow ((NSUInteger)(self.adsArray.count > 1 ? 100 * self.adsArray.count : self.adsArray.count))
#define kDefaultRow (NSUInteger)(kTotalRow/2)

@interface ATBannerView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray<id<AspectToken>> *aspects;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end
@implementation ATBannerView
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
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
    self.backgroundColor = APP_COLOR_BG;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.collectionView.frame, self.bounds)) {
        self.pageControl.center = CGPointMake(self.bounds.size.width - 50, self.bounds.size.height - 15 - ([self showDesc] ? 64 : 0));
        self.collectionView.frame = self.bounds;
        ((UICollectionViewFlowLayout *)(self.collectionView.collectionViewLayout)).itemSize = self.collectionView.bounds.size;
        [self.collectionView reloadData];
    }
}

#pragma mark - getters & setters
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [ATBaseXIBCollectionCell registerToCollectionView:_collectionView];
        [self addSubview:_collectionView];
        [self sendSubviewToBack:_collectionView];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.center = CGPointMake(self.bounds.size.width - 50, self.bounds.size.height - 15 - ([self showDesc] ? 64 : 0));
        _pageControl.pageIndicatorTintColor = APP_COLOR;
        _pageControl.currentPageIndicatorTintColor = APP_COLOR_HL;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (void)setAdsArray:(NSArray *)adsArray {
    _adsArray = adsArray;
    
    self.pageControl.hidden = (_adsArray.count <= 1);
    self.pageControl.numberOfPages = _adsArray.count;
    [self.collectionView reloadData];
    
    [self displayAtPage:0];
    // 滚动到中间
    if (_adsArray.count > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:kDefaultRow inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:NO];
    }
    
    [self addTimer];
}

#pragma mark - timer dealing method
- (void)stopScroll {
    // 当被移除的时候停掉计时器
    [self removeTimer];
}
- (void)restartScroll:(BOOL)scrollImmediately {
    [self addTimer];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:kDefaultRow+self.pageControl.currentPage inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionLeft
                                        animated:NO];
    if (scrollImmediately) {
        [self dealWithTimer:self.timer];
    }
}
- (void)removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)addTimer {
    if (self.adsArray.count > 1) {
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(dealWithTimer:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kTimeInterval]];
    }
    else {
        [self removeTimer];
    }
}
- (void)dealWithTimer:(NSTimer *)theTimer
{
    if (self.adsArray.count < 1) {
        return;
    }
    NSIndexPath *visiablePath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    
    NSUInteger visiableItem = visiablePath.item;
    if ((visiablePath.item % self.adsArray.count)  == 0) { // 第0张图片
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:kDefaultRow inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        visiableItem = kDefaultRow;
    }
    
    NSUInteger nextItem = visiableItem + 1;
    if (nextItem < kTotalRow) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:YES];
    }
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kTotalRow;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSUInteger UIImageViewTag = 10002;
    ATBaseXIBCollectionCell *cell = [ATBaseXIBCollectionCell cellForCollectionView:collectionView1 indexPath:indexPath];
//    VRBannerModel *model = self.adsArray[indexPath.row % self.adsArray.count];
    UIImageView *imageView = [cell.contentView viewWithTag:UIImageViewTag];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.tag = UIImageViewTag;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(imageView.superview);
            make.height.equalTo(@(self.height - ([self showDesc] ? 64 : 0)));
        }];
    }
//    NSString *urlString = model.coverImage;
//    [imageView sd_setImageWithURL:[NSURL URLWithEncodeString:urlString] placeholderImage:[UIImage imageNamed:@"defaultF3f3f3"]];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(adsBanner:didSelectAdAtIndex:)]) {
        [_delegate adsBanner:self didSelectAdAtIndex:indexPath.row % self.adsArray.count];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *visiablePath = [collectionView indexPathForItemAtPoint:CGPointMake(collectionView.contentOffset.x + collectionView.width/2, collectionView.height/2)];
    [self displayAtPage:visiablePath.item % self.adsArray.count];
}
- (void)displayAtPage:(NSUInteger)page {
    self.pageControl.currentPage = page;
    if ([self showDesc] && self.pageControl.currentPage < self.adsArray.count) {
//        VRBannerModel *model = self.adsArray[self.pageControl.currentPage];
//        self.titleLabel.text = model.title;
//        self.descLabel.text = model.desc;
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView1 layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView1.bounds.size;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopScroll];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self restartScroll:NO];
}

#pragma mark - lifeCycle
- (void)removeFromSuperview {
    [self stopScroll];
    [self.aspects makeObjectsPerformSelector:@selector(remove)];
    
    [super removeFromSuperview];
}
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self.aspects makeObjectsPerformSelector:@selector(remove)];
    UIViewController *vc = [self getViewController];
    if (vc) {
        [self.aspects addObject:[vc aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self restartScroll:NO];
            });
        } error:nil]];
        [self.aspects addObject:[vc aspect_hookSelector:@selector(viewDidDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            [self stopScroll];
        } error:nil]];
    }
}

#pragma mark - getter
- (NSMutableArray<id<AspectToken>> *)aspects {
    if (!_aspects) {
        _aspects = [NSMutableArray array];
    }
    return _aspects;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.superview).offset(8);
            make.right.equalTo(_titleLabel.superview).offset(-8);
            make.top.equalTo(_titleLabel.superview.mas_bottom).offset(-50);
            make.height.equalTo(@19.5);
        }];
    }
    return _titleLabel;
}
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        [_descLabel setTextColor:[UIColor colorWithHexString:@"#a0a0a0"]];
        [_descLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [self addSubview:_descLabel];
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.titleLabel);
            make.leading.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
            make.height.equalTo(@14);
        }];
    }
    return _descLabel;
}
- (BOOL)showDesc {
    return NO;
}
@end

@implementation ATBannerWithDescView
- (BOOL)showDesc {
    return YES;
}
@end