//
//  NSMutableDictionary+param.m
//  AT
//
//  Created by CoderLT on 15/1/27.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "NSMutableDictionary+param.h"

@implementation NSMutableDictionary (param)
- (void)addParam:(id)obj forKey:(NSString *)key
{
    if (obj != nil && key.length) {
        [self setObject:obj forKey:key];
    }
}
@end
