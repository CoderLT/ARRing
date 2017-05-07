//
//  ATListArrowItem.h
//  AT
//
//  Created by Apple on 15/3/28.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "ATListItem.h"

@interface ATListArrowItem : ATListItem

/**
 *  点击这行cell要跳转到哪个控制器
 */
@property (nonatomic, assign) Class destClass;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;

@end
