//
//  ATListLabelArrowItem.h
//  AT
//
//  Created by Apple on 15/3/28.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "ATListArrowItem.h"

@interface ATListLabelArrowItem : ATListArrowItem

/**
 *  副标题, 也可以是NSAttributeString类型
 */
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSAttributedString *attrSubTitle;

+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle;
+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle destVcClass:(Class)destVcClass;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle destVcClass:(Class)destVcClass;
@end
