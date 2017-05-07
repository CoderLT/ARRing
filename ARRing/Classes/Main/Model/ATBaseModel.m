//
//  ATBaseModel.m
//  CengFanQu
//
//  Created by CoderLT on 16/2/19.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATBaseModel.h"

@implementation ATBaseModel
MJCodingImplementation

+ (void)load {
    [self mj_referenceReplacedKeyWhenCreatingKeyValues:YES];
}
- (NSString *)description {
    return [NSString stringWithFormat:@"< %@ - %p >, %@", NSStringFromClass([self class]), self, self.mj_keyValues];
}
@end
