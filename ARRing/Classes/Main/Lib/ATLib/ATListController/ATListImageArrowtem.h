//
//  ATListImageArrowtem.h
//  CengFanQu
//
//  Created by CoderLT on 16/2/20.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATListArrowItem.h"

@interface ATListImageArrowtem : ATListArrowItem

/**
 *  右侧图标
 */
@property (nonatomic, copy) NSString *rightIcon;

+ (instancetype)itemWithTitle:(NSString *)title rightIcon:(NSString *)rightIcon;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title rightIcon:(NSString *)rightIcon;
+ (instancetype)itemWithTitle:(NSString *)title rightIcon:(NSString *)rightIcon destVcClass:(Class)destVcClass;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title rightIcon:(NSString *)rightIcon destVcClass:(Class)destVcClass;
@end
