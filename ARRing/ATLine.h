//
//  ATLine.h
//  ARRing
//
//  Created by CoderLT on 2017/5/23.
//  Copyright © 2017年 AT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LineCount 9
@interface ATLine : NSObject
@property (nonatomic, strong) NSMutableArray *datas;

- (void)push:(float)value;
- (float)value;
@end
