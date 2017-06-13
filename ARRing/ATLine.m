//
//  ATLine.m
//  ARRing
//
//  Created by CoderLT on 2017/5/23.
//  Copyright © 2017年 AT. All rights reserved.
//

#import "ATLine.h"
#import <YYKit.h>

@implementation ATLine
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)push:(float)value {
    [self.datas addObject:@(value)];
    if (self.datas.count > LineCount) {
        [self.datas removeFirstObject];
    }
    else if (self.datas.count < LineCount) {
        while (self.datas.count < LineCount) {
            [self.datas addObject:@(value)];
        }
    }
}
- (float)value {
    NSArray *array = self.datas.copy;
    array = [array sortedArrayUsingComparator:^NSComparisonResult(NSNumber * _Nonnull obj1, NSNumber * _Nonnull obj2) {
        return (obj1.floatValue > obj2.floatValue) ? NSOrderedAscending : NSOrderedDescending;
    }];
    float sum = 0;
    for (int i = LineCount/3; i < LineCount * 2 / 3; i++) {
        sum += [array[i] floatValue];
    }
    return sum * 3 / LineCount;
}
@end
