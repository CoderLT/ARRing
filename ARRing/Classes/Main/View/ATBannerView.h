//
//  ATBannerView.h
//  VRBOX
//
//  Created by CoderLT on 16/3/8.
//  Copyright © 2016年 VR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATBannerView;

@protocol ATBannerViewDelegate <NSObject>

- (void)adsBanner:(ATBannerView *)banner didSelectAdAtIndex:(NSInteger)index;

@end
@interface ATBannerView : UIView
/**
 *  轮播广告位 模型数组
 */
@property (nonatomic, strong) NSArray *adsArray;
/**
 *  代理
 */
@property (nonatomic, assign) id<ATBannerViewDelegate> delegate;


- (void)stopScroll;
- (void)restartScroll:(BOOL)scrollImmediately;
@end

@interface ATBannerWithDescView : ATBannerView
@end